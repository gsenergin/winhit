{******************************************************************************}
{                                                                              }
{                              UNIT Serialization                              }
{                                                                              }
{  � ���� ������ ����������� ������������ ������� � �������� �����.            }
{  This unit contains an implementation of object stream serialization.        }
{                                                                              }
{                       Copyright � 2010 by Xcentric                           }
{                                                                              }
{http://code.google.com/p/powered-by-delphi/                                   }
{******************************************************************************}

{

  ������� ������ / VERSION HISTORY:

  (1.1 | 17.12.2010)
    [+] ��������� ����������� ������������ ��������� ��������.

  (1.0 | 10.10.2010)
    ������ ����� ������.
    First unit release.

}

unit Serialization;

{$BOOLEVAL OFF}

interface

uses
  Classes, SysUtils, RTTI, TypInfo;

type

  /// ��������� �������������� ������:
  ISerializable = interface (IInvokable)
    procedure LoadFromStream(const Stream : TStream);
    procedure SaveToStream(const Stream : TStream);
  end;

  /// ������������� �����:
{$RTTI EXPLICIT METHODS([vcPrivate, vcProtected, vcPublic, vcPublished])
                PROPERTIES([vcPrivate, vcProtected, vcPublic, vcPublished])
				        FIELDS([vcPrivate, vcProtected, vcPublic, vcPublished])}
  TSerializable = class abstract (TInterfacedPersistent, ISerializable)
    private
      function GetRTTIMemberValue(const Member : TRTTIMember) : TValue;
    protected
      function GetDataSize(const Member : TRTTIMember) : Int64; virtual;
      function ReadValue(const Stream : TStream; const Member : TRTTIMember;
                         const TypeInfo : PTypeInfo) : TValue; virtual;
      procedure WriteValue(const Stream : TStream; const Value : TValue;
                           const DataSize : Int64); virtual;
    public
      procedure LoadFromStream(const Stream : TStream); virtual; final;
      procedure SaveToStream(const Stream : TStream); virtual; final;
  end;

  /// Class reference to TSerializable:
  TSerializableClass = class of TSerializable;

  /// ���������� � ���� � ������� ������:
  TDataInfo = packed record
    TypeInfo : TTypeInfo;
    Size : Int64;
  end;

implementation

//-----------------------------{ TSerializable }--------------------------------

/// ����������� ������� �����/������� � ������:
function TSerializable.GetDataSize(const Member : TRTTIMember) : Int64;
  var
    SS : TStringStream;
begin
  With GetRTTIMemberValue(Member) do
  begin
    If IsEmpty Then Exit(0) Else Result := DataSize;  // Default value

    // ���������� ������ ������:
    Case Kind of
      tkUString, tkWString, tkLString:
        begin
          SS := TStringStream.Create;
          Try
            SS.WriteString(AsString);  // All strings saves in Unicode
            Result := SS.Size;
          Finally
            FreeAndNil(SS);
          End;
        end;

      tkClass:
        begin
          // ��������� �� ������ �� ���������:
          If IsInstanceOf(TSerializable) Then
            Result := AsObject.InstanceSize
          Else
            Result := 0;
        end;

      { TODO : ����� �� ��������� ������ ��������� �� ������? }
      tkDynArray: Inc(Result, TypeData.ArrayData.Size);

      { TODO : tkInterface, tkClassRef, tkPointer }
    End;
  end;
end;

/// ��������� TValue-�������� �� TRTTIMember'�, ����������� ����� ��� ���������:
function TSerializable.GetRTTIMemberValue(const Member : TRTTIMember) : TValue;
begin
  Assert((Member is TRTTIField) Or (Member is TRTTIProperty));

  If (Member is TRTTIField)    Then
    Result := (Member as TRTTIField).GetValue(Self);
  If (Member is TRTTIProperty) Then
    Result := (Member as TRTTIProperty).GetValue(Self);
end;

/// �������������� ������� �� ������:
procedure TSerializable.LoadFromStream(const Stream : TStream);
  var
    RTTIContext : TRTTIContext;
    RTTIField : TRTTIField;
    RTTIProperty : TRTTIProperty;
begin
  // ����:
  For RTTIField in RTTIContext.GetType(Self.ClassType).GetDeclaredFields do
    RTTIField.SetValue(Self, ReadValue(Stream, RTTIField,
                                       RTTIField.FieldType.Handle));

  // ��������:
  For RTTIProperty in RTTIContext.GetType(Self.ClassType).GetDeclaredProperties do
    If (RTTIProperty.IsReadable And RTTIProperty.IsWritable) Then
      RTTIProperty.SetValue(Self, ReadValue(Stream, RTTIProperty,
                                            RTTIProperty.PropertyType.Handle));
end;

/// ������ ���������� � ������ ��������:
function TSerializable.ReadValue(const Stream : TStream; const Member : TRTTIMember;
                                 const TypeInfo : PTypeInfo) : TValue;
  var
    Buffer : Pointer;
    DataInfo : TDataInfo;

    SS : TStringStream;
    AnsiStr : AnsiString;
    UnicodeStr : String;
begin
  Stream.ReadBuffer(DataInfo, SizeOf(TDataInfo));
  Assert(DataInfo.TypeInfo.Kind = TypeInfo^.Kind);

  Case DataInfo.TypeInfo.Kind of
    tkUString, tkWString, tkLString:
      begin
        SS := TStringStream.Create;
        Try
          SS.CopyFrom(Stream, DataInfo.Size);

          If (DataInfo.TypeInfo.Kind <> tkLString) Then
          begin
            UnicodeStr := SS.DataString;
            TValue.Make(@UnicodeStr, TypeInfo, Result);
          end
          Else
          begin
            AnsiStr := AnsiString(SS.DataString);
            TValue.Make(@AnsiStr, TypeInfo, Result);
          end;
        Finally
          FreeAndNil(SS);
        End;
      end;

    tkClass:
      begin
        Assert((Member is TRTTIField) Or (Member is TRTTIProperty));

        If (Member is TRTTIField)    Then
          Result := (Member as TRTTIField).GetValue(Self);
        If (Member is TRTTIProperty) Then
          Result := (Member as TRTTIProperty).GetValue(Self);

        // 1) ��������� ��������� �� ����� ������ TSerializable,
        //    �� ������������ � ��������� �������� ���� ��� �����.
        // 2) ��������� ���� ������� ������ �� �� ����� ��-�� ������������
        //    ���������� ���������� � ������������ ��� ������ � �������������
        //    �������� ��� ������ � ���� �������, �� TValue ����� �� �������.
        // 3) �� �������������� �����: ������������, ��� ������ � ��������
        //    �������-���������� ��� ������ � �������� TSerializable,
        //    ������� ������ �������� ��� ����� LoadFromStream.

        If DataInfo.Size <> 0 Then  // ��������� ������ ���������� �������
        begin
          If Result.IsInstanceOf(TSerializable) Then
            TSerializable(Result.AsObject).LoadFromStream(Stream);
        end;
      end;

    else
      begin
      Buffer := AllocMem(DataInfo.Size);
      Try
        Stream.ReadBuffer(Buffer^, DataInfo.Size);
        TValue.Make(Buffer, TypeInfo, Result);
      Finally
        FreeMem(Buffer);
      End;
    end;
  End;
end;

/// ������������ ������� � �����:
procedure TSerializable.SaveToStream(const Stream : TStream);
  var
    RTTIContext : TRTTIContext;
    RTTIField : TRTTIField;
    RTTIProperty : TRTTIProperty;
begin
  // ����:
  For RTTIField in RTTIContext.GetType(Self.ClassType).GetDeclaredFields do
    WriteValue(Stream, RTTIField.GetValue(Self), GetDataSize(RTTIField));

  // ��������:
  For RTTIProperty in RTTIContext.GetType(Self.ClassType).GetDeclaredProperties do
    If (RTTIProperty.IsReadable And RTTIProperty.IsWritable) Then
      WriteValue(Stream, RTTIProperty.GetValue(Self), GetDataSize(RTTIProperty));
end;

/// ������ �������� � �����:
procedure TSerializable.WriteValue(const Stream : TStream; const Value : TValue;
                                   const DataSize : Int64);
  var
    DataInfo : TDataInfo;
    SS : TStringStream;
begin
  // ���������� ���������� � ���� ������������ ������:
  DataInfo.TypeInfo := Value.TypeInfo^;
  DataInfo.Size := DataSize;
  Stream.WriteBuffer(DataInfo, SizeOf(TDataInfo));

  // ���������� ������:
  Case Value.TypeInfo.Kind of
    tkUString, tkWString, tkLString:
      begin
        SS := TStringStream.Create;
        Try
          SS.WriteString(Value.AsString);  // All strings saves in Unicode
          SS.Position := 0;
          Stream.CopyFrom(SS, SS.Size);
        Finally
          FreeAndNil(SS);
        End;
      end;

    tkClass:
      begin
        // ��������� �� ������ �� ���������:
        If Value.IsInstanceOf(TSerializable) Then
          (Value.AsObject as TSerializable).SaveToStream(Stream);
      end;

    else
      Stream.WriteBuffer(Value.GetReferenceToRawData^, DataSize);
  end;
end;

end.

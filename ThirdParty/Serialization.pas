{******************************************************************************}
{                                                                              }
{                              UNIT Serialization                              }
{                                                                              }
{  В этом модуле реализована сериализация объекта в двоичный поток.            }
{  This unit contains an implementation of object stream serialization.        }
{                                                                              }
{                       Copyright © 2010 by Xcentric                           }
{                                                                              }
{http://code.google.com/p/powered-by-delphi/                                   }
{******************************************************************************}

{

  ИСТОРИЯ ВЕРСИЙ / VERSION HISTORY:

  (1.1 | 17.12.2010)
    [+] Добавлена возможность сериализации вложенных объектов.

  (1.0 | 10.10.2010)
    Первый релиз модуля.
    First unit release.

}

unit Serialization;

{$BOOLEVAL OFF}

interface

uses
  Classes, SysUtils, RTTI, TypInfo;

type

  /// Интерфейс сериализуемого класса:
  ISerializable = interface (IInvokable)
    procedure LoadFromStream(const Stream : TStream);
    procedure SaveToStream(const Stream : TStream);
  end;

  /// Сериализуемый класс:
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

  /// Информация о типе и размере данных:
  TDataInfo = packed record
    TypeInfo : TTypeInfo;
    Size : Int64;
  end;

implementation

//-----------------------------{ TSerializable }--------------------------------

/// Определение размера полей/свойств в байтах:
function TSerializable.GetDataSize(const Member : TRTTIMember) : Int64;
  var
    SS : TStringStream;
begin
  With GetRTTIMemberValue(Member) do
  begin
    If IsEmpty Then Exit(0) Else Result := DataSize;  // Default value

    // Рассмотрим особые случаи:
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
          // Указатель на объект не сохраняем:
          If IsInstanceOf(TSerializable) Then
            Result := AsObject.InstanceSize
          Else
            Result := 0;
        end;

      { TODO : нужно ли учитывать размер указателя на массив? }
      tkDynArray: Inc(Result, TypeData.ArrayData.Size);

      { TODO : tkInterface, tkClassRef, tkPointer }
    End;
  end;
end;

/// Получение TValue-значения из TRTTIMember'а, являющегося полем или свойством:
function TSerializable.GetRTTIMemberValue(const Member : TRTTIMember) : TValue;
begin
  Assert((Member is TRTTIField) Or (Member is TRTTIProperty));

  If (Member is TRTTIField)    Then
    Result := (Member as TRTTIField).GetValue(Self);
  If (Member is TRTTIProperty) Then
    Result := (Member as TRTTIProperty).GetValue(Self);
end;

/// Десериализация объекта из потока:
procedure TSerializable.LoadFromStream(const Stream : TStream);
  var
    RTTIContext : TRTTIContext;
    RTTIField : TRTTIField;
    RTTIProperty : TRTTIProperty;
begin
  // Поля:
  For RTTIField in RTTIContext.GetType(Self.ClassType).GetDeclaredFields do
    RTTIField.SetValue(Self, ReadValue(Stream, RTTIField,
                                       RTTIField.FieldType.Handle));

  // Свойства:
  For RTTIProperty in RTTIContext.GetType(Self.ClassType).GetDeclaredProperties do
    If (RTTIProperty.IsReadable And RTTIProperty.IsWritable) Then
      RTTIProperty.SetValue(Self, ReadValue(Stream, RTTIProperty,
                                            RTTIProperty.PropertyType.Handle));
end;

/// Чтение следующего в потоке значения:
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

        // 1) Поскольку сохранять мы умеем только TSerializable,
        //    то беспокоиться и проводить проверку типа нет нужды.
        // 2) Поскольку сами создать объект мы не можем из-за неизвестного
        //    количества параметров в конструкторе его класса и невозможности
        //    привести тип предка к типу потомка, то TValue здесь не поможет.
        // 3) Из вышеуказанного вывод: предполагаем, что объект в свойстве
        //    объекта-контейнера уже создан и является TSerializable,
        //    поэтому просто вызываем его метод LoadFromStream.

        If DataInfo.Size <> 0 Then  // Загружаем только сохранённые объекты
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

/// Сериализация объекта в поток:
procedure TSerializable.SaveToStream(const Stream : TStream);
  var
    RTTIContext : TRTTIContext;
    RTTIField : TRTTIField;
    RTTIProperty : TRTTIProperty;
begin
  // Поля:
  For RTTIField in RTTIContext.GetType(Self.ClassType).GetDeclaredFields do
    WriteValue(Stream, RTTIField.GetValue(Self), GetDataSize(RTTIField));

  // Свойства:
  For RTTIProperty in RTTIContext.GetType(Self.ClassType).GetDeclaredProperties do
    If (RTTIProperty.IsReadable And RTTIProperty.IsWritable) Then
      WriteValue(Stream, RTTIProperty.GetValue(Self), GetDataSize(RTTIProperty));
end;

/// Запись значения в поток:
procedure TSerializable.WriteValue(const Stream : TStream; const Value : TValue;
                                   const DataSize : Int64);
  var
    DataInfo : TDataInfo;
    SS : TStringStream;
begin
  // Записываем информацию о типе записываемых данных:
  DataInfo.TypeInfo := Value.TypeInfo^;
  DataInfo.Size := DataSize;
  Stream.WriteBuffer(DataInfo, SizeOf(TDataInfo));

  // Записываем данные:
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
        // Указатель на объект не сохраняем:
        If Value.IsInstanceOf(TSerializable) Then
          (Value.AsObject as TSerializable).SaveToStream(Stream);
      end;

    else
      Stream.WriteBuffer(Value.GetReferenceToRawData^, DataSize);
  end;
end;

end.

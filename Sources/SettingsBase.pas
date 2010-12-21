unit SettingsBase;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, Classes, SysUtils, RTTI, TypInfo, DeHL.Serialization.Binary,
  XMLDoc, XMLIntf, XMLDOM, DeHL.Serialization.XML,
  INIFiles, DeHL.Serialization.INI;

type

  /// <summary>
  ///  ������� �����-������ ��� �������� ���������� ����-����.
  /// </summary>
  TSettingsBase = class abstract (TPersistent)
    strict private
      FSettingsFile : TFileName;
    private
      procedure InitXML(var XML : TXMLDocument);
      procedure SetFileName(const FileName : TFileName; out Local : TFileName);
    protected
      procedure SetSettingsFile(const Value : TFileName);
    public
      procedure Assign(Source : TPersistent); override;

      procedure LoadFromStream(const Stream : TStream); virtual;
      procedure SaveToStream(const Stream : TStream); virtual;
      procedure LoadFromINI(const FileName : TFileName = ''); virtual;
      procedure SaveToINI(const FileName : TFileName = ''); virtual;
      procedure LoadFromXML(const FileName : TFileName = ''); virtual;
      procedure SaveToXML(const FileName : TFileName = ''); virtual;

      function  SetUp(const Target : TPersistent) : Boolean;

      property SettingsFile : TFileName read FSettingsFile write SetSettingsFile;
  end;

implementation

{ TSettingsBase }

/// <summary>
///  ���������� �������� ���������� �� ������ ��������� � ������.
///  ������������ ��� �������� ����� ��� DeHL.Serialization.Ini, �������
///  ����� Deserialize � ������ ����������� ������������ �� ����� �
///  ����������������� ������.
/// </summary>
procedure TSettingsBase.Assign(Source: TPersistent);
  var
    Ctx1, Ctx2   : TRTTIContext;
    Prop1, Prop2 : TRTTIProperty;
begin
  If Source is Self.ClassType Then
  begin

    For Prop1 in Ctx1.GetType(Self.ClassType).GetProperties do
    begin
      If Prop1.IsWritable Then
      begin

        For Prop2 in Ctx2.GetType(Source.ClassType).GetProperties do
        begin
          If AnsiSameText(Prop1.Name, Prop2.Name) And Prop2.IsReadable Then
          begin
            Prop1.SetValue(Self, Prop2.GetValue(Source));
            Break;
          end;
        end;

      end;
    end;

    Exit;
  end;
  Inherited Assign(Source);
end;

/// <summary>
///  ��������� ������������� XML-���������.
/// </summary
/// <param name="XML">
///  ������������� ���������� XML-���������.
/// </param>
procedure TSettingsBase.InitXML(var XML: TXMLDocument);
begin
  With XML do
  begin
    DOMVendor := GetDOMVendor('MSXML');
    Options := [doNodeAutoCreate, doNodeAutoIndent, doAttrNull];
    ParseOptions := [poPreserveWhiteSpace];
    NodeIndentStr := #9;  // Tab
    Active := True;
    Version := '1.0';
    Encoding := 'UTF-8';
    StandAlone := 'yes';
    AddChild('config');
    Active := True;
  end;
end;

/// <summary>
///  �������� �������� �� INI-�����.
/// </summary>
/// <param name="FileName">
///  ���� � �����, �� �������� ����� ��������� ���������.
/// </param>
procedure TSettingsBase.LoadFromINI(const FileName: TFileName);
  var
    sFileName : TFileName;
    INIFile : TINIFile;
    INIConfig : TINISerializer<TSettingsBase>;
    TmpObj : TSettingsBase;
begin
  SetFileName(FileName, sFileName);
  Assert(FileExists(sFileName));

  INIFile := TINIFile.Create(sFileName);
  INIConfig := TINISerializer<TSettingsBase>.Create;

  Try
    INIConfig.Deserialize(TmpObj, INIFile);
    Self.Assign(TmpObj);
  Finally
    FreeAndNil(INIConfig);
    FreeAndNil(INIFile);
    FreeAndNil(TmpObj);
  End;
end;

/// <summary>
///  �������� �������� �� ��������� ������.
/// </summary
/// <param name="Stream">
///  �����, �� �������� ����� ��������� ���������.
/// </param>
procedure TSettingsBase.LoadFromStream(const Stream: TStream);
  var
    StreamConfig : TBinarySerializer<TSettingsBase>;
    TmpObj : TSettingsBase;
begin
  Assert(Assigned(Stream));

  StreamConfig := TBinarySerializer<TSettingsBase>.Create;

  Try
    StreamConfig.Deserialize(TmpObj, Stream);
    Self.Assign(TmpObj);
  Finally
    FreeAndNil(StreamConfig);
    FreeAndNil(TmpObj);
  End;
end;

/// <summary>
///  �������� �������� �� XML-�����.
/// </summary>
/// <param name="FileName">
///  ���� � �����, �� �������� ����� ��������� ���������.
/// </param>
procedure TSettingsBase.LoadFromXML(const FileName: TFileName);
  var
    sFileName : TFileName;
    Cmp : TComponent;
    XML : TXMLDocument;
    XMLConfig : TXMLSerializer<TSettingsBase>;
    TmpObj : TSettingsBase;
begin
  SetFileName(FileName, sFileName);
  Assert(FileExists(sFileName));

  Cmp := TComponent.Create(nil);
  XML := TXMLDocument.Create(Cmp);
  InitXML(XML);
  XML.LoadFromFile(sFileName);
  XMLConfig := TXMLSerializer<TSettingsBase>.Create;

  Try
    XMLConfig.Deserialize(TmpObj, XML.DocumentElement);
    Self.Assign(TmpObj);
  Finally
    FreeAndNil(XMLConfig);
    FreeAndNil(XML);
    FreeAndNil(Cmp);
    FreeAndNil(TmpObj);
  End;
end;

/// <summary>
///  ���������� �������� � INI-����.
/// </summary>
/// <param name="FileName">
///  ���� � �����, � ������� ����� ��������� ���������.
/// </param>
procedure TSettingsBase.SaveToINI(const FileName: TFileName);
  var
    sFileName : TFileName;
    INIFile : TINIFile;
    INIConfig : TINISerializer<TSettingsBase>;
begin
  SetFileName(FileName, sFileName);
  DeleteFile(sFileName);
  INIFile := TINIFile.Create(sFileName);

  INIConfig := TINISerializer<TSettingsBase>.Create;
  Try
    INIConfig.Serialize(Self, INIFile);
  Finally
    FreeAndNil(INIConfig);
    FreeAndNil(INIFile);
  End;
end;

/// <summary>
///  ���������� �������� � �������� �����.
/// </summary
/// <param name="Stream">
///  �����, � ������� ����� ��������� ���������.
/// </param>
procedure TSettingsBase.SaveToStream(const Stream: TStream);
  var
    StreamConfig : TBinarySerializer<TSettingsBase>;
begin
  Assert(Assigned(Stream));

  StreamConfig := TBinarySerializer<TSettingsBase>.Create;
  Try
    StreamConfig.Serialize(Self, Stream);
  Finally
    FreeAndNil(StreamConfig);
  End;
end;

/// <summary>
///  ���������� �������� � XML-����.
/// </summary>
/// <param name="FileName">
///  ���� � �����, � ������� ����� ��������� ���������.
/// </param>
procedure TSettingsBase.SaveToXML(const FileName: TFileName);
  var
    Cmp : TComponent;
    XML : TXMLDocument;
    sFileName : TFileName;
    XMLConfig : TXMLSerializer<TSettingsBase>;
begin
  SetFileName(FileName, sFileName);
  DeleteFile(sFileName);

  Cmp := TComponent.Create(nil);
  XML := TXMLDocument.Create(Cmp);
  InitXML(XML);

  XMLConfig := TXMLSerializer<TSettingsBase>.Create;
  Try
    XMLConfig.Serialize(Self, XML.DocumentElement);
    XML.SaveToFile(sFileName);
  Finally
    FreeAndNil(XMLConfig);
    FreeAndNil(XML);
    FreeAndNil(Cmp);
  End;
end;

/// <summary>
///  ����� ���� � �����, � ������� ����� ��������� ���������.
/// </summary
/// <param name="FileName">
///  ���� � �����.
///  ���� ������, �� ����� ���������� �������� �������� SettingsFile.
/// </param>
/// <param name="Local">
///  ������������ ��������.
/// </param>
procedure TSettingsBase.SetFileName(const FileName: TFileName;
  out Local: TFileName);
begin
  If FileName = '' Then
    Local := FSettingsFile
  Else
    Local := ExpandFileName(FileName);
end;

/// <summary>
///  ��������� �������� ����� �����, � ������� �� ��������� ����������� ���������.
/// </summary
/// <param name="FileName">
///  ���� � �����.
/// </param>
procedure TSettingsBase.SetSettingsFile(const Value: TFileName);
begin
  FSettingsFile := ExpandFileName(Value);
end;

/// <summary>
///  ����������� ���� ���������� ��� �������� �������.
///  ����� ������� ��� ��������� ������������ �� �����, ������ �����������
///  � ������������� ����� ������.
/// </summary
/// <param name="Target">
///  ������� ��������� ������.
/// </param>
function TSettingsBase.SetUp(const Target: TPersistent): Boolean;
  var
    Ctx1, Ctx2   : TRTTIContext;
    Prop1, Prop2 : TRTTIProperty;
begin
  For Prop1 in Ctx1.GetType(Target.ClassType).GetProperties do
  begin
    If Prop1.IsWritable Then
    begin

      For Prop2 in Ctx2.GetType(Self.ClassType).GetProperties do
      begin
        If AnsiSameText(Prop1.Name, Prop2.Name) And Prop2.IsReadable
           And (Prop1.PropertyType.TypeKind = Prop2.PropertyType.TypeKind) Then
        begin
          Prop1.SetValue(Target, Prop2.GetValue(Self));
          Break;
        end;
      end;

    end;
  end;
  Result := True;
end;

end.

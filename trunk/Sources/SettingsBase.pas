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
  ///  Базовый класс-предок для хранения параметров чего-либо.
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
///  Присвоение настроек соединения из одного источника в другой.
///  Используется как обходной манёвр для DeHL.Serialization.Ini, который
///  после Deserialize и своего уничтожения прихватывает за собой и
///  десериализованный объект.
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
///  Процедура инициализации XML-документа.
/// </summary
/// <param name="XML">
///  Неприсвоенная переменная XML-документа.
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
///  Загрузка настроек из INI-файла.
/// </summary>
/// <param name="FileName">
///  Путь к файлу, из которого будут загружены настройки.
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
///  Загрузка настроек из бинарного потока.
/// </summary
/// <param name="Stream">
///  Поток, из которого будут загружены настройки.
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
///  Загрузка настроек из XML-файла.
/// </summary>
/// <param name="FileName">
///  Путь к файлу, из которого будут загружены настройки.
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
///  Сохранение настроек в INI-файл.
/// </summary>
/// <param name="FileName">
///  Путь к файлу, в котором будут сохранены настройки.
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
///  Сохранение настроек в бинарный поток.
/// </summary
/// <param name="Stream">
///  Поток, в который будут сохранены настройки.
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
///  Сохранение настроек в XML-файл.
/// </summary>
/// <param name="FileName">
///  Путь к файлу, в котором будут сохранены настройки.
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
///  Выбор пути к файлу, в который будут сохранены настройки.
/// </summary
/// <param name="FileName">
///  Путь к файлу.
///  Если пустой, то будет возвращено значение свойства SettingsFile.
/// </param>
/// <param name="Local">
///  Возвращаемое значение.
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
///  Установка свойства имени файла, в который по умолчанию сохраняются настройки.
/// </summary
/// <param name="FileName">
///  Путь к файлу.
/// </param>
procedure TSettingsBase.SetSettingsFile(const Value: TFileName);
begin
  FSettingsFile := ExpandFileName(Value);
end;

/// <summary>
///  Выставление всех параметров для целевого объекта.
///  Поиск свойств для установки производится по имени, однако проверяется
///  и совместимость типов данных.
/// </summary
/// <param name="Target">
///  Целевой экземпляр класса.
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

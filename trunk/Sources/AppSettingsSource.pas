unit AppSettingsSource;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, Classes, SysUtils, RTTI, TypInfo, IniFiles, ZConnection,
  DeHL.Serialization.INI, Spring.DesignPatterns, Constants;

type

  /// <summary>
  ///  Класс для хранения настроек соединения с СУБД.
  /// </summary>
  TDBSettings = class (TPersistent)
    strict private
      FUser : String;
      FPassword : String;
      FHostName : String;
      FPort : Integer;
    public
      procedure Assign(Source: TPersistent); override;
      function  SetUp(const Connection : TZConnection) : Boolean;
      procedure LoadFromFile(const FileName : String); virtual;
      procedure SaveToFile(const FileName : String); virtual;

      property User : String read FUser write FUser;
      property Password : String read FPassword write FPassword;
      property HostName : String read FHostName write FHostName;
      property Port : Integer read FPort write FPort;
  end;

  /// <summary>
  ///  Класс настроек соединения с СУБД, заточенный под синглтон.
  /// </summary>
  TMySQLDBSettings = class (TDBSettings)
    strict private
      FFileName : String;
    public
      procedure AfterConstruction; override;
      procedure LoadFromFile; reintroduce;
      procedure SaveToFile; reintroduce;

      property FileName : String read FFileName;
  end;

  function DBSettings : TMySQLDBSettings;

implementation

/// <summary>
///  Получение единственного в системе экземпляра с параметрами БД.
/// </summary>
function DBSettings : TMySQLDBSettings;
begin
  Result := TSingleton.GetInstance<TMySQLDBSettings>;
end;

{ TDBSettings }

/// <summary>
///  Присвоение настроек соединения из одного источника в другой.
///  Используется как обходной манёвр для DeHL.Serialization.Ini, который
///  после Deserialize и своего уничтожения прихватывает за собой и
///  десериализованный объект.
/// </summary>
procedure TDBSettings.Assign(Source: TPersistent);
  var
    Ctx1, Ctx2 : TRTTIContext;
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
///  Загрузка настроек из файла.
/// </summary>
/// <param name="FileName">
///  Путь к файлу, из которого будут загружены настройки.
/// </param>
procedure TDBSettings.LoadFromFile(const FileName: String);
  var
    INIFile : TINIFile;
    INIConfig : TINISerializer<TDBSettings>;
    TmpObj : TDBSettings;
begin
  Assert(FileExists(ExpandFileName(FileName)));

  INIFile := TINIFile.Create(ExpandFileName(FileName));
  INIConfig := TINISerializer<TDBSettings>.Create;

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
///  Сохранение настроек в файл.
/// </summary>
/// <param name="FileName">
///  Путь к файлу, в котором будут сохранены настройки.
/// </param>
procedure TDBSettings.SaveToFile(const FileName: String);
  var
    INIFile : TINIFile;
    INIConfig : TINISerializer<TDBSettings>;
begin
  DeleteFile(ExpandFileName(FileName));
  INIFile := TINIFile.Create(ExpandFileName(FileName));

  INIConfig := TINISerializer<TDBSettings>.Create;
  Try
    INIConfig.Serialize(Self, INIFile);
  Finally
    FreeAndNil(INIConfig);
    FreeAndNil(INIFile);
  End;
end;

/// <summary>
///  Автоматизированная установка всех необходимых настроек соединения с СУБД.
/// </summary>
/// <param name="Connection">
///  Компонент соединения с СУБД, у которого будут установлены параметры.
/// </param>
function TDBSettings.SetUp(const Connection: TZConnection): Boolean;
  var
    Ctx1, Ctx2 : TRTTIContext;
    Prop1, Prop2 : TRTTIProperty;
begin
  Result := False;
  Assert(Assigned(Connection));

  For Prop1 in Ctx1.GetType(Connection.ClassType).GetProperties do
  begin
    If (Prop1.Visibility = mvPublished) And Prop1.IsWritable Then
    begin

      For Prop2 in Ctx2.GetType(Self.ClassType).GetProperties do
      begin
        If AnsiSameText(Prop1.Name, Prop2.Name) Then
        begin
          Prop1.SetValue(Connection, Prop2.GetValue(Self));
          Break;
        end;
      end;

    end;
  end;

  Result := True;
end;

{ TMySQLDBSettings }

procedure TMySQLDBSettings.AfterConstruction;
begin
  inherited;
  FFileName := STR_DBSETTINGS_FILE;
end;

procedure TMySQLDBSettings.LoadFromFile;
begin
  Inherited LoadFromFile(FFileName);
end;

procedure TMySQLDBSettings.SaveToFile;
begin
  Inherited SaveToFile(FFileName);
end;

end.

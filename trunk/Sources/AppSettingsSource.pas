unit AppSettingsSource;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, Classes, SysUtils, RTTI, TypInfo, ZConnection,
  Spring.DesignPatterns, Constants, SettingsBase, Spring.Cryptography;

type

  /// <summary>
  ///  Класс для хранения настроек соединения с СУБД.
  /// </summary>
  TDBSettings = class (TSettingsBase)
    strict private
      FUser : String;
      FPassword : String;
      FHostName : String;
      FPort : Integer;
    public
      function  SetUp(const Connection : TZConnection) : Boolean; reintroduce;
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
  TMySQLDBSettings = class sealed (TDBSettings)
    public
      procedure AfterConstruction; override;
      procedure LoadFromFile; reintroduce;
      procedure SaveToFile; reintroduce;
  end;

  /// <summary>
  ///  Класс для хранения пароля входа в приложение.
  /// </summary>
  TPasswordStore = class sealed (TSettingsBase)
    strict private
      FPasswordHash : String;
    public
      procedure AfterConstruction; override;
      procedure Hash(const Password : String);
      procedure LoadFromFile;
      procedure SaveToFile;

      property PasswordHash : String read FPasswordHash write FPasswordHash;
  end;

//------------------------------------------------------------------------------

  function DBSettings : TMySQLDBSettings;
  function PasswordStore : TPasswordStore;

implementation

/// <summary>
///  Получение единственного в системе экземпляра с параметрами БД.
/// </summary>
function DBSettings : TMySQLDBSettings;
begin
  Result := TSingleton.GetInstance<TMySQLDBSettings>;
end;

/// <summary>
///  Получение единственного в системе экземпляра с хэшем пароля доступа.
/// </summary>
function PasswordStore : TPasswordStore;
begin
  Result := TSingleton.GetInstance<TPasswordStore>;
end;

{ TDBSettings }

/// <summary>
///  Загрузка настроек из файла.
/// </summary>
/// <param name="FileName">
///  Путь к файлу, из которого будут загружены настройки.
/// </param>
procedure TDBSettings.LoadFromFile(const FileName: String);
begin
  Inherited LoadFromINI(FileName);
end;

/// <summary>
///  Сохранение настроек в файл.
/// </summary>
/// <param name="FileName">
///  Путь к файлу, в котором будут сохранены настройки.
/// </param>
procedure TDBSettings.SaveToFile(const FileName: String);
begin
  Inherited SaveToINI(FileName);
end;

/// <summary>
///  Автоматизированная установка всех необходимых настроек соединения с СУБД.
/// </summary>
/// <param name="Connection">
///  Компонент соединения с СУБД, у которого будут установлены параметры.
/// </param>
function TDBSettings.SetUp(const Connection: TZConnection): Boolean;
begin
  Result := Inherited SetUp(Connection);
end;

{ TMySQLDBSettings }

procedure TMySQLDBSettings.AfterConstruction;
begin
  Inherited;
  SettingsFile := STR_DBSETTINGS_FILE;
end;

procedure TMySQLDBSettings.LoadFromFile;
begin
  Inherited LoadFromFile(SettingsFile);
end;

procedure TMySQLDBSettings.SaveToFile;
begin
  Inherited SaveToFile(SettingsFile);
end;

{ TPasswordStore }

procedure TPasswordStore.AfterConstruction;
begin
  Inherited;
  SettingsFile := STR_PASSWORD_FILE;
end;

procedure TPasswordStore.LoadFromFile;
begin
  Inherited LoadFromINI;
end;

procedure TPasswordStore.SaveToFile;
begin
  Inherited SaveToINI;
end;

/// <summary>
///  Сохранение хэша пароля. В параметре передаётся сам пароль, а хэш
///  высчитывает процедура, она же сохраняет его как HEX-строку.
/// </summary>
procedure TPasswordStore.Hash(const Password : String);
  var
    SHA : TSHA512;
begin
  SHA := TSHA512.Create;
  Try
    FPasswordHash := SHA.ComputeHash(Password).ToHexString;
    SaveToFile;
  Finally
    FreeAndNil(SHA);
  End;
end;

end.

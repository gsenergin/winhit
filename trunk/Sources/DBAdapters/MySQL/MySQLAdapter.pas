unit MySQLAdapter;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  SysUtils, StrUtils, RTTI, TypInfo,
  CWMIBase, ZConnection,
  Serialization;

type

  ///  Класс для хранения настроек соединения с СУБД.
  TMySQLConnectionSettings = class (TSerializable)
    strict private
      FConnection : TZConnection;

      FUser : String;
      FPassword : String;
      FProtocol : String;
      FPort : Integer;
      FHostName : String;
      FDatabase : String;
    protected
      procedure ApplySettings;

      procedure SetUser(Value : String);
      procedure SetPassword(Value : String);
      procedure SetProtocol(Value : String);
      procedure SetPort(Value : Integer);
      procedure SetHostName(Value : String);
      procedure SetDatabase(Value : String);
    public
      constructor Create(const MySQLConnection : TZConnection);

      procedure Reconnect;

      property User : String read FUser write SetUser;
      property Password : String read FPassword write SetPassword;
      property Protocol : String read FProtocol write SetProtocol;
      property Port : Integer read FPort write SetPort;
      property HostName : String read FHostName write SetHostName;
      property Database : String read FDatabase write SetDatabase;
  end;

  ///  Класс инициализации БД.
  ///  Создаёт необходимые таблицы, если таковые ещё не были созданы.
  ///  Исходные данные - набор компонентов из палитры GLibWMI, размещённых
  ///  в отдельных TDataModule. Именно оттуда и берутся свойства, именами которых
  ///  затем нарекаются столбцы каждой новой таблицы, имя которой, кстати,
  ///  равно имени отдельного GLibWMI-компонента.
  TMySQLInitDB = class
    strict private
      FConnection : TZConnection;
      FConnectionSettings : TMySQLConnectionSettings;
    public
      constructor Create;
      destructor Destroy; override;

      property ConnectionSettings : TMySQLConnectionSettings read FConnectionSettings;
  end;

implementation

//------------------------------{ TMySQLInitDB }--------------------------------

constructor TMySQLInitDB.Create;
begin
  Inherited Create;
  FConnection := TZConnection.Create(nil);
  FConnectionSettings := TMySQLConnectionSettings.Create(FConnection);
end;

destructor TMySQLInitDB.Destroy;
begin
  FreeAndNil(FConnection);
  FreeAndNil(FConnectionSettings);
  Inherited Destroy;
end;

//------------------------{ TMySQLConnectionSettings }--------------------------

constructor TMySQLConnectionSettings.Create(const MySQLConnection : TZConnection);
begin
  Inherited Create;
  Assert(Assigned(MySQLConnection));

  FConnection := MySQLConnection;
end;

/// Переподключение к СУБД с новыми параметрами.
procedure TMySQLConnectionSettings.Reconnect;
begin
  ApplySettings;
  FConnection.Reconnect;
end;

/// Применение к соединению с СУБД всех хранимых настроек.
procedure TMySQLConnectionSettings.ApplySettings;
begin
  With FConnection do
  begin
    Database := FDatabase;
    HostName := FHostName;
    Password := FPassword;
    Port := FPort;
    Protocol := FProtocol;
    User := FUser;
  end;
end;

procedure TMySQLConnectionSettings.SetDatabase(Value : String);
begin
  If FDatabase <> Value Then FDatabase := Value;
end;

procedure TMySQLConnectionSettings.SetHostName(Value : String);
begin
  If FHostName <> Value Then FHostName := Value;
end;

procedure TMySQLConnectionSettings.SetPassword(Value : String);
begin
  If FPassword <> Value Then FPassword := Value;
end;

procedure TMySQLConnectionSettings.SetPort(Value : Integer);
begin
  If FPort <> Value Then FPort := Value;
end;

procedure TMySQLConnectionSettings.SetProtocol(Value : String);
begin
  If FProtocol <> Value Then FProtocol := Value;
end;

procedure TMySQLConnectionSettings.SetUser(Value : String);
begin
  If FUser <> Value Then FUser := Value;
end;

end.

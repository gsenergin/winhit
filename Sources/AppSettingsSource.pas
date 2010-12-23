unit AppSettingsSource;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, Classes, SysUtils, RTTI, TypInfo, ZConnection,
  Spring.DesignPatterns, Constants, SettingsBase, Spring.Cryptography;

type

  /// <summary>
  ///  ����� ��� �������� �������� ���������� � ����.
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
  ///  ����� �������� ���������� � ����, ���������� ��� ��������.
  /// </summary>
  TMySQLDBSettings = class sealed (TDBSettings)
    public
      procedure AfterConstruction; override;
      procedure LoadFromFile; reintroduce;
      procedure SaveToFile; reintroduce;
  end;

  /// <summary>
  ///  ����� ��� �������� ������ ����� � ����������.
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
///  ��������� ������������� � ������� ���������� � ����������� ��.
/// </summary>
function DBSettings : TMySQLDBSettings;
begin
  Result := TSingleton.GetInstance<TMySQLDBSettings>;
end;

/// <summary>
///  ��������� ������������� � ������� ���������� � ����� ������ �������.
/// </summary>
function PasswordStore : TPasswordStore;
begin
  Result := TSingleton.GetInstance<TPasswordStore>;
end;

{ TDBSettings }

/// <summary>
///  �������� �������� �� �����.
/// </summary>
/// <param name="FileName">
///  ���� � �����, �� �������� ����� ��������� ���������.
/// </param>
procedure TDBSettings.LoadFromFile(const FileName: String);
begin
  Inherited LoadFromINI(FileName);
end;

/// <summary>
///  ���������� �������� � ����.
/// </summary>
/// <param name="FileName">
///  ���� � �����, � ������� ����� ��������� ���������.
/// </param>
procedure TDBSettings.SaveToFile(const FileName: String);
begin
  Inherited SaveToINI(FileName);
end;

/// <summary>
///  ������������������ ��������� ���� ����������� �������� ���������� � ����.
/// </summary>
/// <param name="Connection">
///  ��������� ���������� � ����, � �������� ����� ����������� ���������.
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
///  ���������� ���� ������. � ��������� ��������� ��� ������, � ���
///  ����������� ���������, ��� �� ��������� ��� ��� HEX-������.
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

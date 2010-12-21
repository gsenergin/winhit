unit AppSettingsSource;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, Classes, SysUtils, RTTI, TypInfo, IniFiles, ZConnection,
  DeHL.Serialization.INI, Spring.DesignPatterns, Constants, SettingsBase;

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
  TMySQLDBSettings = class (TDBSettings)
    public
      procedure AfterConstruction; override;
      procedure LoadFromFile; reintroduce;
      procedure SaveToFile; reintroduce;
  end;

  function DBSettings : TMySQLDBSettings;

implementation

/// <summary>
///  ��������� ������������� � ������� ���������� � ����������� ��.
/// </summary>
function DBSettings : TMySQLDBSettings;
begin
  Result := TSingleton.GetInstance<TMySQLDBSettings>;
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

end.

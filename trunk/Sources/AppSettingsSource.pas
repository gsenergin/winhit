unit AppSettingsSource;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, Classes, SysUtils, RTTI, TypInfo, IniFiles, ZConnection,
  DeHL.Serialization.INI, Spring.DesignPatterns, Constants;

type

  /// <summary>
  ///  ����� ��� �������� �������� ���������� � ����.
  /// </summary>
  TDBSettings = class (TPersistent)
    strict private
      FUser : String;
      FPassword : String;
      FHostName : String;
      FPort : Integer;
    public
      function  SetUp(const Connection : TZConnection) : Boolean;
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
  var
    INIFile : TINIFile;
    INIConfig : TINISerializer<TDBSettings>;
begin
  Assert(FileExists(ExpandFileName(FileName)));

  INIFile := TINIFile.Create(ExpandFileName(FileName));
  INIConfig := TINISerializer<TDBSettings>.Create;

  Try
    INIConfig.Deserialize(Self, INIFile);
  Finally
    FreeAndNil(INIConfig);
    FreeAndNil(INIFile);
  End;
end;

/// <summary>
///  ���������� �������� � ����.
/// </summary>
/// <param name="FileName">
///  ���� � �����, � ������� ����� ��������� ���������.
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
///  ������������������ ��������� ���� ����������� �������� ���������� � ����.
/// </summary>
/// <param name="Connection">
///  ��������� ���������� � ����, � �������� ����� ����������� ���������.
/// </param>
function TDBSettings.SetUp(const Connection: TZConnection): Boolean;
  var
    Ctx : TRTTIContext;
    Prop1, Prop2 : TRTTIProperty;
begin
  Result := False;
  Assert(Assigned(Connection));

  For Prop1 in Ctx.GetType(Connection.ClassType).GetProperties do
  begin
    If Prop1.Visibility = mvPublished Then
    begin

      For Prop2 in Ctx.GetType(Self.ClassType).GetProperties do
      begin
        If AnsiSameText(Prop1.Name, Prop2.Name) Then
          Prop1.SetValue(Connection, Prop2.GetValue(Self));
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

initialization
  {...}

finalization
  DBSettings.Free;

end.

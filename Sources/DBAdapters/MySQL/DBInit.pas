unit DBInit;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, SysUtils, Classes, RTTI, TypInfo, ZConnection, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZDbcIntfs, CWMIBase, StrUtils, Dialogs,
  AppSettingsSource, WMIHardware, WMISoftware, MySQLHelpers, SysUtilsEx,
  ZSqlMonitor, Constants, Generics.Collections;

type
  TdtmdlDBInit = class(TDataModule)
    ZConnection: TZConnection;
    zqCreateSchemas: TZQuery;
    zqCreateMainTables: TZQuery;
    zqCreateHardwareTables: TZQuery;
    zqCreateSoftwareTables: TZQuery;
  strict private
    FDBWasInitialized : Boolean;
  private
    procedure CreateSchemas;
    procedure CreateMainTables;
    procedure CreateHardwareTables;
    procedure CreateSoftwareTables;

    procedure ExecuteSQL(const SQL: TStrings);
    procedure FillWMIProperties(const WMIComponent : TWMIBase;
                                const WMIProperties : TStrings);
    procedure GenerateCreateTableScript(const WMIComponent : TWMIBase;
                                        const SQLTemplate : TStrings);
    procedure AddFKInfo(const CreateTableQuery : String); overload;
    procedure AddFKInfo(const SQL : TStrings); overload;
  public
    procedure InitDB;
  end;

var
  dtmdlDBInit: TdtmdlDBInit;

implementation

{$R *.dfm}

{ TdtmdlDBInit }

/// <summary>
///  ���������� �� SQL-������� CREATE TABLE ���������� �� FK-������ �������
///  � ���������� � � ����������� �������.
/// </summary>
/// <param name="CreateTableQuery">
///  SQL-������ CREATE TABLE.
/// </param>
procedure TdtmdlDBInit.AddFKInfo(const CreateTableQuery: String);
  var
    S : String;
begin
  Assert(Length(CreateTableQuery) > 0);

  S := CreateTableQuery;

  If AnsiContainsText(S, 'CREATE TABLE') Then
  begin
    // ��������� ������ - ��������� �������:
    If AnsiContainsText(S, STR_INSTALLEDSOFT_TABLENAME) Then
      S := DeleteToken(S, 1, ';');

    Delete(S, 1, AnsiPosEx('CREATE TABLE', S));
    S := GetToken(S, 4, '`'); { TODO : dangerous }

    FillFKInfo(CreateTableQuery, FKList);
    FKDictionary.Add(S, FKList);
  end;
end;

/// <summary>
///  ����������� SQL-������� CREATE TABLE � SQL-������� � ���������� �� ����
///  ���������� �� FK-������ ��� ������ �������������� ������.
/// </summary>
/// <param name="SQL">
///  SQL-������.
/// </param>
procedure TdtmdlDBInit.AddFKInfo(const SQL: TStrings);
  var
    i : Integer;
begin
  For i := 1 To TokensNum(SQL.Text, ';') do
    AddFKInfo(GetToken(SQL.Text, i, ';'));
end;

/// <summary>
///  �������� ������ ��������� Hardware.
/// </summary>
procedure TdtmdlDBInit.CreateHardwareTables;
  var
    Cmp : TComponent;
    L : TStringList;
begin
  L := TStringList.Create;

  For Cmp in dtmdlWMIHardware do
  begin
    If Cmp is TWMIBase Then
    begin
      L.Assign(zqCreateHardwareTables.SQL); // backup template for next iteration
      GenerateCreateTableScript(TWMIBase(Cmp), zqCreateHardwareTables.SQL);
      ExecuteSQL(zqCreateHardwareTables.SQL);
      zqCreateHardwareTables.SQL.Assign(L);
    end;
  end;

  FreeAndNil(L);
end;

/// <summary>
///  �������� ������� ������, ����������� �������� ������-������.
/// </summary>
procedure TdtmdlDBInit.CreateMainTables;
begin
  ExecuteSQL(zqCreateMainTables.SQL);
  AddFKInfo(zqCreateMainTables.SQL);
end;

/// <summary>
///  �������� ���� (��� ������).
/// </summary>
procedure TdtmdlDBInit.CreateSchemas;
begin
  ExecuteSQL(zqCreateSchemas.SQL);
end;

/// <summary>
///  �������� ������ ��������� Software.
/// </summary>
procedure TdtmdlDBInit.CreateSoftwareTables;
  var
    Cmp : TComponent;
    L : TStringList;
begin
  L := TStringList.Create;

  For Cmp in dtmdlWMISoftware do
  begin
    If Cmp is TWMIBase Then
    begin
      L.Assign(zqCreateSoftwareTables.SQL); // backup template for next iteration
      GenerateCreateTableScript(TWMIBase(Cmp), zqCreateSoftwareTables.SQL);
      ExecuteSQL(zqCreateSoftwareTables.SQL);
      zqCreateSoftwareTables.SQL.Assign(L);
    end;
  end;

  FreeAndNil(L);
end;

/// <summary>
///  ���������� SQL-�������� �� ����� �������.
/// </summary>
procedure TdtmdlDBInit.ExecuteSQL(const SQL: TStrings);
  var
    i : Integer;
    sCmd : String;
begin
  Assert(Assigned(SQL));

  For i := 1 To TokensNum(SQL.Text, ';') do
  begin
    // getting next command:
    sCmd := GetToken(SQL.Text, i, ';');

    // remove comments:
    While AnsiPosEx('/*', sCmd) <> 0 do
      sCmd := DeleteEx(sCmd, AnsiPosEx('/*', sCmd), AnsiPosEx('*/', sCmd) + 1);

    // remove linebreaks:
    sCmd := StringReplace(sCmd, sLineBreak, ' ', [rfReplaceAll]);
    // trimming:
    sCmd := Trim(sCmd);

    // ���� �� ������� ���-������ �������� :D
    If sCmd = '' Then Continue;
    sCmd := sCmd + ';';

    ZConnection.ExecuteDirect(sCmd);
  end;
end;

/// <summary>
///  ��������� ������ WMI-������� �� WMI-����������.
/// </summary>
/// <param name="WMIComponent">
///  WMI-���������, ����� ���� ������� ����� �����������.
/// </param>
/// <param name="WMIProperties">
///  ������, ������� ����� ��������� ������� ������� WMI-����������.
/// </param>
procedure TdtmdlDBInit.FillWMIProperties(const WMIComponent: TWMIBase;
                                         const WMIProperties: TStrings);
  var
    Context, Context2 : TRTTIContext;
    Prop, Prop2 : TRTTIProperty;
    Val : TValue;
    S : String;
begin
  Assert(Assigned(WMIComponent));
  Assert(Assigned(WMIProperties));

  For Prop in Context.GetType(WMIComponent.ClassType).GetProperties do
  begin
    If (Not Prop.IsReadable) Or (Prop.Visibility <> mvPublished) Then Continue;

    Val := Prop.GetValue(WMIComponent);
    If Val.Kind = tkClass Then
    begin
      If AnsiContainsText(Val.AsObject.ClassName, 'properties') Then
      begin

        For Prop2 in Context2.GetType(Val.AsObject.ClassType).GetDeclaredProperties do
        begin
          If Prop2.IsReadable And (Prop2.Visibility = mvPublished) Then
          begin
            { TODO : ��������� ����������� - ����� �������. }
            If AnsiSameText(Prop2.Name, 'ID') Then
              S := '  `Id_` ' +
                    MySQLDataType(Prop2, WMIComponent) + ' NULL ,'
            Else
              S := '  `' + Prop2.Name + '` ' +
                    MySQLDataType(Prop2, WMIComponent) + ' NULL ,';
            WMIProperties.Add(S);
          end;
        end;

      end;
    end;
  end;
end;

/// <summary>
///  ��������� SQL-������� ��� �������� ������� ��������� Hardware �� ������
///  �������.
/// </summary>
/// <param name="WMIComponent">
///  WMI-���������, �������� �������� ������ ���������
///  � ����� �������.
/// </param>
/// <param name="SQL">
///  ������ �������, ������� ����� ��������� ��������������� ��������.
/// </param>
procedure TdtmdlDBInit.GenerateCreateTableScript(const WMIComponent: TWMIBase;
                                                 const SQLTemplate: TStrings);
  var
    L : TStringList;
    S : String;
begin
  L := TStringList.Create;
  S := SQLTemplate.Text;

  FillWMIProperties(WMIComponent, L);
  S := StringReplace(S, STR_REPLACE_TABLENAME, WMIComponent.Name, [rfReplaceAll]);
  S := StringReplace(S, STR_REPLACE_WMIINFO, L.Text, [rfReplaceAll]);
  SQLTemplate.Text := S;

  // ��������� ���������� � FK-������ ������������ ������� � �������:
  AddFKInfo(S);

  FreeAndNil(L);
end;

/// <summary>
///  ������������� ���� ��.
/// </summary>
procedure TdtmdlDBInit.InitDB;
begin
  If FDBWasInitialized Then Exit;

  DeleteFile(ExpandFileName(zsqlmonDBInit.FileName));

  DBSettings.LoadFromFile;
  ZConnection.Connected := DBSettings.SetUp(ZConnection);

  Try
    CreateSchemas;
    CreateMainTables;
    CreateHardwareTables;
    CreateSoftwareTables;
    FDBWasInitialized := True;
  Except
    // Supressing some useless SQL exceptions:
    on E:EZSQLException do
    begin
      If Not AnsiContainsText(E.Message, 'resultset') Then raise;
    end;
  End;
end;

end.

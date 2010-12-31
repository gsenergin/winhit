unit DBInit;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, SysUtils, Classes, RTTI, TypInfo, ZConnection, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZDbcIntfs, CWMIBase, StrUtils, Dialogs,
  AppSettingsSource, WMIHardware, WMISoftware, MySQLHelpers, SysUtilsEx,
  ZSqlMonitor, Constants, Spring.DesignPatterns;

type
  TdtmdlDBInit = class(TDataModule)
    ZConnection: TZConnection;
    zqCreateSchemas: TZQuery;
    zqCreateMainTables: TZQuery;
    zqCreateHardwareTables: TZQuery;
    zqCreateSoftwareTables: TZQuery;
    zsqlmonDBInit: TZSQLMonitor;
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
  public
    procedure InitDB;
  end;

  function TablesList : TStringList;

var
  dtmdlDBInit: TdtmdlDBInit;

implementation

{$R *.dfm}

function TablesList : TStringList;
begin
  Result := TSingleton.GetInstance<TStringList>;
end;

{ TdtmdlDBInit }

/// <summary>
///  Создание таблиц категории Hardware.
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

      TablesList.Add('hardware_config' + STR_SEPARATOR + TWMIBase(Cmp).Name);

      ExecuteSQL(zqCreateHardwareTables.SQL);
      zqCreateHardwareTables.SQL.Assign(L);
    end;
  end;

  FreeAndNil(L);
end;

/// <summary>
///  Создание главных таблиц, реализующих основную бизнес-логику.
/// </summary>
procedure TdtmdlDBInit.CreateMainTables;
  var
    S : String;
begin
  For S in zqCreateMainTables.SQL do
  begin
    If AnsiContainsText(S, 'CREATE TABLE') Then
      TablesList.Add('main' + STR_SEPARATOR + GetToken(S, 4, '`'));  { TODO : dangerous }
  end;
  ExecuteSQL(zqCreateMainTables.SQL);
end;

/// <summary>
///  Создание схем (баз данных).
/// </summary>
procedure TdtmdlDBInit.CreateSchemas;
begin
  ExecuteSQL(zqCreateSchemas.SQL);
end;

/// <summary>
///  Создание таблиц категории Software.
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
      TablesList.Add('software_config' + STR_SEPARATOR + TWMIBase(Cmp).Name);
      ExecuteSQL(zqCreateSoftwareTables.SQL);
      zqCreateSoftwareTables.SQL.Assign(L);
    end;
  end;

  FreeAndNil(L);
end;

/// <summary>
///  Выполнение SQL-скриптов по одной команде.
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

    // если от команды что-нибудь осталось :D
    If sCmd = '' Then Continue;
    sCmd := sCmd + ';';

    ZConnection.ExecuteDirect(sCmd);
  end;
end;

/// <summary>
///  Процедура чтения WMI-свойств из WMI-компонента.
/// </summary>
/// <param name="WMIComponent">
///  WMI-компонент, имена чьих свойств будут считываться.
/// </param>
/// <param name="WMIProperties">
///  Строки, которые будут заполнены именами свойств WMI-компонента.
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
            { TODO : следующая конструкция - дикий костыль. }
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
///  Генератор SQL-скрипта для создания таблицы категории Hardware на основе
///  шаблона.
/// </summary>
/// <param name="WMIComponent">
///  WMI-компонент, свойства которого станут колонками
///  в новой таблице.
/// </param>
/// <param name="SQL">
///  Строки шаблона, которые будут дополнены сгенерированным скриптом.
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

  FreeAndNil(L);
end;

/// <summary>
///  Инициализация всей БД.
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

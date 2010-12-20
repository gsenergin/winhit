unit DBInit;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  SysUtils, Classes, RTTI, TypInfo, ZConnection, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZDbcIntfs, CWMIBase, StrUtils,
  AppSettingsSource, WMIHardware, WMISoftware, MySQLHelpers;

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

    procedure FillWMIProperties(const WMIComponent : TWMIBase;
                                const WMIProperties : TStrings);
    procedure GenerateCreateTableScript(const WMIComponent : TWMIBase;
                                        const SQLTemplate : TStrings);
  public
    procedure AfterConstruction; override;
    procedure InitDB;
  end;

var
  dtmdlDBInit: TdtmdlDBInit;

implementation

{$R *.dfm}

{ TdtmdlDBInit }

/// <summary>
///  Устанавливаем параметры соединения и вызываем инициализацию БД.
/// </summary>
procedure TdtmdlDBInit.AfterConstruction;
begin
  inherited;
  DBSettings.SetUp(ZConnection);
end;

/// <summary>
///  Создание таблиц категории Hardware.
/// </summary>
procedure TdtmdlDBInit.CreateHardwareTables;
  var
    Cmp : TComponent;
begin
  For Cmp in dtmdlWMIHardware do
  begin
    If Cmp is TWMIBase Then
    begin
      GenerateCreateTableScript(TWMIBase(Cmp), zqCreateHardwareTables.SQL);
      zqCreateHardwareTables.Active := True;
      { TODO : handle exceptions }
    end;
  end;
end;

/// <summary>
///  Создание главных таблиц, реализующих основную бизнес-логику.
/// </summary>
procedure TdtmdlDBInit.CreateMainTables;
begin
  zqCreateMainTables.Active := True;
end;

/// <summary>
///  Создание схем (баз данных).
/// </summary>
procedure TdtmdlDBInit.CreateSchemas;
begin
  zqCreateSchemas.Active := True;
end;

/// <summary>
///  Создание таблиц категории Software.
/// </summary>
procedure TdtmdlDBInit.CreateSoftwareTables;
  var
    Cmp : TComponent;
begin
  For Cmp in dtmdlWMISoftware do
  begin
    If Cmp is TWMIBase Then
    begin
      GenerateCreateTableScript(TWMIBase(Cmp), zqCreateSoftwareTables.SQL);
      zqCreateSoftwareTables.Active := True;
      { TODO : handle exceptions }
    end;
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

        For Prop2 in Context2.GetType(Val.AsObject.ClassType).GetProperties do
        begin
          If Prop2.Visibility = mvPublished Then
            WMIProperties.Add('`' + Prop2.Name + '` ' +
                  MySQLDataType(Prop2.GetValue(WMIComponent)) + ' NULL ,');

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
begin
  L := TStringList.Create;

  FillWMIProperties(WMIComponent, L);
  Format(SQLTemplate.Text,
        [WMIComponent.Name,  // table name
         L.Text,             // wmi tech info
         // indexes:
         WMIComponent.Name, WMIComponent.Name, WMIComponent.Name,
         // constraints:
         WMIComponent.Name, WMIComponent.Name, WMIComponent.Name]);

  FreeAndNil(L);
end;

/// <summary>
///  Инициализация всей БД.
/// </summary>
procedure TdtmdlDBInit.InitDB;
begin
  If FDBWasInitialized Then Exit;
  Try
    CreateSchemas;
    CreateMainTables;
    CreateHardwareTables;
    CreateSoftwareTables;
    FDBWasInitialized := True;
  Except
    on E:EZSQLException do ;  // supressing SQL exceptions, they are useless
  End;
end;

end.

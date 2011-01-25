unit DBConnector;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, SysUtils, Classes, ZConnection, AppSettingsSource, ZDataset, DB, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractTable, ZSqlMonitor, ZAbstractConnection, SyncObjs;

type
  TdtmdlDBConnector = class(TDataModule)
    ZConnection: TZConnection;
    ZTable: TZTable;
    ZQuery: TZQuery;
    ZSQLMonitor: TZSQLMonitor;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function ConnectToDB : Boolean; virtual;
  end;

var
  dtmdlDBConnector: TdtmdlDBConnector;

implementation

{$R *.dfm}

var
  csExecuteSQL : TCriticalSection;

type
  TZConnectionHelper = class helper for TZConnection
    public
      function ExecuteDirect(SQL : String) : Boolean; reintroduce;
  end;

{ TdtmdlDBConnector }

function TdtmdlDBConnector.ConnectToDB : Boolean;
begin
  DBSettings.LoadFromFile;
  ZConnection.Connected := DBSettings.SetUp(ZConnection);
  Result := ZConnection.Connected;
end;

procedure TdtmdlDBConnector.DataModuleCreate(Sender: TObject);
begin
  DeleteFile(ExpandFileName(ZSQLMonitor.FileName));
end;

{ TZConnectionHelper }

function TZConnectionHelper.ExecuteDirect(SQL: String): Boolean;
begin
  csExecuteSQL.Enter;
  Try
    Result := Inherited ExecuteDirect(SQL);
  Finally
    csExecuteSQL.Leave;
  End;
end;

initialization
  csExecuteSQL := TCriticalSection.Create;

finalization
  csExecuteSQL.Leave;
  csExecuteSQL.Free;

end.

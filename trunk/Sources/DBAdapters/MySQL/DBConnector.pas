unit DBConnector;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Classes, ZConnection, AppSettingsSource, ZDataset, DB, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractTable;

type
  TdtmdlDBConnector = class(TDataModule)
    ZConnection: TZConnection;
    ZTable: TZTable;
    ZQuery: TZQuery;
  private
    { Private declarations }
  public
    function ConnectToDB : Boolean; virtual;
  end;

var
  dtmdlDBConnector: TdtmdlDBConnector;

implementation

{$R *.dfm}

{ TdtmdlDBConnector }

function TdtmdlDBConnector.ConnectToDB : Boolean;
begin
  DBSettings.LoadFromFile;
  ZConnection.Connected := DBSettings.SetUp(ZConnection);
  Result := ZConnection.Connected;
end;

end.

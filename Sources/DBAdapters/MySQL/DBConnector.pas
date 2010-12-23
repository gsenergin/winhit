unit DBConnector;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Classes, ZConnection, AppSettingsSource;

type
  TdtmdlDBConnector = class abstract (TDataModule)
    ZConnection: TZConnection;
  private
    { Private declarations }
  public
    procedure AfterConstruction; override;
  end;

var
  dtmdlDBConnector: TdtmdlDBConnector;

implementation

{$R *.dfm}

{ TdtmdlDBConnector }

procedure TdtmdlDBConnector.AfterConstruction;
begin
  Inherited;
  DBSettings.LoadFromFile;
  ZConnection.Connected := DBSettings.SetUp(ZConnection);
end;

end.

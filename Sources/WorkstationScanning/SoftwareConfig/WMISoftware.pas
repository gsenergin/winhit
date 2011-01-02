unit WMISoftware;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  SysUtils, Classes, CShareInfo, CUserAccountInfo, CStartupCommandInfo,
  CComputerSystemInfo, CEnvironmentInfo, CServiceInfo, CProcessInfo,
  COperatingSystemInfo, CPrintJobInfo, CWMIBase, CDiskPartitionInfo;

type
  TdtmdlWMISoftware = class(TDataModule)
    DiskPartitionInfo: TDiskPartitionInfo;
    PrintJobInfo: TPrintJobInfo;
    OperatingSystemInfo: TOperatingSystemInfo;
    ProcessInfo: TProcessInfo;
    ServiceInfo: TServiceInfo;
    EnvironmentInfo: TEnvironmentInfo;
    ComputerSystemInfo: TComputerSystemInfo;
    StartupCommandInfo: TStartupCommandInfo;
    UserAccountInfo: TUserAccountInfo;
    ShareInfo: TShareInfo;
  private
    { Private declarations }
  public
    function ScanHost(const Host : String) : Boolean;
  end;

var
  dtmdlWMISoftware: TdtmdlWMISoftware;

implementation

{$R *.dfm}

{ TdtmdlWMISoftware }

function TdtmdlWMISoftware.ScanHost(const Host: String): Boolean;
begin
  //
end;

end.

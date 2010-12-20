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
    { Public declarations }
  end;

var
  dtmdlWMISoftware: TdtmdlWMISoftware;

implementation

{$R *.dfm}

end.

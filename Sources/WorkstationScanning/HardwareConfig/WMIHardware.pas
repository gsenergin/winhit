unit WMIHardware;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  SysUtils, Classes, CDesktopMonitorInfo, CPhysicalMemoryInfo,
  CUSBControllerInfo, CPointingDeviceInfo, CSoundDeviceInfo,
  CNetworkAdapterInfo, CBatteryInfo, CPrinterInfo, CKeyboardInfo,
  CCDRomDriveInfo, CProcessorInfo, CDiskDriveInfo, CDisplayInfo, CWMIBase,
  CBiosInfo;

type
  TdtmdlWMIHardware = class(TDataModule)
    BiosInfo: TBiosInfo;
    DisplayInfo: TDisplayInfo;
    DiskDriveInfo: TDiskDriveInfo;
    ProcessorInfo: TProcessorInfo;
    CDRomDriveInfo: TCDRomDriveInfo;
    KeyboardInfo: TKeyboardInfo;
    PrinterInfo: TPrinterInfo;
    BatteryInfo: TBatteryInfo;
    NetworkAdapterInfo: TNetworkAdapterInfo;
    SoundDeviceInfo: TSoundDeviceInfo;
    PointingDeviceInfo: TPointingDeviceInfo;
    USBControllerInfo: TUSBControllerInfo;
    PhysicalMemoryInfo: TPhysicalMemoryInfo;
    DesktopMonitorInfo: TDesktopMonitorInfo;
  private
    { Private declarations }
  public
    function ScanHost(const Host : String) : Boolean;
  end;

var
  dtmdlWMIHardware: TdtmdlWMIHardware;

implementation

uses DBAppendData, WMIDataCollector;

{$R *.dfm}

{ TdtmdlWMIHardware }

function TdtmdlWMIHardware.ScanHost(const Host: String): Boolean;
begin
  CollectWMIData(Host, Self);
  AppendHardwareData;
end;

end.

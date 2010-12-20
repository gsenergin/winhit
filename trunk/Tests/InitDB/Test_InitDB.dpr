program Test_InitDB;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  WMIHardware in '..\..\Sources\WorkstationScanning\HardwareConfig\WMIHardware.pas' {dtmdlWMIHardware: TDataModule},
  WMISoftware in '..\..\Sources\WorkstationScanning\SoftwareConfig\WMISoftware.pas' {dtmdlWMISoftware: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdtmdlWMIHardware, dtmdlWMIHardware);
  Application.CreateForm(TdtmdlWMISoftware, dtmdlWMISoftware);
  Application.Run;
end.

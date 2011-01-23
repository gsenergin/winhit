program WinHIT;

uses
  Windows,
  Forms,
  Main in 'GUI\Main.pas' {frmMain},
  SplashScreen in 'GUI\SplashScreen.pas' {frmSplashScreen},
  WMIHardware in 'WorkstationScanning\HardwareConfig\WMIHardware.pas' {dtmdlWMIHardware: TDataModule},
  WMISoftware in 'WorkstationScanning\SoftwareConfig\WMISoftware.pas' {dtmdlWMISoftware: TDataModule},
  MySQLAdapter in 'DBAdapters\MySQL\MySQLAdapter.pas',
  Constants in 'Constants.pas',
  Exceptions in 'Exceptions.pas',
  Serialization in '..\ThirdParty\Serialization.pas',
  DBInit in 'DBAdapters\MySQL\DBInit.pas' {dtmdlDBInit: TDataModule},
  AppSettingsSource in 'AppSettingsSource.pas',
  SysUtilsEx in '..\ThirdParty\SysUtilsEx.pas',
  MySQLHelpers in 'DBAdapters\MySQL\MySQLHelpers.pas',
  Test in 'GUI\Test.pas' {frmTest},
  SettingsBase in 'SettingsBase.pas',
  DBConnector in 'DBAdapters\MySQL\DBConnector.pas' {dtmdlDBConnector: TDataModule},
  PassWord in 'GUI\PassWord.pas' {PasswordDlg},
  JvDBComponents in 'DBAdapters\MySQL\JvDBComponents.pas' {dtmdlJvDBComponents: TDataModule},
  DBAppendData in 'WorkstationScanning\DBAppendData.pas',
  NetScan in 'WorkstationScanning\Network\NetScan.pas',
  IPRange in 'GUI\IPRange.pas' {frmIPRange};

{$R *.res}
{$I 'PEFlags.inc'}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSplashScreen, frmSplashScreen);
  Application.CreateForm(TdtmdlWMIHardware, dtmdlWMIHardware);
  Application.CreateForm(TdtmdlWMISoftware, dtmdlWMISoftware);
  Application.CreateForm(TdtmdlDBInit, dtmdlDBInit);
  Application.CreateForm(TfrmTest, frmTest);
  Application.CreateForm(TdtmdlDBConnector, dtmdlDBConnector);
  Application.CreateForm(TPasswordDlg, PasswordDlg);
  Application.CreateForm(TdtmdlJvDBComponents, dtmdlJvDBComponents);
  Application.CreateForm(TfrmIPRange, frmIPRange);
  Application.Run;
end.

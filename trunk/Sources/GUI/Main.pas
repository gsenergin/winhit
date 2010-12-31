unit Main;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sSkinProvider, sSkinManager, XPMan,
  RibbonLunaStyleActnCtrls, Ribbon, ComCtrls, ExtCtrls, JvExComCtrls,
  JvListView, JvComCtrls, JvExExtCtrls, JvExtComponent, JvPanel, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, JvExControls, JvDBLookup, ToolWin,
  ActnMan, ActnCtrls, PlatformDefaultStyleActnCtrls, ActnList, RibbonActnCtrls,
  ImgList, JvDBComponents, DBInit, SysUtilsEx;

type
  TfrmMain = class(TForm)
    SkinManager: TsSkinManager;
    XPManifest: TXPManifest;
    rbnMain: TRibbon;
    rbnpgInventory: TRibbonPage;
    rbnpgMonitoring: TRibbonPage;
    rbnpgReports: TRibbonPage;
    pgctrlMain: TPageControl;
    tbshtWorkstationsTree: TTabSheet;
    tbshtScanResults: TTabSheet;
    StatusBar: TStatusBar;
    jvtrvWorkgroups: TJvTreeView;
    jvlstvWorkstations: TJvListView;
    Splitter: TSplitter;
    JvPanel1: TJvPanel;
    jvdbgrdResults: TJvDBUltimGrid;
    Label1: TLabel;
    rbngrpScanType: TRibbonGroup;
    ActionManager: TActionManager;
    rbncmbxScanType: TRibbonComboBox;
    rbngrpScanManage: TRibbonGroup;
    actnStartScan: TAction;
    actnPauseScan: TAction;
    actnStopScan: TAction;
    RibbonGroup1: TRibbonGroup;
    RibbonGroup2: TRibbonGroup;
    RibbonGroup3: TRibbonGroup;
    RibbonGroup4: TRibbonGroup;
    RibbonGroup5: TRibbonGroup;
    actnExportWord: TAction;
    imglstActions: TImageList;
    SaveDialog: TSaveDialog;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    cmbxCategories: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure actnStartScanExecute(Sender: TObject);
    procedure actnExportWordExecute(Sender: TObject);
    procedure cmbxCategoriesSelect(Sender: TObject);
  private
    procedure InitCategoriesCombo;
    procedure SetDBGridExporters;
  public
    procedure Init;
  end;

var
  frmMain: TfrmMain;

implementation

uses Test, PassWord, SplashScreen, Constants;

{$R *.dfm}

procedure TfrmMain.actnExportWordExecute(Sender: TObject);
begin
  If SaveDialog.Execute(self.Handle) Then
  begin
    dtmdlJvDBComponents.JvDBGridWordExport.FileName := SaveDialog.FileName;
    dtmdlJvDBComponents.JvDBGridWordExport.ExportGrid;
  end;
end;

procedure TfrmMain.actnStartScanExecute(Sender: TObject);
begin
  //
end;

procedure TfrmMain.cmbxCategoriesSelect(Sender: TObject);
  var
    S, sDB, sTable : String;
begin
  dtmdlJvDBComponents.ZTable.Active := False;

  S := cmbxCategories.Items[cmbxCategories.ItemIndex];
  sDB := GetToken(S, 1, STR_SEPARATOR);
  sTable := GetToken(S, 2, STR_SEPARATOR);

  dtmdlJvDBComponents.ZConnection.Connected := False;
  dtmdlJvDBComponents.ZConnection.Database := sDB;
  dtmdlJvDBComponents.ZConnection.Connected := True;

  dtmdlJvDBComponents.ZTable.TableName := sTable;
  dtmdlJvDBComponents.ZTable.Active := True;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  WindowState := wsMinimized;

  Case PasswordDlg.ShowModal of
    mrCancel: Close;
    mrOK:
      begin
        frmSplashScreen.ShowModal;
        WindowState := wsNormal;
        frmTest.Show;
        Init;
      end;
    else
      raise Exception.Create('Not OK or Cancel');
  End;
end;

procedure TfrmMain.Init;
begin
  SetDBGridExporters;
  jvdbgrdResults.DataSource := dtmdlJvDBComponents.JvDataSource;
  If dtmdlJvDBComponents.ConnectToDB Then
  begin
    dtmdlDBInit.InitDB;
    InitCategoriesCombo;
  end;
end;

procedure TfrmMain.InitCategoriesCombo;
begin
  cmbxCategories.Items.Assign(TablesList);
end;

procedure TfrmMain.SetDBGridExporters;
begin
  With dtmdlJvDBComponents do
  begin
    JvDBGridExcelExport.Grid := jvdbgrdResults;
    JvDBGridWordExport.Grid := jvdbgrdResults;
    JvDBGridHTMLExport.Grid := jvdbgrdResults;
    JvDBGridXMLExport.Grid := jvdbgrdResults;
    JvDBGridCSVExport.Grid := jvdbgrdResults;
  end;
end;

end.

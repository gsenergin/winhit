unit Main;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, ComObj, MySQLHelpers, NetScan, OtlTaskControl,
  RibbonLunaStyleActnCtrls, Ribbon, ComCtrls, ExtCtrls, JvExComCtrls, OtlTask,
  JvListView, JvComCtrls, JvExExtCtrls, JvExtComponent, JvPanel, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, JvExControls, JvDBLookup, ToolWin,
  ActnMan, ActnCtrls, PlatformDefaultStyleActnCtrls, ActnList, RibbonActnCtrls,
  ImgList, JvDBComponents, DBInit, SysUtilsEx, JvDBGridExport, MySQLAdapter;

type

  TScanType = (stAuto, stManual);

  TfrmMain = class(TForm)
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
    actnExportExcel: TAction;
    actnExportHTML: TAction;
    actnExportXML: TAction;
    actnExportCSV: TAction;
    cmbxCategories: TComboBox;
    lvWorkstations: TListView;
    imglstNetRes: TImageList;
    rbngrpIPRange: TRibbonGroup;
    actnEnterIPRange: TAction;
    actnAutoScan: TAction;
    actnManualScan: TAction;
    procedure FormShow(Sender: TObject);
    procedure actnStartScanExecute(Sender: TObject);
    procedure actnExportWordExecute(Sender: TObject);
    procedure cmbxCategoriesSelect(Sender: TObject);
    procedure actnExportExcelExecute(Sender: TObject);
    procedure actnExportHTMLExecute(Sender: TObject);
    procedure actnExportXMLExecute(Sender: TObject);
    procedure actnExportCSVExecute(Sender: TObject);
    procedure actnPauseScanExecute(Sender: TObject);
    procedure actnStopScanExecute(Sender: TObject);
    procedure actnEnterIPRangeExecute(Sender: TObject);
    procedure actnAutoScanExecute(Sender: TObject);
    procedure actnManualScanExecute(Sender: TObject);
  private
    FScanThread : TScanThread;
    FScanType : TScanType;

    function  GetExportFileExt(const Exporter : TJvCustomDBGridExport) : String;
    procedure ExportGrid(const Exporter : TJvCustomDBGridExport);
    procedure InitCategoriesCombo;
  public
    procedure Init;
  end;

var
  frmMain: TfrmMain;

implementation

uses Test, PassWord, SplashScreen, Constants, IPRange;

{$R *.dfm}

procedure TfrmMain.actnAutoScanExecute(Sender: TObject);
begin
  FScanType := stAuto;
end;

procedure TfrmMain.actnEnterIPRangeExecute(Sender: TObject);
begin
  frmIPRange.ShowModal;
end;

procedure TfrmMain.actnExportCSVExecute(Sender: TObject);
begin
  ExportGrid(dtmdlJvDBComponents.JvDBGridCSVExport);
end;

procedure TfrmMain.actnExportExcelExecute(Sender: TObject);
begin
  ExportGrid(dtmdlJvDBComponents.JvDBGridExcelExport);
end;

procedure TfrmMain.actnExportHTMLExecute(Sender: TObject);
begin
  ExportGrid(dtmdlJvDBComponents.JvDBGridHTMLExport);
end;

procedure TfrmMain.actnExportWordExecute(Sender: TObject);
begin
  ExportGrid(dtmdlJvDBComponents.JvDBGridWordExport);
end;

procedure TfrmMain.actnExportXMLExecute(Sender: TObject);
begin
  ExportGrid(dtmdlJvDBComponents.JvDBGridXMLExport);
end;

procedure TfrmMain.actnManualScanExecute(Sender: TObject);
begin
  FScanType := stManual;
  actnEnterIPRange.Execute;
end;

procedure TfrmMain.actnPauseScanExecute(Sender: TObject);
begin
  If Assigned(FScanThread) Then FScanThread.Suspended := Not FScanThread.Suspended;
end;

procedure TfrmMain.actnStartScanExecute(Sender: TObject);
begin
  jvtrvWorkgroups.Items.Clear;
  lvWorkstations.Clear;
  FScanThread := TScanThread.Create;
end;

procedure TfrmMain.actnStopScanExecute(Sender: TObject);
begin
  CreateTask(
    procedure (const task: IOmniTask)
    begin
      FreeAndNil(FScanThread);
    end);
end;

procedure TfrmMain.cmbxCategoriesSelect(Sender: TObject);
  var
    S : String;
begin
  S := cmbxCategories.Items[cmbxCategories.ItemIndex];  // Имя таблицы
  dtmdlJvDBComponents.SetCurrentDB(TablesDictionary.Items[S]);  // Имя БД

  With dtmdlJvDBComponents do
  begin
    ZQuery.Active := False;
    //JvDataSource.DataSet := ZQuery; // AV
    ZQuery.SQL.Text := SelectAllJoinFKQuery(S);
    ZQuery.Active := True;
  end;

end;

procedure TfrmMain.ExportGrid(const Exporter: TJvCustomDBGridExport);
  var
    sFileName, sFileExt : String;
begin
  sFileExt := GetExportFileExt(Exporter);
  SaveDialog.Filter := AnsiUpperCase(DeleteEx(sFileExt, 1, 1)) + '-files|*' + sFileExt;
  SaveDialog.FileName := ValidateFileName(DateTimeToStr(Now));

  If SaveDialog.Execute(Handle) Then
  begin
    Exporter.Grid := jvdbgrdResults;

    sFileName := SaveDialog.FileName;
    If Not AnsiSameText(ExtractFileExt(sFileName), sFileExt) Then
      sFileName := sFileName + sFileExt;
    Exporter.FileName := sFileName;

    Try
      Exporter.ExportGrid;
    Except
      on E:EOleSysError do else raise;  // Supressing strange OLE exception
    End;
  end;
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

        { TODO : переделать на default values. }
        frmTest.btnSavePasswordClick(nil);
        frmTest.btnSaveDBSettingsClick(nil);

        frmTest.Show;
        Init;
      end;
    else
      raise Exception.Create('Not OK or Cancel');
  End;
end;

function TfrmMain.GetExportFileExt(
  const Exporter: TJvCustomDBGridExport): String;
begin
  If Exporter is TJvDBGridExcelExport Then Result := '.xls' Else
  If Exporter is TJvDBGridWordExport Then Result := '.doc' Else
  If Exporter is TJvDBGridHTMLExport Then Result := '.htm' Else
  If Exporter is TJvDBGridXMLExport Then Result := '.xml' Else
  If Exporter is TJvDBGridCSVExport Then Result := '.txt' Else Result := '';
end;

procedure TfrmMain.Init;
begin
  jvdbgrdResults.DataSource := dtmdlJvDBComponents.JvDataSource;
  If dtmdlJvDBComponents.ConnectToDB Then
  begin
    dtmdlDBInit.InitDB;
    InitCategoriesCombo;
  end;
end;

procedure TfrmMain.InitCategoriesCombo;
begin
  dtmdlJvDBComponents.FillAllTables(cmbxCategories.Items);
end;

end.

unit Test;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmTest = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    btnSaveDBSettings: TButton;
    btnLoadDBSettings: TButton;
    btnDBInit: TButton;
    procedure btnSaveDBSettingsClick(Sender: TObject);
    procedure btnLoadDBSettingsClick(Sender: TObject);
    procedure btnDBInitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTest: TfrmTest;

implementation

uses AppSettingsSource, DBInit;

{$R *.dfm}

procedure TfrmTest.btnDBInitClick(Sender: TObject);
begin
  dtmdlDBInit.InitDB;
end;

procedure TfrmTest.btnLoadDBSettingsClick(Sender: TObject);
begin
  DBSettings.LoadFromFile;
end;

procedure TfrmTest.btnSaveDBSettingsClick(Sender: TObject);
begin
  DBSettings.SaveToFile;
end;

end.

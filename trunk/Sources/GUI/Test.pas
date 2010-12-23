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
    btnFillDBWithDIVISIONS: TButton;
    TabSheet2: TTabSheet;
    btnSavePassword: TButton;
    btnLoadPasswordHash: TButton;
    procedure btnSaveDBSettingsClick(Sender: TObject);
    procedure btnLoadDBSettingsClick(Sender: TObject);
    procedure btnDBInitClick(Sender: TObject);
    procedure btnFillDBWithDIVISIONSClick(Sender: TObject);
    procedure btnSavePasswordClick(Sender: TObject);
    procedure btnLoadPasswordHashClick(Sender: TObject);
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

procedure TfrmTest.btnFillDBWithDIVISIONSClick(Sender: TObject);
begin
  //
end;

procedure TfrmTest.btnLoadDBSettingsClick(Sender: TObject);
begin
  DBSettings.LoadFromFile;
end;

procedure TfrmTest.btnLoadPasswordHashClick(Sender: TObject);
begin
  PasswordStore.LoadFromFile;
  ShowMessage(PasswordStore.PasswordHash);
end;

procedure TfrmTest.btnSaveDBSettingsClick(Sender: TObject);
begin
  With DBSettings do
  begin
    HostName := '127.0.0.1';
    Port := 3306;
    User := 'root';
    Password := 'qwertybash';
    SaveToFile;
  end;
end;

procedure TfrmTest.btnSavePasswordClick(Sender: TObject);
begin
  PasswordStore.Hash('qwertybash');
  PasswordStore.SaveToFile;
end;

end.

unit Main;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sSkinProvider, sSkinManager, XPMan;

type
  TfrmMain = class(TForm)
    SkinManager: TsSkinManager;
    SkinProvider: TsSkinProvider;
    XPManifest: TXPManifest;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses Test, PassWord, SplashScreen;

{$R *.dfm}

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
      end;
    else
      raise Exception.Create('Not OK or Cancel');
  End;
end;

end.

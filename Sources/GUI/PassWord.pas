unit PASSWORD;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
  Spring.Cryptography, AppSettingsSource, sSkinProvider;

type
  TPasswordDlg = class(TForm)
    Label1: TLabel;
    Password: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    SkinProvider: TsSkinProvider;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    function PasswordIsCorrect(const Password : String) : Boolean;
  public
    { Public declarations }
  end;

var
  PasswordDlg: TPasswordDlg;

implementation

{$R *.dfm}

procedure TPasswordDlg.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TPasswordDlg.OKBtnClick(Sender: TObject);
begin
  If PasswordIsCorrect(Password.Text) Then
  begin
    ModalResult := mrOK;
    OKBtn.ModalResult := mrOK;
  end
  Else
  begin
    Beep;
    Password.Text := '';
    Password.SetFocus;
    ModalResult := mrNone;
    OKBtn.ModalResult := mrNone;
  end;
end;

function TPasswordDlg.PasswordIsCorrect(const Password: String): Boolean;
  var
    Hash : TSHA512;
begin
  Hash := TSHA512.Create;
  Try
    PasswordStore.LoadFromFile;
    Result := Hash.ComputeHash(Password).Equals(PasswordStore.PasswordHash);
  Finally
    FreeAndNil(Hash);
  End;
end;

end.

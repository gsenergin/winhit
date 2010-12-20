unit Main;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmMain = class(TForm)
    btnTest: TButton;
    procedure btnTestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses Test;

{$R *.dfm}

procedure TfrmMain.btnTestClick(Sender: TObject);
begin
  WindowState := wsMinimized;
  frmTest.ShowModal;
  WindowState := wsNormal;
end;

end.

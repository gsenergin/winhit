unit IPRange;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JvExControls, JvComCtrls;

type
  TfrmIPRange = class(TForm)
    lbIPRanges: TListBox;
    btnDelete: TBitBtn;
    btnUp: TBitBtn;
    btnDown: TBitBtn;
    grpbxMain: TGroupBox;
    jvipStart: TJvIPAddress;
    btnChange: TBitBtn;
    btnAdd: TBitBtn;
    jvipEnd: TJvIPAddress;
    lblSeparator: TLabel;
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmIPRange: TfrmIPRange;

implementation

{$R *.dfm}

procedure TfrmIPRange.btnAddClick(Sender: TObject);
begin
  lbIPRanges.Items.Add(jvipStart.Text + lblSeparator.Caption + jvipEnd.Text);
end;

end.

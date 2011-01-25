unit InventoryNumberInput;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ManualInput, StdCtrls;

type
  TfrmInventoryNumberInput = class(TfrmManualInput)
    edtData: TEdit;
    btnFromGUID: TButton;
    btnFromMD5: TButton;
    btnFromSHA1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInventoryNumberInput: TfrmInventoryNumberInput;

implementation

{$R *.dfm}

end.

unit Main;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  StdCtrls, ComCtrls, ZConnection, ActnList, CWMIBase, RTTI, TypInfo,
  StrUtils, Generics.Collections;

type
  TfrmMain = class(TForm)
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

var
  frmMain: TfrmMain;

implementation

uses WMIHardware, WMISoftware;

{$R *.dfm}

end.

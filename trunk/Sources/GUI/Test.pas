unit Test;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, MySQLAdapter, RTTI, Generics.Collections;

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
    btnBuildInsertQuery: TButton;
    procedure btnSaveDBSettingsClick(Sender: TObject);
    procedure btnLoadDBSettingsClick(Sender: TObject);
    procedure btnDBInitClick(Sender: TObject);
    procedure btnFillDBWithDIVISIONSClick(Sender: TObject);
    procedure btnSavePasswordClick(Sender: TObject);
    procedure btnLoadPasswordHashClick(Sender: TObject);
    procedure btnBuildInsertQueryClick(Sender: TObject);
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

procedure TfrmTest.btnBuildInsertQueryClick(Sender: TObject);
  var
    Arr : TList<TValue>;
    L : TStringList;
begin
  Arr := TList<TValue>.Create;
  Arr.Add(TValue.From('Val1'));
  Arr.Add(TValue.From('Val2'));
  Arr.Add(TValue.From('Val3'));

  L := TStringList.Create;
  L.Add('Col1');
  L.Add('Col2');
  L.Add('Col3');

  ShowMessage(InsertQuery('divisions', L, Arr));

  Arr.Free;
  L.Free;
end;

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

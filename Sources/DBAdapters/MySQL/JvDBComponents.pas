unit JvDBComponents;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBConnector, ZConnection, JvDBGridExport, JvComponentBase, DB,
  JvDataSource, ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset,
  Constants, MySQLHelpers, ZSqlMonitor, ZAbstractConnection;

type
  TdtmdlJvDBComponents = class(TdtmdlDBConnector)
    JvDataSource: TJvDataSource;
    JvDBGridWordExport: TJvDBGridWordExport;
    JvDBGridExcelExport: TJvDBGridExcelExport;
    JvDBGridHTMLExport: TJvDBGridHTMLExport;
    JvDBGridCSVExport: TJvDBGridCSVExport;
    JvDBGridXMLExport: TJvDBGridXMLExport;
  private
    { Private declarations }
  public
    procedure FillAllTables(const List: TStrings);
    procedure FillHardwareTables(const List: TStrings);
    procedure FillMainTables(const List: TStrings);
    procedure FillSoftwareTables(const List: TStrings);

    procedure SetCurrentDB(const Database : String);
  end;

var
  dtmdlJvDBComponents: TdtmdlJvDBComponents;

implementation

{$R *.dfm}

{ TdtmdlJvDBComponents }

procedure TdtmdlJvDBComponents.FillAllTables(const List: TStrings);
  var
    L : TStringList;
begin
  Assert(Assigned(List));

  L := TStringList.Create;
  Try
    FillMainTables(L);
    List.AddStrings(L);

    FillHardwareTables(L);
    List.AddStrings(L);

    FillSoftwareTables(L);
    List.AddStrings(L);
  Finally
    FreeAndNil(L);
  End;
end;

procedure TdtmdlJvDBComponents.FillHardwareTables(const List: TStrings);
  var
    S : String;
begin
  Assert(Assigned(List));
  ZConnection.GetTableNames('%', STR_DB_HARDWARE, List);
  For S in List do
    TablesDictionary.Add(S, STR_DB_HARDWARE);
end;

procedure TdtmdlJvDBComponents.FillMainTables(const List: TStrings);
  var
    S : String;
begin
  Assert(Assigned(List));
  ZConnection.GetTableNames('%', STR_DB_MAIN, List);
  For S in List do
    TablesDictionary.Add(S, STR_DB_MAIN);
end;

procedure TdtmdlJvDBComponents.FillSoftwareTables(const List: TStrings);
  var
    S : String;
begin
  Assert(Assigned(List));
  ZConnection.GetTableNames('%', STR_DB_SOFTWARE, List);
  For S in List do
    TablesDictionary.Add(S, STR_DB_SOFTWARE);
end;

/// <summary>
///  ������������� ������� �� � ����������������.
/// </summary>
/// <param name="Database">
///  ��� �� (�����), � ������� ���������� ����������� �����������.
/// </param>
procedure TdtmdlJvDBComponents.SetCurrentDB(const Database: String);
begin
  ZConnection.Connected := False;
  ZConnection.Database  := Database;
  ZConnection.Connected := True;
end;

end.

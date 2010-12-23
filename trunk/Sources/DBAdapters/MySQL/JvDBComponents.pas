unit JvDBComponents;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBConnector, ZConnection, JvDBGridExport, JvComponentBase, DB,
  JvDataSource, ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset;

type
  TdtmdlJvDBComponents = class(TdtmdlDBConnector)
    ZTable: TZTable;
    JvDataSource: TJvDataSource;
    JvDBGridWordExport: TJvDBGridWordExport;
    JvDBGridExcelExport: TJvDBGridExcelExport;
    JvDBGridHTMLExport: TJvDBGridHTMLExport;
    JvDBGridCSVExport: TJvDBGridCSVExport;
    JvDBGridXMLExport: TJvDBGridXMLExport;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmdlJvDBComponents: TdtmdlJvDBComponents;

implementation

{$R *.dfm}

end.

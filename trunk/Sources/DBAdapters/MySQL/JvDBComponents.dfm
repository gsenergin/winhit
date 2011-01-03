inherited dtmdlJvDBComponents: TdtmdlJvDBComponents
  OldCreateOrder = True
  Height = 197
  Width = 358
  object JvDataSource: TJvDataSource
    DataSet = ZQuery
    Left = 208
    Top = 16
  end
  object JvDBGridWordExport: TJvDBGridWordExport
    Caption = 'Exporting to MS Word...'
    Left = 176
    Top = 80
  end
  object JvDBGridExcelExport: TJvDBGridExcelExport
    Caption = 'Exporting to MS Excel...'
    AutoFit = False
    Left = 48
    Top = 80
  end
  object JvDBGridHTMLExport: TJvDBGridHTMLExport
    Caption = 'Exporting to HTML...'
    Header.Strings = (
      '<html><head><title><#TITLE></title>'
      '<style type=text/css>'
      '#STYLE'
      '</style>'
      '</head><body>')
    Footer.Strings = (
      '</body></html>')
    DocTitle = 'Grid to HTML Export'
    Left = 48
    Top = 144
  end
  object JvDBGridCSVExport: TJvDBGridCSVExport
    Caption = 'Exporting to CSV/Text...'
    Left = 280
    Top = 144
  end
  object JvDBGridXMLExport: TJvDBGridXMLExport
    Left = 168
    Top = 144
  end
end

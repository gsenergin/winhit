object dtmdlDBConnector: TdtmdlDBConnector
  OldCreateOrder = False
  Height = 76
  Width = 268
  object ZConnection: TZConnection
    Protocol = 'mysql-5'
    Properties.Strings = (
      'codepage=cp1251')
    SQLHourGlass = True
    Left = 24
    Top = 16
  end
  object ZTable: TZTable
    Connection = ZConnection
    Left = 88
    Top = 16
  end
  object ZQuery: TZQuery
    Connection = ZConnection
    Params = <>
    Left = 144
    Top = 16
  end
  object ZSQLMonitor: TZSQLMonitor
    Active = True
    AutoSave = True
    FileName = 'DBConnector.log'
    MaxTraceCount = 100
    Left = 208
    Top = 16
  end
end

object dtmdlDBConnector: TdtmdlDBConnector
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 76
  Width = 268
  object ZConnection: TZConnection
    Properties.Strings = (
      'codepage=ucs2'
      'compress=true')
    SQLHourGlass = True
    Protocol = 'mysql-5'
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

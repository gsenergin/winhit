object frmTest: TfrmTest
  Left = 0
  Top = 0
  Caption = 'frmTest'
  ClientHeight = 534
  ClientWidth = 778
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 778
    Height = 534
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object btnSaveDBSettings: TButton
        Left = 8
        Top = 8
        Width = 113
        Height = 25
        Caption = 'btnSaveDBSettings'
        TabOrder = 0
        OnClick = btnSaveDBSettingsClick
      end
      object btnLoadDBSettings: TButton
        Left = 8
        Top = 39
        Width = 113
        Height = 25
        Caption = 'btnLoadDBSettings'
        TabOrder = 1
        OnClick = btnLoadDBSettingsClick
      end
      object btnDBInit: TButton
        Left = 8
        Top = 70
        Width = 113
        Height = 25
        Caption = 'btnDBInit'
        TabOrder = 2
        OnClick = btnDBInitClick
      end
      object btnFillDBWithDIVISIONS: TButton
        Left = 140
        Top = 8
        Width = 133
        Height = 25
        Caption = 'btnFillDBWithDIVISIONS'
        TabOrder = 3
        OnClick = btnFillDBWithDIVISIONSClick
      end
      object btnBuildInsertQuery: TButton
        Left = 140
        Top = 39
        Width = 133
        Height = 25
        Caption = 'btnBuildInsertQuery'
        TabOrder = 4
        OnClick = btnBuildInsertQueryClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object btnSavePassword: TButton
        Left = 16
        Top = 16
        Width = 129
        Height = 25
        Caption = 'btnSavePassword'
        TabOrder = 0
        OnClick = btnSavePasswordClick
      end
      object btnLoadPasswordHash: TButton
        Left = 16
        Top = 47
        Width = 129
        Height = 25
        Caption = 'btnLoadPasswordHash'
        TabOrder = 1
        OnClick = btnLoadPasswordHashClick
      end
    end
  end
end

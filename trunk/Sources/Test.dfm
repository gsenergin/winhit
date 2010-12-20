object frmTest: TfrmTest
  Left = 0
  Top = 0
  Caption = 'frmTest'
  ClientHeight = 202
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
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
end

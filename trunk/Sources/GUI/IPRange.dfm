object frmIPRange: TfrmIPRange
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1076#1080#1072#1087#1072#1079#1086#1085#1072' IP-'#1072#1076#1088#1077#1089#1086#1074
  ClientHeight = 516
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbIPRanges: TListBox
    Left = 0
    Top = 0
    Width = 450
    Height = 281
    Align = alTop
    ItemHeight = 13
    TabOrder = 0
  end
  object btnDelete: TBitBtn
    Left = 40
    Top = 296
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Caption = #1059#1076#1072#1083#1080#1090#1100
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
  end
  object btnUp: TBitBtn
    Left = 176
    Top = 296
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Caption = #1042#1074#1077#1088#1093
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
  end
  object btnDown: TBitBtn
    Left = 320
    Top = 296
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Caption = #1042#1085#1080#1079
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 3
  end
  object grpbxMain: TGroupBox
    Left = 0
    Top = 336
    Width = 450
    Height = 180
    Align = alBottom
    Caption = #1047#1072#1076#1072#1085#1080#1077' '#1076#1080#1072#1087#1072#1079#1086#1085#1072
    TabOrder = 4
    object lblSeparator: TLabel
      Left = 209
      Top = 30
      Width = 17
      Height = 58
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -48
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object jvipStart: TJvIPAddress
      Left = 40
      Top = 52
      Width = 150
      Height = 21
      AddressValues.Address = 0
      AddressValues.Value1 = 0
      AddressValues.Value2 = 0
      AddressValues.Value3 = 0
      AddressValues.Value4 = 0
      ParentColor = False
      TabOrder = 0
      Text = '0.0.0.0'
    end
    object btnChange: TBitBtn
      Left = 176
      Top = 127
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
    end
    object btnAdd: TBitBtn
      Left = 176
      Top = 96
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 2
      OnClick = btnAddClick
    end
    object jvipEnd: TJvIPAddress
      Left = 245
      Top = 52
      Width = 150
      Height = 21
      AddressValues.Address = 0
      AddressValues.Value1 = 0
      AddressValues.Value2 = 0
      AddressValues.Value3 = 0
      AddressValues.Value4 = 0
      ParentColor = False
      TabOrder = 3
      Text = '0.0.0.0'
    end
  end
end

object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'WinHIT'
  ClientHeight = 561
  ClientWidth = 780
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object rbnMain: TRibbon
    Left = 0
    Top = 0
    Width = 780
    Height = 143
    ActionManager = ActionManager
    Caption = 
      #1052#1086#1085#1080#1090#1086#1088#1080#1085#1075' '#1080' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1085#1086'-'#1072#1087#1087#1072#1088#1072#1090#1085#1099#1093' '#1088#1077#1089#1091#1088#1089#1086#1074' '#1088#1072#1073#1086#1095 +
      #1080#1093' '#1089#1090#1072#1085#1094#1080#1081
    Tabs = <
      item
        Caption = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
        Page = rbnpgInventory
      end
      item
        Caption = #1057#1080#1089#1090#1077#1084#1072' '#1084#1086#1085#1080#1090#1086#1088#1080#1085#1075#1072
        Page = rbnpgMonitoring
      end
      item
        Caption = #1043#1077#1085#1077#1088#1072#1090#1086#1088' '#1086#1090#1095#1105#1090#1086#1074
        Page = rbnpgReports
      end>
    TabIndex = 2
    DesignSize = (
      780
      143)
    StyleName = 'Ribbon - Luna'
    object rbnpgInventory: TRibbonPage
      Left = 0
      Top = 50
      Width = 779
      Height = 93
      Caption = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      Index = 0
      object rbngrpScanType: TRibbonGroup
        Left = 4
        Top = 3
        Width = 158
        Height = 86
        ActionManager = ActionManager
        Caption = #1042#1099#1073#1086#1088' '#1090#1080#1087#1072' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103
        GroupIndex = 0
        object rbncmbxScanType: TRibbonComboBox
          Left = 104
          Top = 5
          Width = 36
          Height = 17
          TabOrder = 0
        end
      end
      object rbngrpScanManage: TRibbonGroup
        Left = 164
        Top = 3
        Width = 169
        Height = 86
        ActionManager = ActionManager
        Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077#1084
        GroupIndex = 1
      end
    end
    object rbnpgMonitoring: TRibbonPage
      Left = 0
      Top = 50
      Width = 779
      Height = 93
      Caption = #1057#1080#1089#1090#1077#1084#1072' '#1084#1086#1085#1080#1090#1086#1088#1080#1085#1075#1072
      Index = 1
    end
    object rbnpgReports: TRibbonPage
      Left = 0
      Top = 50
      Width = 779
      Height = 93
      Caption = #1043#1077#1085#1077#1088#1072#1090#1086#1088' '#1086#1090#1095#1105#1090#1086#1074
      Index = 2
      object RibbonGroup1: TRibbonGroup
        Left = 4
        Top = 3
        Width = 97
        Height = 86
        ActionManager = ActionManager
        Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1086#1090#1095#1105#1090#1072' Word'
        GroupIndex = 0
      end
      object RibbonGroup2: TRibbonGroup
        Left = 103
        Top = 3
        Width = 96
        Height = 86
        ActionManager = ActionManager
        Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1086#1090#1095#1105#1090#1072' Excel'
        GroupIndex = 1
      end
      object RibbonGroup3: TRibbonGroup
        Left = 201
        Top = 3
        Width = 97
        Height = 86
        ActionManager = ActionManager
        Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1086#1090#1095#1105#1090#1072' HTML'
        GroupIndex = 2
      end
      object RibbonGroup4: TRibbonGroup
        Left = 300
        Top = 3
        Width = 90
        Height = 86
        ActionManager = ActionManager
        Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1086#1090#1095#1105#1090#1072' XML'
        GroupIndex = 3
      end
      object RibbonGroup5: TRibbonGroup
        Left = 392
        Top = 3
        Width = 90
        Height = 86
        ActionManager = ActionManager
        Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1086#1090#1095#1105#1090#1072' CSV'
        GroupIndex = 4
      end
    end
  end
  object pgctrlMain: TPageControl
    Left = 0
    Top = 143
    Width = 780
    Height = 399
    ActivePage = tbshtScanResults
    Align = alClient
    TabOrder = 1
    TabPosition = tpBottom
    object tbshtWorkstationsTree: TTabSheet
      Caption = #1044#1077#1088#1077#1074#1086' '#1088#1072#1073#1086#1095#1080#1093' '#1089#1090#1072#1085#1094#1080#1081
      object Splitter: TSplitter
        Left = 145
        Top = 0
        Width = 9
        Height = 373
        ExplicitLeft = 272
        ExplicitTop = 80
        ExplicitHeight = 249
      end
      object jvtrvWorkgroups: TJvTreeView
        Left = 0
        Top = 0
        Width = 145
        Height = 373
        Align = alLeft
        Indent = 19
        TabOrder = 0
        LineColor = clScrollBar
      end
      object jvlstvWorkstations: TJvListView
        Left = 154
        Top = 0
        Width = 618
        Height = 373
        Align = alClient
        Columns = <>
        Groups = <>
        TabOrder = 1
        ExtendedColumns = <>
      end
    end
    object tbshtScanResults: TTabSheet
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103
      ImageIndex = 1
      object JvPanel1: TJvPanel
        Left = 0
        Top = 0
        Width = 772
        Height = 41
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          Left = 520
          Top = 10
          Width = 92
          Height = 13
          Caption = #1042#1099#1073#1086#1088' '#1082#1072#1090#1077#1075#1086#1088#1080#1080':'
        end
        object cmbxCategories: TComboBox
          Left = 618
          Top = 5
          Width = 145
          Height = 21
          Style = csDropDownList
          Sorted = True
          TabOrder = 0
          OnSelect = cmbxCategoriesSelect
        end
      end
      object jvdbgrdResults: TJvDBUltimGrid
        Left = 0
        Top = 41
        Width = 772
        Height = 332
        Align = alClient
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 542
    Width = 780
    Height = 19
    Panels = <>
  end
  object XPManifest: TXPManifest
    Left = 680
    Top = 16
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1077
              end
              item
                Caption = #1044#1080#1072#1087#1072#1079#1086#1085' '#1072#1076#1088#1077#1089#1086#1074
              end>
            Caption = #1058#1080#1087' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103
            CommandStyle = csComboBox
            CommandProperties.Width = 150
            CommandProperties.ContainedControl = rbncmbxScanType
          end>
        ActionBar = rbngrpScanType
      end
      item
        Items = <
          item
            Action = actnStartScan
          end
          item
            Action = actnPauseScan
          end
          item
            Action = actnStopScan
          end>
        ActionBar = rbngrpScanManage
      end
      item
        Items = <
          item
            Action = actnExportWord
            Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' &Word'
          end>
        ActionBar = RibbonGroup1
      end
      item
        Items = <
          item
            Action = actnExportExcel
            Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' &Excel'
          end>
        ActionBar = RibbonGroup2
      end
      item
        Items = <
          item
            Action = actnExportHTML
            Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' &HTML'
          end>
        ActionBar = RibbonGroup3
      end
      item
        Items = <
          item
            Action = actnExportXML
            Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' &XML'
          end>
        ActionBar = RibbonGroup4
      end
      item
        Items = <
          item
            Action = actnExportCSV
            Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' &CSV'
          end>
        ActionBar = RibbonGroup5
      end>
    Left = 680
    Top = 72
    StyleName = 'Ribbon - Luna'
    object actnStartScan: TAction
      Caption = #1053#1072#1095#1072#1090#1100' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077
      OnExecute = actnStartScanExecute
    end
    object actnPauseScan: TAction
      Caption = #1055#1088#1080#1086#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077
    end
    object actnStopScan: TAction
      Caption = #1055#1088#1077#1088#1074#1072#1090#1100' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077
    end
    object actnExportWord: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' Word'
      OnExecute = actnExportWordExecute
    end
    object actnExportExcel: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' Excel'
      OnExecute = actnExportExcelExecute
    end
    object actnExportHTML: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' HTML'
      OnExecute = actnExportHTMLExecute
    end
    object actnExportXML: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' XML'
      OnExecute = actnExportXMLExecute
    end
    object actnExportCSV: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' CSV'
      OnExecute = actnExportCSVExecute
    end
  end
  object imglstActions: TImageList
    Left = 672
    Top = 120
  end
  object SaveDialog: TSaveDialog
    Left = 600
    Top = 72
  end
end
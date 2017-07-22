object FormMain: TFormMain
  Left = 240
  Top = 252
  Width = 870
  Height = 640
  Caption = 'FormMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 862
    Height = 609
    ActivePage = TabSheetScripts
    Align = alClient
    TabOrder = 0
    object TabSheetScripts: TTabSheet
      Caption = #1057#1082#1088#1080#1087#1090#1099
      object Splitter1: TSplitter
        Left = 225
        Top = 0
        Width = 8
        Height = 581
      end
      object ShellTreeViewScripts: TShellTreeView
        Left = 0
        Top = 0
        Width = 225
        Height = 581
        ObjectTypes = [otFolders, otNonFolders]
        Root = 'rfDesktop'
        UseShellImages = True
        Align = alLeft
        AutoRefresh = False
        Indent = 19
        ParentColor = False
        PopupMenu = PopupMenuTreeScripts
        RightClickSelect = True
        ShowRoot = False
        TabOrder = 0
        OnDblClick = ShellTreeViewScriptsDblClick
      end
      object PageControlScripts: TPageControl
        Left = 233
        Top = 0
        Width = 621
        Height = 581
        Align = alClient
        PopupMenu = PopupMenuTabsScript
        TabOrder = 1
      end
    end
    object TabSheetRun: TTabSheet
      Caption = #1052#1086#1085#1080#1090#1086#1088
      ImageIndex = 1
      object Splitter2: TSplitter
        Left = 217
        Top = 0
        Width = 8
        Height = 581
      end
      object ValueListEditorScripts: TValueListEditor
        Left = 0
        Top = 0
        Width = 217
        Height = 581
        Align = alLeft
        TabOrder = 0
        ColWidths = (
          150
          61)
      end
      object WebBrowserRun: TWebBrowser
        Left = 225
        Top = 0
        Width = 629
        Height = 581
        Align = alClient
        TabOrder = 1
        ControlData = {
          4C000000024100000C3C00000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object TabSheetReports: TTabSheet
      Caption = #1054#1090#1095#1105#1090
      ImageIndex = 2
      object WebBrowserReport: TWebBrowser
        Left = 0
        Top = 0
        Width = 854
        Height = 581
        Align = alClient
        TabOrder = 0
        ControlData = {
          4C000000435800000C3C00000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
  end
  object PopupMenuTabsScript: TPopupMenu
    Left = 276
    Top = 64
    object N5: TMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100
      OnClick = N5Click
    end
    object N6: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ShortCut = 16467
      OnClick = N6Click
    end
  end
  object PopupMenuTreeScripts: TPopupMenu
    Left = 276
    Top = 248
    object N1: TMenuItem
      Caption = #1057#1086#1079#1076#1072#1090#1100
      object N3: TMenuItem
        Caption = #1050#1072#1090#1072#1083#1086#1075
        OnClick = N3Click
      end
      object N4: TMenuItem
        Caption = #1060#1072#1081#1083
        OnClick = N4Click
      end
    end
    object N2: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = N2Click
    end
  end
  object SynPHPSyn1: TSynPHPSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    CommentAttri.Background = clGray
    IdentifierAttri.Foreground = clPurple
    NumberAttri.Foreground = clGreen
    StringAttri.Foreground = clNavy
    VariableAttri.Foreground = clFuchsia
    Left = 417
    Top = 104
  end
end

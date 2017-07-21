object FormMain: TFormMain
  Left = 192
  Top = 111
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

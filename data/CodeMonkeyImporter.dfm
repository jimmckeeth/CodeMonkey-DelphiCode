object Form16: TForm16
  Left = 0
  Top = 0
  Caption = 'Form16'
  ClientHeight = 646
  ClientWidth = 980
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  DesignSize = (
    980
    646)
  PixelsPerInch = 96
  TextHeight = 13
  object btnInport: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Inport'
    Enabled = False
    TabOrder = 0
    OnClick = btnInportClick
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 39
    Width = 964
    Height = 568
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DataSource1
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Idx'
        ReadOnly = True
        Width = 32
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Original'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Code'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Script'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Start'
        Width = 48
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Finish'
        Width = 48
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Duration'
        Width = 48
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Space'
        Width = 48
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Offset'
        Width = 48
        Visible = True
      end>
  end
  object btnSave: TButton
    Left = 121
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object btnLoad: TButton
    Left = 202
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 3
    OnClick = btnLoadClick
  end
  object btnCurRow: TButton
    Left = 424
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Cur Row'
    TabOrder = 4
    OnClick = btnCurRowClick
  end
  object btnFromHere: TButton
    Left = 505
    Top = 8
    Width = 75
    Height = 25
    Caption = 'From here'
    TabOrder = 5
    OnClick = btnFromHereClick
  end
  object btrnAbandon: TButton
    Left = 696
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Abandon'
    TabOrder = 6
    OnClick = btrnAbandonClick
  end
  object btnGetSpace: TButton
    Left = 608
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Get Space'
    TabOrder = 7
    OnClick = btnGetSpaceClick
  end
  object DBNavigator1: TDBNavigator
    Left = 8
    Top = 613
    Width = 240
    Height = 25
    DataSource = DataSource1
    Anchors = [akLeft, akBottom]
    TabOrder = 8
  end
  object Button1: TButton
    Left = 312
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Export'
    TabOrder = 9
    OnClick = Button1Click
  end
  object DataSource1: TDataSource
    DataSet = CodeMonkeyDS
    Left = 72
    Top = 96
  end
  object CodeMonkeyDS: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CodeMonkeyDSBeforeInsert
    AfterInsert = CodeMonkeyDSAfterInsert
    AfterDelete = CodeMonkeyDSAfterDelete
    OnCalcFields = CodeMonkeyDSCalcFields
    Left = 72
    Top = 152
    object CodeMonkeyDSIdx: TIntegerField
      FieldName = 'Idx'
    end
    object CodeMonkeyDSOriginal: TStringField
      FieldName = 'Original'
      Size = 500
    end
    object CodeMonkeyDSCode: TStringField
      FieldName = 'Code'
      Size = 500
    end
    object CodeMonkeyDSScript: TStringField
      FieldName = 'Script'
      Size = 500
    end
    object CodeMonkeyDSStart: TIntegerField
      FieldName = 'Start'
    end
    object CodeMonkeyDSFinish: TIntegerField
      FieldName = 'Finish'
    end
    object CodeMonkeyDSDuration: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Duration'
      Calculated = True
    end
    object CodeMonkeyDSSpace: TIntegerField
      FieldName = 'Space'
    end
    object CodeMonkeyDSOffset: TIntegerField
      FieldName = 'Offset'
    end
  end
end

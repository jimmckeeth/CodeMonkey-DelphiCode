object CodeMonkeyDataForm: TCodeMonkeyDataForm
  Left = 0
  Top = 0
  Caption = 'Code Monkey Animator'
  ClientHeight = 383
  ClientWidth = 908
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    908
    383)
  TextHeight = 13
  object btnInport: TButton
    Left = 8
    Top = 8
    Width = 60
    Height = 25
    Caption = 'Inport'
    TabOrder = 0
    OnClick = btnInportClick
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 64
    Width = 892
    Height = 289
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
        Title.Caption = 'Lyrics'
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
        Width = 272
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
    Left = 89
    Top = 8
    Width = 60
    Height = 25
    Caption = 'Save'
    Enabled = False
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object btnLoad: TButton
    Left = 89
    Top = 33
    Width = 60
    Height = 25
    Caption = 'Load'
    Enabled = False
    TabOrder = 3
    OnClick = btnLoadClick
  end
  object btnCurRow: TButton
    Left = 176
    Top = 8
    Width = 60
    Height = 25
    Caption = 'Cur Row'
    TabOrder = 4
    OnClick = btnCurRowClick
  end
  object btnFromHere: TButton
    Left = 176
    Top = 33
    Width = 60
    Height = 25
    Caption = 'From here'
    TabOrder = 5
    OnClick = btnFromHereClick
  end
  object btrnAbandon: TButton
    Left = 558
    Top = 8
    Width = 60
    Height = 25
    Caption = 'Abandon'
    TabOrder = 6
    OnClick = btrnAbandonClick
  end
  object btnGetSpace: TButton
    Left = 268
    Top = 8
    Width = 60
    Height = 25
    Caption = 'Get Space'
    TabOrder = 7
    OnClick = btnGetSpaceClick
  end
  object Button1: TButton
    Left = 8
    Top = 33
    Width = 60
    Height = 25
    Caption = 'Export'
    TabOrder = 8
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 665
    Top = 8
    Width = 60
    Height = 25
    Cancel = True
    Caption = 'ABORT'
    TabOrder = 9
    OnClick = Button2Click
  end
  object DBNavigator: TDBNavigator
    Left = 8
    Top = 359
    Width = 320
    Height = 20
    DataSource = DataSource1
    Anchors = [akLeft, akBottom]
    TabOrder = 10
    ExplicitTop = 342
  end
  object ckVeryFast: TRadioButton
    Left = 850
    Top = 8
    Width = 50
    Height = 17
    Caption = 'Fast'
    TabOrder = 11
  end
  object ckVerySlow: TRadioButton
    Left = 850
    Top = 41
    Width = 50
    Height = 17
    Caption = 'Slow'
    TabOrder = 12
  end
  object ckNormal: TRadioButton
    Left = 850
    Top = 24
    Width = 50
    Height = 17
    Caption = 'Normal'
    Checked = True
    TabOrder = 13
    TabStop = True
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

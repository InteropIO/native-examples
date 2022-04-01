object Form1: TForm1
  Left = 447
  Top = 208
  Width = 932
  Height = 615
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox4: TGroupBox
    Left = 0
    Top = 407
    Width = 916
    Height = 169
    Align = alBottom
    Caption = 'Log'
    TabOrder = 0
    object memLog: TMemo
      Left = 2
      Top = 15
      Width = 912
      Height = 152
      Align = alClient
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 377
    Top = 41
    Width = 248
    Height = 366
    Align = alLeft
    Caption = 'Discoverd Glue Methods'
    TabOrder = 1
    object ListBox1: TListBox
      Left = 2
      Top = 15
      Width = 244
      Height = 349
      Align = alClient
      ItemHeight = 13
      PopupMenu = PopupMenu1
      TabOrder = 0
      OnDblClick = ListBox1DblClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 41
    Width = 377
    Height = 366
    Align = alLeft
    Caption = 'Glue Channel Data'
    TabOrder = 2
    object TreeView1: TTreeView
      Left = 2
      Top = 57
      Width = 373
      Height = 307
      Align = alClient
      Indent = 19
      TabOrder = 0
    end
    object GroupBox7: TGroupBox
      Left = 2
      Top = 15
      Width = 373
      Height = 42
      Align = alTop
      Caption = 'Current channel'
      TabOrder = 1
      object Edit1: TEdit
        Left = 3
        Top = 17
        Width = 121
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object GroupBox6: TGroupBox
    Left = 0
    Top = 0
    Width = 916
    Height = 41
    Align = alTop
    Caption = 'Controls'
    TabOrder = 3
    object btnInit: TButton
      Left = 49
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Init Glue'
      TabOrder = 0
      OnClick = btnInitClick
    end
  end
  object Panel1: TPanel
    Left = 625
    Top = 41
    Width = 291
    Height = 366
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 4
    object GroupBox1: TGroupBox
      Left = 1
      Top = 143
      Width = 289
      Height = 222
      Align = alBottom
      Caption = 'Last invoke to Delphi T42.CRM.SyncContact'
      TabOrder = 0
      object TreeView2: TTreeView
        Left = 2
        Top = 15
        Width = 285
        Height = 205
        Align = alClient
        Indent = 19
        TabOrder = 0
      end
    end
    object GroupBox5: TGroupBox
      Left = 1
      Top = 1
      Width = 289
      Height = 142
      Align = alClient
      Caption = 'Send Glue Invoke to T42.CRM.SyncContact'
      TabOrder = 1
      object ListBox2: TListBox
        Left = 2
        Top = 15
        Width = 285
        Height = 125
        Align = alClient
        ItemHeight = 13
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnClick = ListBox2Click
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 24
    Top = 440
    object GlueInvoke1: TMenuItem
      Caption = 'Glue Invoke'
      OnClick = GlueInvoke1Click
    end
  end
end

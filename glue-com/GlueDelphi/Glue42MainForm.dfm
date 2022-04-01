object Form1: TForm1
  Left = 2000
  Top = 200
  Caption = 'Form1'
  ClientHeight = 649
  ClientWidth = 926
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 487
    Top = 89
    Width = 439
    Height = 335
    Align = alRight
    Caption = 'Methods'
    TabOrder = 0
    object Edit1: TEdit
      Left = 2
      Top = 15
      Width = 435
      Height = 21
      Align = alTop
      TabOrder = 0
      OnChange = Edit1Change
    end
    object ListBox1: TListBox
      Left = 2
      Top = 36
      Width = 435
      Height = 297
      Align = alClient
      ItemHeight = 13
      TabOrder = 1
      OnDblClick = ListBox1DblClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 926
    Height = 89
    Align = alTop
    Caption = 'Glue Control'
    TabOrder = 1
    object btnGlueInvoke: TButton
      Left = 16
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Invoke all'
      TabOrder = 0
      OnClick = btnGlueInvokeClick
    end
    object btnSubscribe: TButton
      Left = 16
      Top = 47
      Width = 75
      Height = 25
      Caption = 'Subscribe'
      TabOrder = 1
      OnClick = btnSubscribeClick
    end
    object btnPush: TButton
      Left = 308
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Push'
      TabOrder = 2
      OnClick = btnPushClick
    end
    object edtMethodName: TEdit
      Left = 97
      Top = 18
      Width = 184
      Height = 21
      TabOrder = 3
      Text = 'JSMethod'
    end
    object edtStreamName: TEdit
      Left = 98
      Top = 49
      Width = 185
      Height = 21
      TabOrder = 4
      Text = 'MarketData.LastTrades'
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 89
    Width = 487
    Height = 335
    Align = alClient
    Caption = 'Channel data'
    TabOrder = 2
    object TreeView1: TTreeView
      Left = 2
      Top = 15
      Width = 483
      Height = 318
      Align = alClient
      Indent = 19
      TabOrder = 0
    end
  end
  object GroupBox4: TGroupBox
    Left = 0
    Top = 424
    Width = 926
    Height = 225
    Align = alBottom
    Caption = 'Log'
    TabOrder = 3
    object memLog: TMemo
      Left = 2
      Top = 15
      Width = 922
      Height = 208
      Align = alClient
      TabOrder = 0
    end
  end
end

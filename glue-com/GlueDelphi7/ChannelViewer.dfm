object Form2: TForm2
  Left = 853
  Top = 349
  Width = 475
  Height = 404
  Caption = 'Channel Viewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox3: TGroupBox
    Left = 0
    Top = 0
    Width = 459
    Height = 365
    Align = alClient
    Caption = 'Glue Channel Data'
    TabOrder = 0
    object TreeView1: TTreeView
      Left = 2
      Top = 57
      Width = 455
      Height = 306
      Align = alClient
      Indent = 19
      TabOrder = 0
    end
    object GroupBox7: TGroupBox
      Left = 2
      Top = 15
      Width = 455
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
end

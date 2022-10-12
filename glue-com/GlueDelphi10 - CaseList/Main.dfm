object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Case List'
  ClientHeight = 341
  ClientWidth = 897
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 897
    Height = 200
    Align = alClient
    Caption = 'Case List'
    TabOrder = 0
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 200
    Width = 897
    Height = 141
    Align = alBottom
    Caption = 'Controls'
    TabOrder = 1
    DesignSize = (
      897
      141)
    object Image1: TImage
      Left = 6
      Top = 32
      Width = 95
      Height = 95
      Stretch = True
      OnClick = Image1Click
      OnMouseEnter = Image1MouseEnter
      OnMouseLeave = Image1MouseLeave
    end
    object Memo1: TMemo
      Left = 112
      Top = 24
      Width = 782
      Height = 114
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      TabOrder = 0
    end
  end
end

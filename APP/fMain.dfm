object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object edit: TEditValidator
    Left = 24
    Top = 136
    Width = 121
    Height = 21
    TabOrder = 0
    InputMask = False
    Validate = False
  end
  object RadioGroup1: TRadioGroup
    Left = 24
    Top = 8
    Width = 161
    Height = 65
    Caption = 'RadioGroup1'
    Items.Strings = (
      'CNPJ'
      'CPF')
    TabOrder = 1
    OnClick = RadioGroup1Click
  end
  object CheckBox1: TCheckBox
    Left = 240
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Validate'
    TabOrder = 2
    OnClick = CheckBox1Click
  end
  object CheckBox2: TCheckBox
    Left = 240
    Top = 40
    Width = 97
    Height = 17
    Caption = 'Mascara'
    TabOrder = 3
    OnClick = CheckBox2Click
  end
end

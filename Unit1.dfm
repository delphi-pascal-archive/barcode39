object Form1: TForm1
  Left = 245
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'BarCode39'
  ClientHeight = 121
  ClientWidth = 452
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object BarCode1: TBarCode
    Left = 176
    Top = 22
    Width = 202
    Height = 75
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    BarCodeType = EAN13
    Code = '3290123456786'
  end
  object Label1: TLabel
    Left = 7
    Top = 7
    Width = 124
    Height = 16
    Caption = 'Type of the barcode:'
  end
  object Label2: TLabel
    Left = 7
    Top = 64
    Width = 33
    Height = 16
    Caption = 'Code'
  end
  object EditCode: TEdit
    Left = 8
    Top = 88
    Width = 153
    Height = 25
    TabOrder = 1
    Text = '*BARCODE39*'
    OnChange = EditCodeChange
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 30
    Width = 153
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    ItemIndex = 2
    TabOrder = 0
    Text = 'Code39'
    OnChange = ComboBox1Change
    Items.Strings = (
      'EAN8'
      'EAN13'
      'Code39')
  end
end

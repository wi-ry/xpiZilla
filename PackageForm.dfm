object package: Tpackage
  Left = 443
  Top = 263
  BorderStyle = bsToolWindow
  Caption = 'Packaging Extension'
  ClientHeight = 137
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object listbox: TListBox
    Left = 8
    Top = 8
    Width = 281
    Height = 89
    ItemHeight = 13
    TabOrder = 0
  end
  object ok: TButton
    Left = 111
    Top = 104
    Width = 75
    Height = 25
    Caption = 'OK'
    Enabled = False
    TabOrder = 1
    OnClick = okClick
  end
  object savedialog: TSaveDialog
    DefaultExt = '.xpi'
    Filter = 'Extension Package|*.xpi'
    Left = 8
    Top = 104
  end
  object timer: TTimer
    Enabled = False
    Interval = 5000
    Left = 72
    Top = 104
  end
end

object package: Tpackage
  Left = 222
  Top = 141
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
  OnCreate = FormCreate
  OnShow = FormShow
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
  object zip: TZip
    Attributes = [fsZeroAttr, fsReadOnly, fsArchive, fsCompressed, fsEncrypted]
    DeleteOptions = doAllowUndo
    ArcType = atZip
    AttributesEx = []
    CompressMethod = cmDeflate
    DefaultExt = '.zip'
    StoreFilesOfType.Strings = (
      '.ACE'
      '.ARC'
      '.ARJ'
      '.BH'
      '.CAB'
      '.ENC'
      '.GZ'
      '.HA'
      '.JAR'
      '.LHA'
      '.LZH'
      '.PAK'
      '.PK3'
      '.PK_'
      '.RAR'
      '.TAR'
      '.TGZ'
      '.UUE'
      '.UU'
      '.WAR'
      '.XXE'
      '.Z'
      '.ZIP'
      '.ZOO')
    TempDir = 'C:\DOCUME~1\ADMINI~1\LOCALS~1\Temp\'
    OnEnd = zipEnd
    Switch = swAdd
    Left = 40
    Top = 104
  end
end

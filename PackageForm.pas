unit PackageForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Gauges, ExtCtrls, ztvregister, ztvBase,
  ztvZip;

type
  Tpackage = class(TForm)
    listbox: TListBox;
    ok: TButton;
    savedialog: TSaveDialog;
    zip: TZip;
    procedure okClick(Sender: TObject);
    procedure zipEnd(Sender: TObject; FileName: String; CRC_PASS: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  package: Tpackage;

implementation

uses MainForm;

{$R *.dfm}

procedure Tpackage.okClick(Sender: TObject);
begin
  Close;
end;

procedure Tpackage.zipEnd(Sender: TObject; FileName: String;
  CRC_PASS: Boolean);
begin
  listbox.Items.Add('Done adding files to package!');

  listbox.Cursor := crDefault;

  ok.Enabled := True;
end;

procedure Tpackage.FormCreate(Sender: TObject);
begin
  install := (ExtractFilePath(Application.ExeName) + 'Temp\');
end;

procedure Tpackage.FormShow(Sender: TObject);
begin
  // Clear the Listbox, in case a package has already been made in this session.
  listbox.Clear;

  // Show the save dialog and if the file exists, ask if it should be overwritten.
  if savedialog.Execute = true then begin
    if FileExists(savedialog.FileName) then
      if MessageDlg(
         'Extension Package exists... Overwrite?',
         mtConfirmation,
         [mbYes, mbNo],
         0) = mrYes Then
         DeleteFile(savedialog.FileName)
      else
        Exit;

    // Look busy!
    listbox.Cursor := crHourGlass;

    listbox.Items.Add('Creating install.rdf file...');
    main.rdf.XML.Clear;
    main.rdf.Active := True;
    main.MakeRDFv2;
    main.rdf.XML.SaveToFile(install + 'install.rdf');
    main.rdf.active := False;

    listbox.Items.Add('Done creating install.rdf!');

    listbox.Items.Add('Adding extension files to package');
    // Configure the root directory, archive name, clear specs and add package files.
    zip.RootDir := install;
    zip.ArchiveFile := savedialog.FileName;
    zip.ExcludeSpec.Clear();
    zip.FileSpec.Clear();
    zip.FileSpec.Add(install + '\*.*');
    zip.Compress();
  end
  else begin
    listbox.Items.Add('Packaging cancelled by user');
    ok.Enabled := True;
  end;
end;

end.

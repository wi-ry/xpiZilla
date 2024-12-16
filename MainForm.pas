{
  Extenzilla by Will Ryan - willryan@shaw.ca
  Website: http://willbert.unserious.com

  Program concept:
    To create a program that simplified the creation and updating of extension
    packages. Whether to make it easier to add the files needed for your
    extension and zip (or xpi?) them up into an extension package, or to simply
    update your existing extensions min and max version number compatability.
    My goal is to have Extenzilla simplify extension, period.

  Requirements:
    The Extenzilla source requires the following software/components to be
    compiled.
      Borland Delphi 7.0 (May be compatable with earlier versions)
      ZipTV VCL (http://www.ziptv.com).

  What needs to be done:
    * Open option to open existing .xpi packages and load the data into
      their associated fields in Extenzilla.
    * Miscellaneous code optimizations.

  Want to help?
    If you want to help me out with the program, great! All I ask is that if
    you find a better way to code something, you implement a feature, or you
    can help in some other way, PLEASE send me your fixed source code, along
    with your name, if you want to be mentioned in the about box credits (which
    I'm sure you do!)

    Email anything you think may help the project to willryan@shaw.ca
}

unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus, ComObj, ActiveX,
  ShellAPI, FileCtrl, Grids, ToolWin, ActnMan, ActnCtrls, ActnMenus,
  xmldom, XMLIntf, msxmldom, XMLDoc, oxmldom, ztvregister, ztvBase,
  ztvUnZip, SimpleXML;

type
  Tmain = class(TForm)
    opendialog: TOpenDialog;
    menu: TMainMenu;
    file_menu: TMenuItem;
    file_exit: TMenuItem;
    file_space_1: TMenuItem;
    file_save: TMenuItem;
    file_open: TMenuItem;
    file_new: TMenuItem;
    file_export: TMenuItem;
    file_space_2: TMenuItem;
    help_menu: TMenuItem;
    help_about: TMenuItem;
    savedialog: TSaveDialog;
    pages: TPageControl;
    files: TTabSheet;
    e_title: TLabel;
    e_note: TLabel;
    required: TTabSheet;
    r_target_applications: TLabel;
    r_title: TLabel;
    r_jar_button: TButton;
    r_firefox_min_checkbox: TCheckBox;
    r_firefox_max_checkbox: TCheckBox;
    r_guid_button: TButton;
    r_locale_checkbox: TCheckBox;
    r_skin_checkbox: TCheckBox;
    r_firefox_checkbox: TCheckBox;
    optional: TTabSheet;
    o_title: TLabel;
    o_description: TLabel;
    o_contributors: TLabel;
    o_contributors_memo: TMemo;
    o_description_memo: TMemo;
    advanced: TTabSheet;
    a_title: TLabel;
    a_sg: TStringGrid;
    a_more: TButton;
    a_fewer: TButton;
    a_cb: TCheckBox;
    o_creator: TLabeledEdit;
    o_homepage: TLabeledEdit;
    o_update: TLabeledEdit;
    o_options: TLabeledEdit;
    o_about: TLabeledEdit;
    o_icon: TLabeledEdit;
    r_extension: TLabeledEdit;
    r_jar: TLabeledEdit;
    r_guid: TLabeledEdit;
    r_version: TLabeledEdit;
    r_firefox_min: TLabeledEdit;
    r_firefox_max: TLabeledEdit;
    r_thunderbird_checkbox: TCheckBox;
    r_thunderbird_min: TLabeledEdit;
    r_thunderbird_min_checkbox: TCheckBox;
    r_thunderbird_max: TLabeledEdit;
    r_thunderbird_max_checkbox: TCheckBox;
    rdf: TXMLDocument;
    e_combobox: TComboBox;
    e_listbox: TFileListBox;
    e_add: TButton;
    e_remove: TButton;
    r_locale: TEdit;
    r_skin: TEdit;
    r_package: TLabeledEdit;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Memo1: TMemo;
    Label2: TLabel;
    unzip_xpi: TUnZip;
    procedure help_aboutClick(Sender: TObject);
    procedure r_guid_buttonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure file_newClick(Sender: TObject);
    procedure file_openClick(Sender: TObject);
    procedure file_exportClick(Sender: TObject);
    Procedure FileCopy( Const sourcefilename, targetfilename: String );
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure r_jar_buttonClick(Sender: TObject);
    procedure e_addClick(Sender: TObject);
    procedure e_removeClick(Sender: TObject);
    procedure file_exitClick(Sender: TObject);
    procedure a_cbClick(Sender: TObject);
    procedure r_firefox_checkboxClick(Sender: TObject);
    procedure r_thunderbird_checkboxClick(Sender: TObject);
    procedure a_fewerClick(Sender: TObject);
    procedure a_moreClick(Sender: TObject);
    procedure file_saveClick(Sender: TObject);
    procedure e_comboboxChange(Sender: TObject);
    procedure file_menuClick(Sender: TObject);
    procedure r_locale_checkboxClick(Sender: TObject);
    procedure r_skin_checkboxClick(Sender: TObject);
    procedure r_locale_editEnter(Sender: TObject);
    procedure r_packageEnter(Sender: TObject);
    procedure r_skinEnter(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
  private
  
  public
    procedure DeleteRecurse(src : String);
    procedure MakeRDFv2;
    procedure Reset;
    procedure ExportRDF;
    procedure ReadRDF;
  end;

var
  main: Tmain;
  install: String;

implementation

uses AboutForm, PackageForm;

{$R *.dfm}

procedure Tmain.FormCreate(Sender: TObject);
begin
  e_listbox.Clear;

  a_sg.Cols[0].Add('Extension GUID');
  a_sg.Cols[1].Add('Min Version');
  a_sg.Cols[2].Add('Max Version');

  pages.ActivePage := files;
  install := (ExtractFilePath(Application.ExeName) + 'Temp\');

  // If Temp directories exist, delete them. 
  try
    if DirectoryExists(install) then begin
      DeleteRecurse(install);
      DeleteRecurse(install + 'Defaults');
    end;
  finally
    if not DirectoryExists(install) then
      CreateDir(install);
      CreateDir(install + 'Components\');
      e_listbox.Directory := (install + 'Components\');
  end;
end;

procedure Tmain.DeleteRecurse(src : String);
var
  sts : Integer;
  SR: TSearchRec;
begin
  sts := FindFirst( src + '*.*' , faDirectory , SR );
  if sts = 0 then
  begin
    if ( SR.Name <> '.' ) and ( SR.Name <> '..' ) then
    begin
      if SR.Attr = faDirectory then
      begin
          DeleteRecurse( src + SR.Name + '\' );
          {$I-}RmDir( src + SR.Name );{$I+}
      end
      else
        DeleteFile( src + SR.Name );
    end;
    while FindNext( SR ) = 0 do
    if ( SR.Name <> '.' ) and ( SR.Name <> '..' ) then
    begin
      if SR.Attr = faDirectory then
      begin
        DeleteRecurse( src + SR.Name + '\' );
        {$I-}RmDir( src + SR.Name );{$I+}
      end
      else
        DeleteFile( src + SR.Name );
    end;
    FindClose( SR );
  end;
end;

function CreateGuid: string;
var
  ID: TGUID;
begin
  // A nifty little GUID generator!
  Result := '';
  if CoCreateGuid(ID) = S_OK then
    Result := GUIDToString(ID);
end;

Procedure Tmain.FileCopy( Const sourcefilename, targetfilename: String );
Var
  S, T: TFileStream;
Begin
  S := TFileStream.Create( sourcefilename, fmOpenRead );
  try
    T := TFileStream.Create( targetfilename,
                             fmOpenWrite or fmCreate );
    try
      T.CopyFrom(S, S.Size ) ;
    finally
      T.Free;
    end;
  finally
    S.Free;
  end;
End;

procedure Tmain.Reset;
var
  i: integer;
begin
  // Delete temporary files.
  DeleteRecurse(install + 'Defaults');
  DeleteRecurse(install);

  //e_notebook.ActivePage := 'components';
  e_combobox.ItemIndex := 0;
  CreateDir(install + 'Components\');
  e_listbox.Directory := (install + 'Components\');

  // Clear all required boxes
  r_extension.Clear;
  r_jar.Clear;
  r_guid.Clear;
  r_version.Clear;
  r_firefox_min.Clear;
  r_firefox_max.Clear;
  r_thunderbird_min.Clear;
  r_thunderbird_max.Clear;
  r_locale.Clear;
  r_package.Clear;
  r_skin.Clear;

  r_locale.Tag := 0;
  r_package.Tag := 0;
  r_skin.Tag := 0;

  // Set all required checkboxes to false;
  r_locale_checkbox.Checked := False;
  r_skin_checkbox.Checked := False;
  r_firefox_checkbox.Checked := False;
  r_firefox_min_checkbox.Checked := False;
  r_firefox_max_checkbox.Checked := False;
  r_thunderbird_checkbox.Checked := False;
  r_thunderbird_min_checkbox.Checked := False;
  r_thunderbird_max_checkbox.Checked := False;

  // Clear all optional information
  o_description_memo.Clear;
  o_creator.Clear;
  o_contributors_memo.Clear;
  o_homepage.Clear;
  o_update.Clear;
  o_options.Clear;
  o_about.Clear;
  o_icon.Clear;

  // Clear advanced.
  a_cb.Checked := False;
  a_sg.Enabled := False;

  i := 0;
  repeat begin a_sg.Rows[i].Clear; i := i + 1; end
  until i = a_sg.RowCount;
  a_sg.Cols[0].Clear;
  a_sg.Cols[1].Clear;
  a_sg.Cols[2].Clear;
  a_sg.RowCount := 2;
end;

procedure Tmain.MakeRDFv2;
var
  a,b,c: IXMLNode; // Main RDF nodes
  d,e: IXMLNode; // Target Apps nodes
  i: Integer; // For contributor nodes
  w,x,y,z: Integer;
  jar: string;
begin
  // RDF
  a := rdf.AddChild('RDF');
  a.DeclareNamespace('RDF', 'http://www.w3.org/1999/02/22-rdf-syntax=ns#');
  a.DeclareNamespace('em', 'http://www.mozilla.org/2004/em-rdf#');
  rdf.Version:= '1.0';

    // Description
    b := a.AddChild('Description', '');
      b.Attributes['about'] := 'urn:mozilla:install-manifest';

      //Description Child Nodes
      c := b.AddChild('em:id');
        c.Text := r_guid.Text;
      c := b.AddChild('em:version');
        c.Text := r_version.Text;

      // Target Application(s)

      // Extension for Firefox?
      if r_firefox_checkbox.Checked = true then begin
        c := b.AddChild('em:targetApplication');
        d := c;
          e := d.AddChild('Description', '');
            d := e.AddChild('em:id'); d.Text := '{ec8030f7-c20a-464f-9b0e-13a3a9e97384}';
            d := e.AddChild('em:minVersion');
                if r_firefox_min_checkbox.Checked = true then
              d.Text := r_firefox_min.Text + '+'
                else
              d.Text := r_firefox_min.Text;
            d := e.AddChild('em:maxVersion');
                if r_firefox_max_checkbox.Checked = true then
              d.Text := r_firefox_max.Text + '+'
                else
              d.Text := r_firefox_max.Text;
      end;

      // Is it for Thunderbird?
      if r_thunderbird_checkbox.Checked = true then begin
        c := b.AddChild('em:targetApplication');
        d := c;
          e := d.AddChild('Description', '');
            d := e.AddChild('em:id'); d.Text := '{3550f703-e582-4d05-9a08-453d09bdfdc6}';
            d := e.AddChild('em:minVersion');
                if r_thunderbird_min_checkbox.Checked = true then
              d.Text := r_thunderbird_min.Text + '+'
                else
            d.Text := r_thunderbird_min.Text;
              d := e.AddChild('em:maxVersion');
                if r_thunderbird_max_checkbox.Checked = true then
              d.Text := r_thunderbird_max.Text + '+'
                else
              d.Text := r_thunderbird_max.Text;
      end;

      // Front End Metadata
      c := b.AddChild('em:name');
        c.Text := r_extension.Text;

      if o_description_memo.Text > '' then begin
        c := b.AddChild('em:description');
          c.Text := o_description_memo.Text;
      end;

      if o_creator.Text > '' then begin
        c := b.AddChild('em:creator');
          c.Text := o_creator.Text;
      end;

      if o_contributors_memo.Lines.Count > 0 then begin
        i := 0;
        repeat begin
          c := b.AddChild('em:contributor');
            c.Text := o_contributors_memo.Lines.Strings[i];
          i := i + 1;
        end;
        until
          i = o_contributors_memo.Lines.Count;
      end;

      if o_homepage.Text > '' then begin
        c := b.AddChild('em:homepageURL');
          c.Text := o_homepage.Text;
      end;

      if o_update.Text > '' then begin
        c := b.AddChild('em:updateURL');
          c.Text := o_update.Text;
      end;

      // Front End Integration Hooks (used by Extension Manager)
      if o_options.Text > '' then begin
        c := b.AddChild('em:optionsURL');
          c.Text := o_options.Text;
      end;

      if o_about.Text > '' then begin
        c := b.AddChild('em:aboutURL');
          c.Text := o_about.Text;
      end;

      if o_icon.Text > '' then begin
        c := b.AddChild('em:iconURL');
          c.Text := o_icon.Text;
      end;

      jar := ChangeFileExt(ExtractFileName(r_jar.Text), '');
      // Packages, Skins and Locales that this extension registers
      c := b.AddChild('em:file');
        d := c;
        e := d.AddChild('Description', '');
        e.Attributes['about'] := 'urn:mozilla:extension:file:' + ExtractFileName(r_jar.Text);
          d := e.AddChild('em:package'); d.Text := r_package.Text;
          if r_locale_checkbox.Checked = true then begin
            d := e.AddChild('em:locale'); d.Text := r_locale.Text;
          end;
          if r_skin_checkbox.Checked = true then begin
            d := e.AddChild('em:skin'); d.Text := r_skin.Text;
          end;

      if a_cb.Checked = true then begin
        w := 1; x := 0; y := 1; z := 2;
        repeat begin
          c := b.AddChild('em:requires');
            d := c;
            e := d.AddChild('Description', '');
            if a_sg.Rows[w].Strings[x] > '' then begin
              d := e.AddChild('em:id');
              d.Text := a_sg.Rows[w].Strings[x];
            end;
            if a_sg.Rows[w].Strings[y] > '' then begin
              d := e.AddChild('em:minVersion');
              d.Text := a_sg.Rows[w].Strings[y];
            end;
            if a_sg.Rows[w].Strings[z] > '' then begin
              d := e.AddChild('em:maxVersion');
              d.Text := a_sg.Rows[w].Strings[z];
            end;
            w := w + 1;
          end;
        until
          w = a_sg.RowCount;
      end;
end;

procedure Tmain.ExportRDF;
begin
  if savedialog.Execute = True then begin
    try
      rdf.XML.Clear;
      rdf.Active := True;
      MakeRDFv2;

      rdf.XML.SaveToFile(savedialog.FileName);

      ShowMessage('install.rdf was successfully exported to ' + savedialog.FileName);
    finally
      rdf.active := False;
    end;
  end;
end;

procedure Tmain.ReadRDF;
var
  Node: TxmlNode;
  Parser: TxmlParser;
  FileName : String;
  blah: string;
begin
  FileName := ExpandFileName(install + 'install.rdf');
  Parser := TxmlParser.Create;
  Node := Parser.LoadFile(FileName);

  //r_extension.Text := Node['Description/em:name'].Value;
  //r_package.Text := Node['Description/em:file/Description/em:package'].Value;

end;

procedure Tmain.help_aboutClick(Sender: TObject);
begin
  // Shows the about box.
  aboutbox.ShowModal;
end;

procedure Tmain.e_removeClick(Sender: TObject);
begin
  with e_listbox do
    if DeleteFile(FileName) then Update;
end;

procedure Tmain.r_guid_buttonClick(Sender: TObject);
begin
  // GUID's are go!
  r_guid.Clear;
  r_guid.Text := CreateGuid;
  r_guid.SetFocus;
end;

procedure Tmain.file_newClick(Sender: TObject);
begin
  if MessageDlg(
    'Any unsaved changes will be lost if you continue.',
     mtWarning, [mbOK, mbCancel], 0) = mrOK then
       Reset
     else
       Exit;
end;

procedure Tmain.file_openClick(Sender: TObject);
begin
  // Yet to be coded...
  with opendialog do
    opendialog.Filter := 'Extension File (*.xpi)|*.xpi';
  if opendialog.Execute = True then
  begin
   unzip_xpi.ArchiveFile := opendialog.FileName;
   unzip_xpi.ExtractDir := install;
   if DirectoryExists(install) then
     unzip_xpi.Extract()
   else
   begin
     CreateDir(install);
     unzip_xpi.Extract();
   end;
     ReadRDF;
     e_listbox.Update;
  end;
end;

procedure Tmain.file_exportClick(Sender: TObject);
begin
  ExportRDF;
end;

procedure Tmain.r_jar_buttonClick(Sender: TObject);
var
  f: String;
begin
  with opendialog do begin
    opendialog.FileName := '*.jar';
    opendialog.Filter := 'JAR File (*.jar)|*.JAR|All Files (*.*)|*.*';
  end;
  if opendialog.Execute = True then begin
    if not DirectoryExists(install + 'chrome') then
      CreateDir(install + 'chrome');
    f := ExtractFileName(opendialog.FileName);
    DeleteRecurse(install + 'chrome');
    FileCopy(opendialog.FileName, install + 'chrome\' + f);
    r_jar.Text := opendialog.FileName;
  end;
end;

procedure Tmain.e_addClick(Sender: TObject);
var
  f: String;
begin
  with opendialog do
    opendialog.FileName := '*.*';
    opendialog.Filter := 'All Files (*.*)|*.*';
  if opendialog.Execute = True then begin

    f := ('\' + ExtractFileName(opendialog.FileName));

    FileCopy(opendialog.FileName, e_listbox.Directory + f);

    with e_listbox do Update;
    end;
end;

procedure Tmain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Delete temporary files.
  if MessageDlg(
    'Any unsaved changes will be lost if you continue.',
     mtWarning, [mbOK, mbCancel], 0) = mrOK then begin
       DeleteRecurse(install + 'Defaults');
       DeleteRecurse(install);
     end
     else
       Abort;
end;

procedure Tmain.file_exitClick(Sender: TObject);
begin
  Close;
end;

procedure Tmain.a_cbClick(Sender: TObject);
begin
  a_sg.Enabled := a_cb.Checked;
  a_more.Enabled := a_cb.Checked;
  a_fewer.Enabled := a_cb.Checked;
end;

procedure Tmain.r_firefox_checkboxClick(Sender: TObject);
begin
  r_firefox_min.Enabled          := r_firefox_checkbox.Checked;
  r_firefox_min_checkbox.Enabled := r_firefox_checkbox.Checked;
  r_firefox_max.Enabled          := r_firefox_checkbox.Checked;
  r_firefox_max_checkbox.Enabled := r_firefox_checkbox.Checked;
end;

procedure Tmain.r_thunderbird_checkboxClick(Sender: TObject);
begin
  r_thunderbird_min.Enabled          := r_thunderbird_checkbox.Checked;
  r_thunderbird_min_checkbox.Enabled := r_thunderbird_checkbox.Checked;
  r_thunderbird_max.Enabled          := r_thunderbird_checkbox.Checked;
  r_thunderbird_max_checkbox.Enabled := r_thunderbird_checkbox.Checked;
end;

procedure Tmain.a_fewerClick(Sender: TObject);
begin
  try
    a_sg.RowCount := (a_sg.RowCount - 1);
  finally
    if a_sg.RowCount <= 2 then a_fewer.Enabled := False;
  end;
end;

procedure Tmain.a_moreClick(Sender: TObject);
begin
  try
    a_sg.RowCount := (a_sg.RowCount + 1);
  finally
    if a_sg.RowCount >= 2 then a_fewer.Enabled := True;
  end;
end;

procedure Tmain.file_saveClick(Sender: TObject);
begin
  package.Show;
end;

procedure Tmain.e_comboboxChange(Sender: TObject);
begin
  with e_combobox do
    if ItemIndex = 0 then
    begin
      CreateDir(install + 'Components\');
      e_listbox.Directory := (install + 'Components\');
    end
    else if ItemIndex = 1 then
    begin
      CreateDir(install + 'Defaults\');
      e_listbox.Directory := (install + 'defaults\');
    end
    else if ItemIndex = 2 then begin
      CreateDir(install + 'Defaults\Preferences\');
      e_listbox.Directory := (install + 'defaults\preferences\')
    end;
end;

procedure Tmain.file_menuClick(Sender: TObject);
begin
  if (r_extension.Text <> '') and
    (r_jar.Text <> '') and
    (r_guid.Text <> '') and
    (r_version.Text <> '') and
    ((r_firefox_min.Text <> '') and (r_firefox_max.Text <> '')) or
    ((r_thunderbird_min.Text <> '') and (r_thunderbird_max.Text <> ''))
  then
  begin
    file_save.Enabled := True;
    file_export.Enabled := True;
  end
  else
  begin
    file_save.Enabled := False;
    file_export.Enabled := False;
  end;
end;

procedure Tmain.r_locale_checkboxClick(Sender: TObject);
begin
  r_locale.Enabled := r_locale_checkbox.Checked;
end;

procedure Tmain.r_skin_checkboxClick(Sender: TObject);
begin
  r_skin.Enabled := r_skin_checkbox.Checked;
end;

procedure Tmain.r_locale_editEnter(Sender: TObject);
begin
  if r_locale.Tag = 0 then
  begin
    r_locale.Text := ('locale/en-US/' +
                      ChangeFileExt(ExtractFileName(r_jar.Text), '') +
                      '/');
    r_locale.Tag := 1;
  end;
end;

procedure Tmain.r_packageEnter(Sender: TObject);

begin
  if r_package.Tag = 0 then
  begin
    r_package.Text := ('content/' +
                       ChangeFileExt(ExtractFileName(r_jar.Text), '') +
                       '/');
    r_package.Tag := 1;
  end;
end;

procedure Tmain.r_skinEnter(Sender: TObject);
begin
  if r_skin.Tag = 0 then
  begin
    r_skin.Text := ('skin/classic/' +
                    ChangeFileExt(ExtractFileName(r_jar.Text), '') +
                    '/');
    r_skin.Tag := 1;
  end;
end;

procedure Tmain.TabSheet1Show(Sender: TObject);
begin
  if (r_extension.Text <> '') and
    (r_jar.Text <> '') and
    (r_guid.Text <> '') and
    (r_version.Text <> '') and
    ((r_firefox_min.Text <> '') and (r_firefox_max.Text <> '')) or
    ((r_thunderbird_min.Text <> '') and (r_thunderbird_max.Text <> ''))
  then
  begin
    Label2.Font.Color := clGreen;
    Label2.Caption := 'Note: All required information has been entered!';
  end
  else
  begin
    Label2.Font.Color := clRed;
    Label2.Caption := 'Note: Not all required fields have been entered!';
  end;

  try
    rdf.XML.Clear;
    rdf.Active := True;
    MakeRDFv2;

    Memo1.Lines := rdf.XML;

  finally
    rdf.active := False;
  end;
end;

end.

unit AboutForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellAPI;

type
  Taboutbox = class(TForm)
    Panel2: TPanel;
    bevel: TBevel;
    ok: TButton;
    credits_button: TButton;
    notebook: TNotebook;
    created_by: TLabel;
    version: TLabel;
    sub_title: TLabel;
    title: TLabel;
    credits_memo: TMemo;
    credits_title: TLabel;
    Label1: TLabel;
    Image1: TImage;
    procedure credits_buttonClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  aboutbox: Taboutbox;

implementation

{$R *.dfm}

procedure Taboutbox.credits_buttonClick(Sender: TObject);
begin
  if notebook.ActivePage = 'About' then
    notebook.ActivePage := 'Credits'
  else
    notebook.ActivePage := 'About';
end;

procedure Taboutbox.Label1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
  'http://willbert.unserious.com', nil, nil, SW_SHOWNORMAL);
end;

procedure Taboutbox.FormCreate(Sender: TObject);
begin
  Image1.Picture.Icon := Application.Icon;
end;

end.

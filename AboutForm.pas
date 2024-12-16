unit AboutForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

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
    procedure credits_buttonClick(Sender: TObject);
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

end.

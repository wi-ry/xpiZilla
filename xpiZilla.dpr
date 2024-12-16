program xpiZilla;

uses
  Forms,
  MainForm in 'MainForm.pas' {main},
  AboutForm in 'AboutForm.pas' {aboutbox},
  PackageForm in 'PackageForm.pas' {package};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'xpiZilla';
  Application.CreateForm(Tmain, main);
  Application.CreateForm(Taboutbox, aboutbox);
  Application.CreateForm(Tpackage, package);
  Application.Run;
end.

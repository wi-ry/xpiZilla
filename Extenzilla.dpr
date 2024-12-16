program Extenzilla;

uses
  Forms,
  MainForm in 'MainForm.pas' {main},
  AboutForm in 'AboutForm.pas' {aboutbox},
  PackageForm in '..\Extenzilla 0.1\PackageForm.pas' {package};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Extenzilla';
  Application.CreateForm(Tmain, main);
  Application.CreateForm(Taboutbox, aboutbox);
  Application.CreateForm(Tpackage, package);
  Application.Run;
end.

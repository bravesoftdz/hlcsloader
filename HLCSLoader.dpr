program HLCSLoader;
{$R 'splash.res' 'splash.rc'}

uses
  Forms,
  uMain in 'uMain.pas' { wMain },
  UExtStarter in 'UExtStarter.pas';

{$R *.res}

begin
    Application.Initialize;
    Application.MainFormOnTaskbar := False;
    Application.Title := 'HL Loader';
  Application.CreateForm(TwMain, wMain);
    Application.Run;
end.

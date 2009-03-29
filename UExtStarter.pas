unit UExtStarter;

interface

uses
    Windows, Classes, Dialogs, ShellAPI, SysUtils, Forms;

const
    MYAC = 'myAC.exe';
    //HL = 'hl.exe';
    HL = 'revLoader.exe';
    DEFAULT_DELAY_TIME = 5000;
{$IFDEF CSLOADER}
    //CMDLINESTART = ' -game cstrike -steam +exec fplay.cfg';
    CMDLINESTART = ' -appid 10 -launch hl.exe -silent -game cstrike +exec fplay.cfg';
{$ELSE}
    //CMDLINESTART = ' -game valve -steam +exec fplay.cfg';
    CMDLINESTART = ' -appid 10 -launch hl.exe -silent -game valve +exec fplay.cfg';
{$ENDIF}

type
    TExtStarter = class(TThread)
    private
        DelayTime: Cardinal;

        function PrepareParams(): string;
        procedure DoStart;
        procedure ShutdownApplication;
    public
        constructor Create(CreateSuspended: Boolean);
    protected
        procedure Execute; override;
    end;

implementation

uses
    uMain;

{ TExtStarter }

constructor TExtStarter.Create(CreateSuspended: Boolean);
begin
    inherited Create(CreateSuspended);
    DelayTime := DEFAULT_DELAY_TIME;
end;

procedure TExtStarter.Execute;
begin
    DoStart;
    Synchronize(ShutdownApplication);
end;

procedure TExtStarter.ShutdownApplication;
begin
    Application.Terminate;
end;

function TExtStarter.PrepareParams(): string;
var
    i: integer;
    output: String;
begin
    output := CMDLINESTART;

    i := 1;
    while i <= ParamCount() do begin
        if (AnsiCompareStr(ParamStr(i), '--time') = 0) then begin
            try
                DelayTime := StrToInt(ParamStr(i+1));
            except
                ShowMessage('Delay time not recognized. You must use parameters like:' + #10#13 +
                            '--time 5000' + #10#13 +
                            'where 5000 - is delay in milliseconds.' + #10#13 +
                            'Will be used default time ' + UIntToStr(DelayTime) + ' ms.');
            end;

            i := i + 2;
        end else begin
            output := output + ' ' + ParamStr(i);
            inc(i);
        end;
    end;

    // for I := 1 to ParamCount() do
    // Out := Out + ' ' + ParamStr(I);
    //ShowMessage('params: ' + output);

    Result := output;
end;

procedure TExtStarter.DoStart;
var
    Params, Dir, ACRun, HLRun: PChar;
begin
    Params := PChar(PrepareParams());
    Dir := PChar(ExtractFilePath(ParamStr(0)));

    ACRun := PChar(Dir + MYAC);
    HLRun := PChar(Dir + HL);

    if (FileExists(Dir + MYAC)) then
        ShellExecute(wMain.Handle, 'open', ACRun, nil, Dir, SW_SHOW);

    Sleep(DelayTime);
    ShellExecute(wMain.Handle, 'open', HLRun, Params, Dir, SW_SHOW);
end;

end.

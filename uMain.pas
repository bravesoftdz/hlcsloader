unit uMain;

interface

uses
    Windows, Messages, Classes, Graphics, Forms, Types, SysUtils, XPMan, UExtStarter;

type
    TwMain = class(TForm)
    protected
        procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure ShowSplash;
    end;

var
    wMain: TwMain;
    ExtStarter: TExtStarter;

implementation

{$R *.dfm}

constructor TwMain.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    wMain.ShowSplash;

    ExtStarter := TExtStarter.Create(false);
end;

destructor TwMain.Destroy;
begin
    if (Assigned(ExtStarter)) then
        FreeAndNil(ExtStarter);

    inherited Destroy;
end;

procedure TwMain.ShowSplash;
var
    Stream: TStream;
    exStyle: Cardinal;
    Bitmap: TBitmap;
    BitmapPos: TPoint;
    BitmapSize: TSize;
    BlendFunction: TBlendFunction;
begin
    exStyle := GetWindowLongA(wMain.Handle, GWL_EXSTYLE);
    if (exStyle and WS_EX_LAYERED = 0) then
        SetWindowLong(wMain.Handle, GWL_EXSTYLE, exStyle or WS_EX_LAYERED);

    Bitmap := TBitmap.Create;
    try
        Stream := TResourceStream.Create(HInstance, 'SPLASH', RT_RCDATA);
        try
            Bitmap.LoadFromStream(Stream);

            wMain.ClientWidth := Bitmap.Width;
            wMain.ClientHeight := Bitmap.Height;

            BitmapPos := Point(0, 0);
            BitmapSize.cx := Bitmap.Width;
            BitmapSize.cy := Bitmap.Height;

            BlendFunction.BlendOp := AC_SRC_OVER;
            BlendFunction.BlendFlags := 0;
            BlendFunction.SourceConstantAlpha := 255;
            BlendFunction.AlphaFormat := AC_SRC_ALPHA;

            UpdateLayeredWindow(wMain.Handle, 0, nil, @BitmapSize, Bitmap.Canvas.Handle,
                @BitmapPos, 0, @BlendFunction, ULW_ALPHA);
        finally
            FreeAndNil(Stream);
        end;
    finally
        FreeAndNil(Bitmap);
    end;

    wMain.Show;
    wMain.Update;
end;

procedure TwMain.WMNCHitTest(var Message: TWMNCHitTest);
begin
    Message.Result := HTCAPTION;
end;

end.

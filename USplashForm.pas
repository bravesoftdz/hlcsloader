unit USplashForm;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs;

type
    TfrmSplash = class(TForm)
    private
        { Private declarations }
    protected
        procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    public
        constructor Create(AOwner: TComponent); override;
    end;

implementation

{$R *.dfm}

constructor TfrmSplash.Create;
var
    Stream: TStream;
    exStyle: Cardinal;
    Bitmap: TBitmap;
    BitmapPos: TPoint;
    BitmapSize: TSize;
    BlendFunction: TBlendFunction;
begin
    inherited Create(AOwner);

    exStyle := GetWindowLongA(Self.Handle, GWL_EXSTYLE);
    if (exStyle and WS_EX_LAYERED = 0) then
        SetWindowLong(Self.Handle, GWL_EXSTYLE, exStyle or WS_EX_LAYERED);

    Bitmap := TBitmap.Create;
    try
        Stream := TResourceStream.Create(HInstance, 'SPLASH', RT_RCDATA);
        try
            Bitmap.LoadFromStream(Stream);

            Self.ClientWidth := Bitmap.Width;
            Self.ClientHeight := Bitmap.Height;

            BitmapPos := Point(0, 0);
            BitmapSize.cx := Bitmap.Width;
            BitmapSize.cy := Bitmap.Height;

            BlendFunction.BlendOp := AC_SRC_OVER;
            BlendFunction.BlendFlags := 0;
            BlendFunction.SourceConstantAlpha := 255;
            BlendFunction.AlphaFormat := AC_SRC_ALPHA;

            UpdateLayeredWindow(Self.Handle, 0, nil, @BitmapSize, Bitmap.Canvas.Handle,
                @BitmapPos, 0, @BlendFunction, ULW_ALPHA);
        finally
            FreeAndNil(Stream);
        end;
    finally
        FreeAndNil(Bitmap);
    end;

    Self.Show;
    Self.Update;
end;

procedure TfrmSplash.WMNCHitTest(var Message: TWMNCHitTest);
begin
  Message.Result := HTCAPTION;
end;

end.

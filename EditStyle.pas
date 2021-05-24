unit EditStyle;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, System.UITypes;

type
  TEditStyle = class(TEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }

  published
    { Published declarations }
  end;

procedure Register;

implementation

uses
  Forms, Graphics;

procedure Register;
begin
  RegisterComponents('Jovio', [TEditStyle]);
end;

{ TEditStyle }

constructor TEditStyle.Create(AOwner: TComponent);
begin
  inherited;
  BevelInner := bvLowered;
  BevelKind := bkFlat;
  BevelOuter := bvRaised;
  BorderStyle := bsNone;
  Font.Color := clBlue;
  Font.Style := Font.Style + [fsBold];
  CharCase := ecUpperCase;
end;

end.

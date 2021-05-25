unit EditNumber;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls;

type
  TNumberEdit = class(TEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure KeyPress(var Key: Char); override;
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Jovio', [TNumberEdit]);
end;

{ TNumberEdit }

procedure TNumberEdit.KeyPress(var Key: Char);
begin

  if not CharInSet(Key, [#48..#57, #13, #27, #9, #8]) then
    raise Exception.Create('Caractere Inválido');
  inherited;
end;

end.

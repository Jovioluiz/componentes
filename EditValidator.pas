unit EditValidator;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, EditNumber, System.StrUtils;

type
  TEditType = (etCNPJ, etCPF, etCEP, etTelefone, etTitulo);

  EInvalidCPF = class(Exception)
    constructor Create;
  end;

  EInvalidCNPJ = class(Exception)
    constructor Create;
  end;

  EInvalidCEP = class(Exception)
    constructor Create;
  end;

  TEditValidator = class(TNumberEdit)
  private
    FEditType: TEditType;
    FInputMask: Boolean;
    FValidate: Boolean;
    procedure SetEditType(const Value: TEditType);
    procedure SetInputMask(const Value: Boolean);
    procedure SetValidate(const Value: Boolean);
    { Private declarations }
  protected
    { Protected declarations }
    function DoValidate: Boolean; virtual;
    function ValidateCNPJ: Boolean; virtual;
    function ValidateCPF: Boolean; virtual;
    function ValidateCEP: Boolean; virtual;
    procedure Mascarar; virtual;
    procedure DoExit; override;
  public
    { Public declarations }
  published
    { Published declarations }
    property EditType: TEditType read FEditType write SetEditType default etCNPJ;
    property InputMask: Boolean read FInputMask write SetInputMask;
    property Validate: Boolean read FValidate write SetValidate;
  end;

procedure Register;

//aula 28

implementation
uses
  System.MaskUtils;

const
  mskCNPJ = '##.###.#00/0000-00;0;_';
  mskCPF = '###.##0.000-00;0;_';
  mskCEP = '00000-000;0;_';
  mskTelefone = '(##) 00000-0000;0;_';
  mskTitulo = '###.##0.00.00;0;_';


procedure Register;
begin
  RegisterComponents('Jovio', [TEditValidator]);
end;

{ TEditValidator }

procedure TEditValidator.Mascarar;
var
  str: string;
begin
  str := Text;

  if FEditType = etCNPJ then
  begin
    {deleta os pontos e traço, senão a mascara fica com pontos e traços a mais
    toda vez que altera algum digito}
    Delete(str, AnsiPos('.', str), 1);
    Delete(str, AnsiPos('.', str), 1);
    Delete(str, AnsiPos('/', str), 1);
    Delete(str, AnsiPos('-', str), 1);
  end;

  if FEditType = etCPF then
  begin
    {deleta os pontos, traço e barra, senão a mascara fica com pontos e traços a mais
    toda vez que altera algum digito}
    Delete(str, AnsiPos('.', str), 1);
    Delete(str, AnsiPos('.', str), 1);
    Delete(str, AnsiPos('-', str), 1);
  end;

  case FEditType of
    etCNPJ: Text := FormatMaskText(mskCNPJ, str);
    etCPF: Text := FormatMaskText(mskCPF, str);
    etCEP: Text := FormatMaskText(mskCEP, str);
    etTelefone: Text := FormatMaskText(mskTelefone, str);
    etTitulo: Text := FormatMaskText(mskTitulo, str);
  end;
end;

procedure TEditValidator.SetEditType(const Value: TEditType);
begin
  FEditType := Value;
end;

procedure TEditValidator.SetInputMask(const Value: Boolean);
begin
  FInputMask := Value;
end;

procedure TEditValidator.SetValidate(const Value: Boolean);
begin
  FValidate := Value;
end;

procedure TEditValidator.DoExit;
begin
  if Validate then
    if not DoValidate then
    begin
      case EditType of
        etCNPJ: raise EInvalidCNPJ.Create;
        etCPF: raise EInvalidCPF.Create;
        etCEP: raise EInvalidCEP.Create;
      end;
    end;
  if InputMask then
    Mascarar;
  inherited;
end;

function TEditValidator.DoValidate: Boolean;
begin
  Result := False;

  case FEditType of
    etCNPJ: Result := ValidateCNPJ;
    etCPF: Result := ValidateCPF;
    etCEP: Result := ValidateCEP;
  end;
end;

function TEditValidator.ValidateCEP: Boolean;
var
  str: string;
begin
  Result := True;

  str := Text;

  Delete(str, AnsiPos('-', str), 1);

  if Length(str) <> 8 then
    Result := False;
end;

function TEditValidator.ValidateCNPJ: Boolean;
var
  cnpj: string;
  dg1,
  dg2,
  x,
  total: Integer;
  ret: boolean;
begin
  ret := False;
  cnpj := '';

  //Analisa os formatos
  if Length(Text) = 18 then
    if (Copy(Text, 3, 1) + Copy(Text, 7, 1) + Copy(Text, 11, 1) + Copy(Text, 16, 1) = '../-') then
    begin
      cnpj := Copy(Text, 1, 2) + Copy(Text, 4, 3) + Copy(Text, 8, 3) + Copy(Text, 12, 4) + Copy(Text, 17, 2);
      ret := True;
    end;

  if Length(Text) = 14 then
  begin
    cnpj := Text;
    ret := True;
  end;

  //Verifica
  if ret then
  begin
    try
      //1° digito
      total := 0;
      for x := 1 to 12 do
      begin
        if x < 5 then
          Inc(total, StrToInt(Copy(cnpj, x, 1)) * (6 - x))
        else
          Inc(total, StrToInt(Copy(cnpj, x, 1)) * (14 - x));
      end;

      dg1 := 11 - (total mod 11);

      if dg1 > 9 then
        dg1 := 0;

      //2° digito
      total := 0;

      for x := 1 to 13 do
      begin
        if x < 6 then
          Inc(total, StrToInt(Copy(cnpj, x, 1)) * (7 - x))
        else
          Inc(total, StrToInt(Copy(cnpj, x, 1)) * (15 - x));
      end;

      dg2 := 11 - (total mod 11);

      if dg2 > 9 then
        dg2:=0;

      //Validação final
      if (dg1 = StrToInt(Copy(cnpj, 13, 1))) and (dg2 = StrToInt(Copy(cnpj, 14, 1))) then
        ret := True
      else
        ret := False;
    except
      ret := False;
    end;

    //Inválidos

    case AnsiIndexStr(cnpj, ['00000000000000',
                             '11111111111111',
                             '22222222222222',
                             '33333333333333',
                             '44444444444444',
                             '55555555555555',
                             '66666666666666',
                             '77777777777777',
                             '88888888888888',
                             '99999999999999']) of

          0..9: ret := False;
    end;
  end;

  Result := ret;
end;

function TEditValidator.ValidateCPF: Boolean;
var
  cpf: string;
  x,
  total,
  dg1,
  dg2: Integer;
  ret: boolean;
begin
  ret := True;

  for x := 1 to Length(Text) do
    if not (CharInSet(Text[x], ['0'..'9', '-', '.', ' '])) then
      ret := False;

  if ret then
  begin
    ret := True;
    cpf := '';
    for x := 1 to Length(Text) do
      if CharInSet(Text[x], ['0'..'9']) then
        cpf := cpf + Text[x];

    if Length(cpf) <> 11 then
      ret := False;

    if ret then
    begin
      total := 0;

      for x := 1 to 9 do
        total := total + (StrToInt(cpf[x]) * x);

      dg1 := total mod 11;

      if dg1 = 10 then
        dg1 := 0;

      total := 0;

      for x := 1 to 8 do
        total := total + (StrToInt(cpf[x + 1]) * (x));

      total := total + (dg1 * 9);
      dg2 := total mod 11;

      if dg2 = 10 then
        dg2 := 0;

      if dg1 = StrToInt(cpf[10]) then
        if dg2 = StrToInt(cpf[11]) then
          ret := True;

      case AnsiIndexStr(cpf,['00000000000',
                             '11111111111',
                             '22222222222',
                             '33333333333',
                             '44444444444',
                             '55555555555',
                             '66666666666',
                             '77777777777',
                             '88888888888',
                             '99999999999']) of
        0..9: ret := False;
      end;
    end
    else
    begin
      if cpf = '' then
        ret := True;
    end;
  end;
  Result := ret;
end;

{ TInvalidCPF }

constructor EInvalidCPF.Create;
begin
  Self.Message := 'Número de CPF inválido!';
end;

{ EInvalidCNPJ }

constructor EInvalidCNPJ.Create;
begin
  Self.Message := 'Número de CNPJ inválido!';
end;

{ EInvalidCEP }

constructor EInvalidCEP.Create;
begin
  Self.Message := 'CEP inválido!';
end;

end.

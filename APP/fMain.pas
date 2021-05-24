unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, EditStyle, System.Sensors,
  System.Sensors.Components, Vcl.WinXCtrls, EditNumber, EditValidator,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    edit: TEditValidator;
    RadioGroup1: TRadioGroup;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  edit.Validate := CheckBox1.Checked;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  edit.InputMask := CheckBox2.Checked;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  edit.EditType := TEditType(RadioGroup1.ItemIndex);
end;

end.

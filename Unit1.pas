unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, BarCode;

type
  TForm1 = class(TForm)
    EditCode: TEdit;
    ComboBox1: TComboBox;
    BarCode1: TBarCode;
    Label1: TLabel;
    Label2: TLabel;
    procedure ComboBox1Change(Sender: TObject);
    procedure EditCodeChange(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
BarCode1.BarCodeType := TBarCodeType(combobox1.ItemIndex);
EditCode.Text := BarCode1.Code;
end;

procedure TForm1.EditCodeChange(Sender: TObject);
var Savepos,L:integer;
begin
SavePos := EditCode.SelStart;
L := length(EditCode.text);
if (L<12) and (BarCode1.BarCodeType=EAN13) then exit;
if (L<8) and (BarCode1.BarCodeType=EAN8) then exit;

BarCode1.Code := EditCode.Text;
EditCode.Text := BarCode1.Code;
EditCode.SelStart := SavePos;
end;

end.

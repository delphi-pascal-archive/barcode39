unit BarCode;

{
composant codebarre 39 EAN8 EAN13, redimensionnable
propriété BarCodeType : type du code barre
propriété BarWidth:largeur des barres de base
propriété BarWidthXL :largeur des barres larges
propriété Code : le code barre à afficher

damien varrel
}

interface

uses
  SysUtils, Classes, Controls, Graphics, StrUtils;

type
  TElt=(A,B,AB,C,GN,GC); //l'élément C est le négatif de A , B est le complément de C
  TBarCodeType = (EAN8,EAN13,C39);
  TBarCode = class(TGraphicControl)
  private
    { Déclarations privées }
    FBarCodeType:TBarCodeType;
    FSeqEAN : array of Telt;
    FCode : string;
    FBarWidth: integer;
    FBarWidthXL: integer;
    FOnPaint: TNotifyEvent;
  protected
    { Déclarations protégées }
    procedure Paint; override;
    procedure TraceBarCode;
    procedure SetCode(ACode:string);
    procedure SetBarWidth(ABarWidth:integer);
    procedure SetBarWidthXL(ABarWidthXL:integer);
    procedure SetBarCodeType(ABarCodeType:TBarCodeType);
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override;
    property Canvas;
  published
    { Déclarations publiées }
    property Align;
    property Anchors;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property BarCodeType:TBarCodeType read FBarCodeType write SetBarCodeType default C39;
    property Code: string read FCode write SetCode;
    property BarWidth: integer read FBarWidth write SetBarWidth default 2;
    property BarWidthXL: integer read FBarWidthXL write SetBarWidthXL default 4;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property OnStartDock;
    property OnStartDrag;
    Function FCodeEAN13(ACode:string):string;
  end;

type Tcode39 =record
 C : char;
 B : array[0..8]of byte;
 end;
const
 C39AuthorizedChars='0123456789ABCDEFGHIJKLMEOPQRSTUVLXYZ-. *$/+%';
 C39BS : array[0..43,0..8] of Byte =
((0,0,0,1,1,0,1,0,0),	  //	Pour	le	caractère	'0'
(1,0,0,1,0,0,0,0,1),		//	Pour	le	caractère	'1'
(0,0,1,1,0,0,0,0,1),		//	2			
(1,0,1,1,0,0,0,0,0),		//	3			
(0,0,0,1,1,0,0,0,1),		//	4			
(1,0,0,1,1,0,0,0,0),		//	5			
(0,0,1,1,1,0,0,0,0),		//	6			
(0,0,0,1,0,0,1,0,1),		//	7			
(1,0,0,1,0,0,1,0,0),		//	8			
(0,0,1,1,0,0,1,0,0),		//	9			
(1,0,0,0,0,1,0,0,1),		//	A			
(0,0,1,0,0,1,0,0,1),		//	B			
(1,0,1,0,0,1,0,0,0),		//	C			
(0,0,0,0,1,1,0,0,1),		//	D			
(1,0,0,0,1,1,0,0,0),		//	E			
(0,0,1,0,1,1,0,0,0),		//	F			
(0,0,0,0,0,1,1,0,1),		//	G			
(1,0,0,0,0,1,1,0,0),		//	H			
(0,0,1,0,0,1,1,0,0),		//	I			
(0,0,0,0,1,1,1,0,0),		//	J			
(1,0,0,0,0,0,0,1,1),		//	K			
(0,0,1,0,0,0,0,1,1),		//	L			
(1,0,1,0,0,0,0,1,0),		//	M			
(0,0,0,0,1,0,0,1,1),		//	N			
(1,0,0,0,1,0,0,1,0),		//	O			
(0,0,1,0,1,0,0,1,0),		//	P			
(0,0,0,0,0,0,1,1,1),		//	Q			
(1,0,0,0,0,0,1,1,0),		//	R			
(0,0,1,0,0,0,1,1,0),		//	S			
(0,0,0,0,1,0,1,1,0),		//	T			
(1,1,0,0,0,0,0,0,1),		//	U
(0,1,1,0,0,0,0,0,1),		//	V
(1,1,1,0,0,0,0,0,0),		//	L
(0,1,0,0,1,0,0,0,1),		//	X
(1,1,0,0,1,0,0,0,0),		//	Y
(0,1,1,0,1,0,0,0,0),		//	Z
(0,1,0,0,0,0,1,0,1),		//	-
(1,1,0,0,0,0,1,0,0),		//	.
(0,1,1,0,0,0,1,0,0),		//
(0,1,0,0,1,0,1,0,0),		//	*
(0,1,0,1,0,1,0,0,0),		//	$
(0,1,0,1,0,0,0,1,0),		//	/
(0,1,0,0,0,1,0,1,0),		//	+
(0,0,0,1,0,1,0,1,0));		//	%
{
La table ci-dessus représente, la composition Barre (B), Espace (S) de chaque caractère en Code 39.
Le (1) indique un élément large et le (0) un élément étroit :
B S B S B S B S B
}

SeqEAN13 : array [0..14] of Telt = (GN,A,AB,AB,AB,AB,AB,GC,C,C,C,C,C,C,GN);
SeqEAN8 : array  [0..10] of Telt = (GN,A,A,A,A,GC,C,C,C,C,GN);

  //codes chiffres (ordre SBSB  Barres ou Espace)
CEAN13A :array [0..9,0..3] of byte =
((3,2,1,1),(2,2,2,1),(2,1,2,2),(1,4,1,1),(1,1,3,2),
(1,2,3,1),(1,1,1,4),(1,3,1,2),(1,2,1,3), (3,1,1,2));
CEANGN : array [0..2] of byte = (1,0,1);   //zone de garde normale GN
CEANGC : array [0..4] of byte = (0,1,0,1,0); //zone de garde centrale GC
// Séquence 3-7ème chiffre
EANSeq37 : array [0..9,0..4] of Telt =
((A,A,A,A,A),(A,B,A,B,B),(A,B,B,A,B),(A,B,B,B,A),(B,A,A,B,B),
(B,B,A,A,B),(B,B,B,A,A),(B,A,B,A,B),(B,A,B,B,A),(B,B,A,B,A));

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Exemples', [TBarCode]);
end;

constructor TBarCode.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 105;
  Height := 60;
  Font.Style := [fsBold];
  FBarWidthXL := 4;
  FBarWidth := 2;
  SetBarCodeType(C39);
end;

Function TBarCode.FCodeEAN13(ACode:string):string;
var i,m,n:integer;
s:string;
begin
m:=0;n:=0;
for i:=1 to 12 do
 begin
  if odd(i) then n := n + strtoint(ACode[i])
   else m := m + strtoint(ACode[i]);
 end;
i := m*3 + n;
s := inttostr(i);
result := leftstr(ACode,12) + inttostr(10-strtoint(s[length(s)])) ;
end;

procedure TBarCode.SetCode(ACode:string);
var i:integer;
test:Int64;
begin

case FBarCodeType of

C39:
 begin
  if length(ACode)=0 then Acode := '**'
  else
   begin
    Acode := UpperCase(Acode);
    for i:=1 to length(Acode) do
     if pos(Acode[i],C39AuthorizedChars)=0 then Acode[i] := '-';
    if Acode[1]<>'*' then Acode:='*'+Acode;
    if Acode[length(Acode)]<>'*' then Acode:=Acode+'*';
   end;
 end;

EAN8:
 begin
  if length(ACode)<8 then exit;
  test:=strtoint64def(leftstr(ACode,8),32901234);
  Acode := inttostr(test);
 end;

EAN13:
 begin
  if length(ACode)<12 then exit;
  test:=strtoint64def(leftstr(ACode,12),329012345678);
  Acode := FCodeEAN13(inttostr(test));
 end;

end;

FCode := Acode;
Invalidate;
end;

procedure TBarCode.SetBarCodeType(ABarCodeType:TBarCodeType);
var i:integer;
s:string;
begin
FBarCodeType := ABarCodeType;

case FBarCodeType of
 EAN8:
  begin
   Setlength(FSeqEAN,Length(SeqEAN8));
   Move(SeqEAN8[0], FSeqEAN[0], sizeof(SeqEAN8));
   s := '32906786';
  end;
 EAN13:
  begin
   s := FCodeEAN13('3290123456786');
   Setlength(FSeqEAN,Length(SeqEAN13));
   Move(SeqEAN13[0], FSeqEAN[0], sizeof(SeqEAN13));
   i := strtoint(s[1]); //trouve la séquence 3-7ème numéro
   Move(EANSeq37[i,0], FSeqEAN[2], sizeof(EANSeq37[i]));
  end;
 C39: s := 'BARCODE39';
end;

SetCode(s);
end;


procedure TBarCode.SetBarWidth(ABarWidth:integer);
begin
if AbarWidth>0 then FBarWidth := AbarWidth
else FBarWidth := 2;
Invalidate;
end;

procedure TBarCode.SetBarWidthXL(ABarWidthXL:integer);
begin
if AbarWidthXL>0 then FBarWidthXL := AbarWidthXL
else FBarWidthXL := 4;
Invalidate;
end;

procedure TBarCode.TraceBarCode;
begin

end;

procedure TBarCode.Paint;
var i,j,X1,X2,H1,H2,OffsetEAN13,Index:integer;
bmp1:tbitmap;
SCode:string;

procedure TraceBar(const H:integer);
begin
  bmp1.Canvas.Rectangle(X1,0,X2,H);
end;

procedure TraceText(const Text:String);
begin
  bmp1.Canvas.Brush.Color := Color;
  bmp1.Canvas.TextOut(X1+2,H1+1,Text);
  bmp1.Canvas.Brush.Color := clblack;
end;

procedure TraceCode39(index:byte);
var i:integer;
begin
for i:=0 to 8 do
 begin
   if C39BS[index,i] = 0 then X2 := X1 + FBarWidth
    else X2 := X1 + FBarWidthXL ;
   if not odd(i) then
    if index=39 then TraceBar(H2)
     else TraceBar(H1);
   if (i=3) and (index<>39) then
    TraceText(C39AuthorizedChars[index+1]);
   X1:=X2;
 end;
end;



begin
if length(FCode)=0 then exit;
bmp1 := Tbitmap.Create;
try
bmp1.Height := Height;
bmp1.Canvas.Font := Font;

//Prepa Code
 if FBarCodeType=C39 then
   bmp1.Width := length(Fcode) * ((6*FBarWidth)+(3*FBarWidthXL))
 else
 if FBarCodeType=EAN8 then
 begin
  Scode := '0'+leftstr(FCode,4) + ' ' + rightstr(FCode,4);
  bmp1.Width := ((8*7 + (3*2) + 5) * FBarWidth );
 end else
 if FBarCodeType=EAN13 then
 begin
  OffsetEAN13 := bmp1.Canvas.TextWidth('0') + 4 ;
  Scode := leftstr(FCode,7) + ' ' + rightstr(FCode,6);
  bmp1.Width := OffsetEAN13 + ((12*7 + (3*2) + 5) * FBarWidth );
 end;

//effacement du codebarre
bmp1.Canvas.Brush.Color := Color;
bmp1.Canvas.Pen.Color := Color;
bmp1.Canvas.Rectangle(0,0,bmp1.Width,bmp1.Height);
bmp1.Canvas.Brush.Color := clblack;
bmp1.Canvas.Pen.Color := clblack;

X1:=0;
H1 := bmp1.Height- (bmp1.Canvas.TextHeight('0'));
H2 := bmp1.Height- (bmp1.canvas.TextHeight('0') div 3);

//Code 39
if FBarCodeType=C39 then
 begin
  for i:=1 to length(Fcode) do
  //cherche l'index du caractère et trace le code
  TraceCode39(Pos(FCode[i],C39AuthorizedChars)-1);
 end else
 begin
//Code EAN
 for i:=0 to length(FSeqEAN)-1 do
 begin
    if (i=0) OR (i=length(FSeqEAN)-1) then
   begin
     if (i=0) AND (FBarCodeType=EAN13) then
      begin
      TraceText(SCode[i+1]);
      X1:= OffsetEAN13 ;
      end;
     for j:=0 to length(CEANGN)-1 do
       begin
       X2 := X1 + FBarWidth;
       if CEANGN[j]=1 then TraceBar(H2);
       X1 := X2;
       end;
   end else
  if ((i=7) and (FBarCodeType=EAN13)) OR ((i=5) and (FBarCodeType=EAN8)) then
    begin
      for j:=0 to length(CEANGC)-1 do
       begin
       X2 := X1 + FBarWidth;
       if CEANGC[j]=1 then TraceBar(H2);
       X1 := X2;
      end;
    end else
   begin
    //cherche l'index du caractère
    Index := strtoint(SCode[i+1]);
    // C négatif de A , B symétrique de C
    for j:=0 to 3 do
     begin
      if FSeqEAN[i]=B then X2 := X1 + (FBarWidth*CEAN13A[Index,3-j])
      else X2 := X1 + (FBarWidth*CEAN13A[Index,j]);

      if ( odd(j) AND((FSeqEAN[i]=A)OR(FSeqEAN[i]=B)))
      OR ( not odd(j) AND (FSeqEAN[i]=C))
      then
       TraceBar(H1);
      if j=0 then TraceText(SCode[i+1]);
      X1 := X2;
     end;
   end;
  end;

 end;


Width := bmp1.Width;
canvas.Draw(0,0,bmp1);
finally
bmp1.Free;
end;

if Assigned(FOnPaint) then FOnPaint(Self);

end;

end.

unit frmalarm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Crt, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, alarme, dateutils;

type

  { TfrmAlarme }

  TfrmAlarme = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  public
    constructor Create(TheOwner : TComponent; aEvent: PEvento; aEventDone: TEventDone); reintroduce;
    destructor Destroy; override;
  private
    FEvent: PEvento;
    FEventDone: TEventDone;
    procedure ExecTimer(Sender : TObject);
  public
    { public declarations }
  published

  end;

var
  frmAlarme : TfrmAlarme;

implementation

{$R *.lfm}

procedure TfrmAlarme.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAlarme.BitBtn1Click(Sender: TObject);
var
  DataHora : TDateTime;
  timeSel  : String;
begin
  timeSel                 := Copy(Combobox1.text,1,Pos(' ',Combobox1.text) -1);
  DataHora                := Now;
  DataHora                := IncMinute(DataHora,StrToInt(timeSel)) ;
  FEvent^.DataHEvento     := DataHora;
  FEvent^.Ativado         := True;
  BitBtn2.Click;
end;

procedure TfrmAlarme.FormActivate(Sender: TObject);
begin
  OnActivate := nil;
  with TTimer.Create(Self) do
      begin
        OnTimer  := @ExecTimer;
        Interval := 1;
        Enabled  := True;
      end;
end;


procedure _MoveAnimation(aFrm: TCustomForm; leftfrom: Integer; leftto: Integer;  topfrom: Integer; topto: Integer);
var
  i: Integer;
  step: Integer=1;
  moveareax, moveareay: integer;

begin
  i := 1;
  moveareax := leftto - leftfrom;
  moveareay := topto - topfrom;
  while i <= 100 do
  begin
        aFrm.Left := round(leftfrom + (moveareax * i / 100));
        aFrm.Top := round(topfrom + (moveareay * i / 100));
        Sleep(10);
        aFrm.AlphaBlendValue := aFrm.AlphaBlendValue - 2;
        application.ProcessMessages;
        if i >= 100 then
          Exit;
        Inc(i, step);
        if (100 - i) < step then
          i := 100;
  end;
end;


procedure TfrmAlarme.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  _MoveAnimation(Self,left,left - Width,top,top);
  CloseAction := caFree;
end;

procedure TfrmAlarme.FormCreate(Sender: TObject);
var
  i,tp : Integer;
begin
  tp   := 0;
  Self.left := Screen.Width - Self.Width;
  for i := 0 to Screen.FormCount -1 do
     begin
        if  screen.Forms[i] is TfrmAlarme then
            tp := tp + screen.Forms[i].Height + 23;
     end;
  top := tp - Height;
end;

constructor TfrmAlarme.Create(TheOwner : TComponent; aEvent : PEvento; aEventDone : TEventDone);
begin
  inherited Create(TheOwner);
  FEvent     := aEvent;
  FEventDone := aEventDone;
end;

destructor TfrmAlarme.Destroy;
begin
  if Assigned(FEventDone) then
    FEventDone(FEvent);
  inherited Destroy;
end;

procedure TfrmAlarme.ExecTimer(Sender : TObject);
begin
  if Self.AlphaBlendValue >= 255 then
  begin
    Sender.Free;
    bitbtn1.enabled := True;
    bitbtn2.enabled := True;
    Exit;
  end;
  Self.AlphaBlendValue := Self.AlphaBlendValue + 1;
  Self.update;
end;


end.


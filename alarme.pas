unit alarme;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dateutils,ExtCtrls,Controls,Graphics, Dialogs,CustomTimer,Forms,LResources;

Type

  { TAbout }

  TAbout = class(TPersistent)
  private
    FContato: String;
    FData: String;
    fDesenvolvedor: String;
    FLicensa: String;
    FVersao: String;
  public
      procedure Assign(Source: TPersistent); override;
      constructor Create;
  published
    property Desenvolvedor : String read fDesenvolvedor;
    property Contato       : String read FContato;
    property Data          : String read FData;
    property Versao        : String read FVersao;
    property Licensa       : String read FLicensa;
  end;

  TEvento = Object
      Evento      : String;
      DataHEvento : TDateTime;
      idxImg      : Integer;
      Ativado     : Boolean;
      idx         : Integer;
  end;

  PEvento = ^TEvento;
  TEventDone = procedure (aEvent: PEvento) of object;


  { TAlarme }

  TAlarme = Class (TComponent)
  private
    FSobre     : TAbout;
    FTempo     : TTimer;
    FimageList : TImageList;
    FList      : TList;
    procedure DoEventDone(aEvent : PEvento);
    procedure SetimageList(AValue: TImageList);
    procedure Timer(Sender: TObject);
  Public
      //constructor Create;
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;
      procedure AdicionarEvento(const aEvent: String; const aDateTime: TDateTime;
        idxImage: SmallInt; Idx: Integer);
      procedure Ativar;
      procedure Desativar;
      function listaEventos : TList;
  published
      property imageList : TImageList read FimageList write SetimageList;
      property Sobre : TAbout read FSobre;
  end;


  procedure Register;

implementation
     uses frmalarm;

procedure Register;
begin
  {$i alarme.lrs}
  RegisterComponents('Humberto', [TAlarme]);
end;

{ TAbout }

procedure TAbout.Assign(Source: TPersistent);
begin
  inherited;
  if (Source is TAbout) then
  begin
    fDesenvolvedor := TAbout(Source).Desenvolvedor;
    fContato       := TAbout(Source).Contato;
    fData          := TAbout(Source).Data;
    fVersao        := TAbout(Source).fVersao;
    Exit;
  end;
  inherited Assign(Source);
end;

constructor TAbout.Create;
begin
  FDesenvolvedor := 'Humberto Sales de Oliveira';
  FContato       := '+55 (34) 99973-1581';
  FData          := '05/08/2017';
  FVersao        := '1.0';
  FLicensa       := 'Use e abuse';
end;

{ TAbout }


procedure TAlarme.Ativar;
begin
  With FTempo do
      begin
         if Enabled then
            Exit;
         OnTimer := @Timer;
         Enabled := True;
      end;
end;

procedure TAlarme.Desativar;
var
  i : Integer;
begin
    With FTempo do
        begin
          Enabled := False;
          OnTimer := Nil;
        end;
    for i := 0 to Screen.FormCount - 1 do
         begin
            if  screen.Forms[i] is TfrmAlarme then
                Screen.Forms[i].Close;
         end;
end;

function TAlarme.listaEventos: TList;
begin
  Result := FList;
end;

procedure TAlarme.Timer(Sender: TObject);
var
  vEvent   : PEvento;
  i        : Integer;
  vDateTime: TDateTime;
begin
  vDateTime := Now;
  FTempo.Enabled:= False;
  for i := 0 to FList.Count -1 do
  begin
    vEvent := FList[i];
    if not vEvent^.Ativado then
      Continue;
    if vEvent^.DataHEvento <= vDateTime then
          begin
                  With TFrmAlarme.Create(Self, vEvent, @DoEventDone) do
                      begin
                        Label1.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss', vEvent^.DataHEvento) + #13 + vEvent^.Evento;
                        if Assigned(FImagelist) and (vEvent^.idxImg > -1) then
                           FImagelist.GetBitmap(vEvent^.idxImg, Image1.Picture.Bitmap);
                         left := Screen.Width - Width;
                         show;
                      end;
                  vEvent^.Ativado := False;
          end;
  end;
  FTempo.Enabled := True;
end;

procedure TAlarme.SetimageList(AValue: TImageList);
begin
  if FimageList=AValue then Exit;
  FimageList:=AValue;
end;

procedure TAlarme.DoEventDone(aEvent : PEvento);
var
  Ev : PEvento;
begin
  if not aEvent^.Ativado then
    begin
      if  Assigned(FList)  then
            begin
               FList.Extract(aEvent);
               Dispose(aEvent);
            end;
    end;
end;

constructor TAlarme.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FList     := TList.Create;
  FTempo    := TTimer.Create(Self);
  FSobre    := TAbout.create;
  With FTempo do
  begin
      Interval  := 2000;
      OnTimer   := @Timer;
      Enabled   := False;
  end;
end;

destructor TAlarme.Destroy;
var
  i : Integer;
begin
  FreeAndNil(FSobre);
  for i := 0 to FList.Count -1 do
    Freemem(FList.Items[i]);
  Flist.Clear;
  FreeandNil(Flist);
  inherited Destroy;
end;

procedure TAlarme.AdicionarEvento(const aEvent : String; const aDateTime : TDateTime; idxImage : SmallInt; Idx : Integer);
var
  FEvento : ^TEvento;
begin
  New(FEVento);
  FEvento^.Evento      := aEvent;
  FEvento^.DataHEvento := aDateTime;
  FEvento^.Ativado     := True;
  FEvento^.idxImg      := idxImage;
  FEvento^.idx         := Idx; // indice da tela
  FList.Add(FEvento);
end;


end.


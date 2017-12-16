unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dateutils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, alarme;


type

  { TForm1 }

  TForm1 = class(TForm)
    Alarme1: TAlarme;
    Button1: TButton;
    ImageList1: TImageList;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    FSobre: TAbout;

  public

  published

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TAbout }



{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
 //formato e separador de data padrao
 FormatSettings.DateSeparator:='/';
 FormatSettings.ShortDateFormat:='dd/mm/yyyy';

//  Exemplo de adicionar eventos:
//     Alarme1.AdicionarEvento( Descricao do seu evento : string, datahora de disparo  TDateTime, indice da imagem do imagelist que vc deseja que apareça : Smallint);
//Se o imagelist nao for ligado ao componete Alarme nao parecera as imagens nos forms.


  Alarme1.AdicionarEvento('Valor de receber - R$10,00',IncSecond(now,3),2);
  Alarme1.AdicionarEvento('Contas a Pagar - 15,00',    IncSecond(now,6),4);
  Alarme1.AdicionarEvento('Fulano ligou as 15:00',     IncSecond(now,9),0);
  Alarme1.AdicionarEvento('Dentista as 15:00',         IncSecond(now,9),1);
  Alarme1.AdicionarEvento('Lembrar de comprar impressora!', StrToDateTime('05/07/2017 21:09'), 1);
  alarme1.Ativar;
  //alarme1.Desativar; //para desativar se necessario

  //*Caso adicione um item com data/hora mais antigo ele será apresentado em primeiro lugar.
  //*Ao clicar no botao "entendi", o componente nao voltará apresentar o alerta.
  //*Ao Clicar no botao "adiar", o componente novamente apresentara a msg apartir da qtd de minutos selecionadas.
  //*Componente criado mostrar recados do dia que haja necessidade de lembrar
  //Imagine a seguinte situação: Ao abrir o aplicativo, o mesmo faz um leitura de contas a pagar do dia e é adicionada
  //um evento no componente para alertar o valor que vai pagar no dia.
  //Espero que gostem!
end;


end.


program PedidoVenda;

uses
  Vcl.Forms,
  uFrmPedidoVenda in 'ui\uFrmPedidoVenda.pas' {FormPedidoVenda},
  uDmDB in 'infra\uDmDB.pas' {DmDB: TDataModule},
  uOrderRepository in 'infra\uOrderRepository.pas',
  uOrderService in 'app\uOrderService.pas',
  uOrderTypes in 'app\uOrderTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDmDB, DmDB);
  Application.CreateForm(TFormPedidoVenda, FormPedidoVenda);
  Application.Run;
end.

unit uFrmPedidoVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, 
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, 
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Data.DB, FireDAC.Comp.Client,
  uOrderService, uOrderTypes, uOrderRepository, System.Generics.Collections,
  FireDAC.Stan.Param, System.UITypes, FireDAC.DApt;

type
  TFormPedidoVenda = class(TForm)
    pnlTop: TPanel;
    gbCliente: TGroupBox;
    edtNumeroPedido: TLabeledEdit;
    edtCodigoCliente: TLabeledEdit;
    edtNomeCliente: TLabeledEdit;
    edtCidade: TLabeledEdit;
    edtUF: TLabeledEdit;
    pnlProduct: TPanel;
    gbProduto: TGroupBox;
    edtCodigoProduto: TLabeledEdit;
    edtDescricaoProduto: TLabeledEdit;
    edtQuantidade: TLabeledEdit;
    edtValorUnitario: TLabeledEdit;
    btnAdicionarItem: TButton;
    btnLimparItem: TButton;
    pnlCenter: TPanel;
    gbItens: TGroupBox;
    gridItens: TStringGrid;
    pnlBottom: TPanel;
    gbAcoes: TGroupBox;
    btnGravarPedido: TButton;
    btnCarregarPedido: TButton;
    btnCancelarPedido: TButton;
    btnNovoPedido: TButton;
    gbTotal: TGroupBox;
    lblValorTotal: TLabel;
    lblQuantidadeItens: TLabel;
    
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCodigoClienteExit(Sender: TObject);
    procedure edtCodigoClienteKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodigoProdutoExit(Sender: TObject);
    procedure edtCodigoProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure edtQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure edtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure btnLimparItemClick(Sender: TObject);
    procedure gridItensDblClick(Sender: TObject);
    procedure gridItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure btnCarregarPedidoClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure btnNovoPedidoClick(Sender: TObject);
  private
    FOrderService: TOrderService;
    FCurrentCustomer: TCustomer;
    FEditingItemIndex: Integer;
    
    procedure InitializeGrid;
    procedure RefreshGrid;
    procedure UpdateTotals;
    procedure ClearProductFields;
    procedure ClearCustomerFields;
    procedure SetCustomerData(const Customer: TCustomer);
    procedure LoadCustomerByCode(Code: Integer);
    procedure LoadProductByCode(Code: Integer);
    function ValidateProductEntry: Boolean;
    function CreateOrderItemFromFields: TOrderItem;
    procedure SetProductFieldsFromItem(const Item: TOrderItem);
    procedure ShowError(const Msg: string);
    procedure ShowInfo(const Msg: string);
    function ConfirmAction(const Msg: string): Boolean;
    procedure UpdateButtonStates;
    function InputOrderNumber(const Title: string): Int64;
    procedure LoadOrderById(OrderNumber: Int64);
  public
    { Public declarations }
  end;

var
  FormPedidoVenda: TFormPedidoVenda;

implementation

uses
  uDmDB, System.Math, System.StrUtils;

{$R *.dfm}

{ TFormPedidoVenda }

procedure TFormPedidoVenda.FormCreate(Sender: TObject);
begin
  try
    DmDB.TestConnection;
    FOrderService := TOrderService.Create(TOrderRepositoryFD.Create(DmDB.FConn));

    InitializeGrid;

    btnNovoPedidoClick(nil);

    FEditingItemIndex := -1;
    UpdateButtonStates;
  except
    on E: Exception do
    begin
      ShowError('Erro ao inicializar a aplicação: ' + E.Message);
      Application.Terminate;
    end;
  end;
end;

procedure TFormPedidoVenda.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F2: btnNovoPedidoClick(nil);
    VK_F3: btnCarregarPedidoClick(nil);
    VK_F5: btnGravarPedidoClick(nil);
    VK_F8: btnCancelarPedidoClick(nil);
    VK_F9: btnLimparItemClick(nil);
    VK_F10: btnAdicionarItemClick(nil);
    VK_ESCAPE: Close;
  end;
end;

procedure TFormPedidoVenda.InitializeGrid;
begin
  gridItens.ColCount := 6;
  gridItens.RowCount := 2;
  gridItens.FixedRows := 1;
  
  //Cabeçalho
  gridItens.Cells[0, 0] := 'Código';
  gridItens.Cells[1, 0] := 'Descrição';
  gridItens.Cells[2, 0] := 'Quantidade';
  gridItens.Cells[3, 0] := 'Vlr. Unitário';
  gridItens.Cells[4, 0] := 'Vlr. Total';
  gridItens.Cells[5, 0] := 'Seq';
  
  //Larguras das colunas
  gridItens.ColWidths[0] := 80;   // Código
  gridItens.ColWidths[1] := 280;  // Descrição
  gridItens.ColWidths[2] := 100;  // Quantidade
  gridItens.ColWidths[3] := 120;  // Vlr. Unitário
  gridItens.ColWidths[4] := 120;  // Vlr. Total
  gridItens.ColWidths[5] := 60;   // Sequencial (oculto praticamente)
end;

procedure TFormPedidoVenda.RefreshGrid;
var
  I: Integer;
  Items: TList<TOrderItem>;
begin
  Items := FOrderService.Items;

  if Items.Count > 0 then
  begin
    gridItens.RowCount := Items.Count + 1;
    
    for I := 0 to Items.Count - 1 do
    begin
      gridItens.Cells[0, I + 1] := IntToStr(Items[I].ProductId);
      gridItens.Cells[1, I + 1] := Items[I].Description;
      gridItens.Cells[2, I + 1] := FormatFloat('#,##0.000', Items[I].Qty);
      gridItens.Cells[3, I + 1] := FormatFloat('R$ #,##0.00', Items[I].UnitPrice);
      gridItens.Cells[4, I + 1] := FormatFloat('R$ #,##0.00', Items[I].Total);
      gridItens.Cells[5, I + 1] := IntToStr(I); // Índice interno
    end;

    gridItens.Row := 1;
  end
  else
  begin
    //Quando não há itens, manter apenas 2 linhas (cabeçalho + 1 vazia)
    gridItens.RowCount := 2;
    //Limpar a linha de dados
    for I := 0 to gridItens.ColCount - 1 do
      gridItens.Cells[I, 1] := '';
  end;
  
  UpdateTotals;
end;

procedure TFormPedidoVenda.UpdateTotals;
var
  Total: Currency;
  QtdItens: Integer;
begin
  Total := FOrderService.GrandTotal;
  QtdItens := FOrderService.Items.Count;
  
  lblValorTotal.Caption := FormatFloat('R$ #,##0.00', Total);
  if QtdItens = 1 then
    lblQuantidadeItens.Caption := Format('%d item', [QtdItens])
  else
    lblQuantidadeItens.Caption := Format('%d itens', [QtdItens]);
end;

procedure TFormPedidoVenda.ClearProductFields;
begin
  edtCodigoProduto.Clear;
  edtDescricaoProduto.Clear;
  edtQuantidade.Clear;
  edtValorUnitario.Clear;
  FEditingItemIndex := -1;
  btnAdicionarItem.Caption := 'Adicionar/Atualizar';
end;

procedure TFormPedidoVenda.ClearCustomerFields;
begin
  edtCodigoCliente.Clear;
  edtNomeCliente.Clear;
  edtCidade.Clear;
  edtUF.Clear;
  FillChar(FCurrentCustomer, SizeOf(FCurrentCustomer), 0);
end;

procedure TFormPedidoVenda.SetCustomerData(const Customer: TCustomer);
begin
  FCurrentCustomer := Customer;
  edtCodigoCliente.Text := IntToStr(Customer.Code);
  edtNomeCliente.Text := Customer.Name;
  edtCidade.Text := Customer.City;
  edtUF.Text := Customer.UF;
end;

procedure TFormPedidoVenda.LoadCustomerByCode(Code: Integer);
var
  Customer: TCustomer;
begin
  Customer := FOrderService.FindCustomer(Code);
  
  if Customer.Code > 0 then
  begin
    SetCustomerData(Customer);
  end
  else
  begin
    ShowError('Cliente não encontrado!');
    edtCodigoCliente.SetFocus;
  end;
end;

procedure TFormPedidoVenda.LoadProductByCode(Code: Integer);
var
  Product: TProduct;
begin
  Product := FOrderService.FindProduct(Code);
  
  if Product.Code > 0 then
  begin
    edtDescricaoProduto.Text := Product.Description;
    edtValorUnitario.Text := FormatFloat('0.00', Product.SalePrice);
    edtQuantidade.SetFocus;
  end
  else
  begin
    ShowError('Produto não encontrado!');
    edtCodigoProduto.SetFocus;
  end;
end;

function TFormPedidoVenda.ValidateProductEntry: Boolean;
var
  Qty: Double;
  Price: Currency;
begin
  Result := False;

  if Trim(edtCodigoProduto.Text) = '' then
  begin
    ShowError('Informe o código do produto!');
    edtCodigoProduto.SetFocus;
    Exit;
  end;

  if not TryStrToFloat(edtQuantidade.Text, Qty) or (Qty <= 0) then
  begin
    ShowError('Informe uma quantidade válida!');
    edtQuantidade.SetFocus;
    Exit;
  end;

  if not TryStrToCurr(edtValorUnitario.Text, Price) or (Price < 0) then
  begin
    ShowError('Informe um valor unitário válido!');
    edtValorUnitario.SetFocus;
    Exit;
  end;
  
  Result := True;
end;

function TFormPedidoVenda.CreateOrderItemFromFields: TOrderItem;
begin
  Result.ProductId := StrToInt(edtCodigoProduto.Text);
  Result.Description := edtDescricaoProduto.Text;
  Result.Qty := StrToFloat(edtQuantidade.Text);
  Result.UnitPrice := StrToCurr(edtValorUnitario.Text);
end;

procedure TFormPedidoVenda.SetProductFieldsFromItem(const Item: TOrderItem);
begin
  edtCodigoProduto.Text := IntToStr(Item.ProductId);
  edtDescricaoProduto.Text := Item.Description;
  edtQuantidade.Text := FormatFloat('0.000', Item.Qty);
  edtValorUnitario.Text := FormatFloat('0.00', Item.UnitPrice);
end;

procedure TFormPedidoVenda.ShowError(const Msg: string);
begin
  MessageDlg(Msg, mtError, [mbOK], 0);
end;

procedure TFormPedidoVenda.ShowInfo(const Msg: string);
begin
  MessageDlg(Msg, mtInformation, [mbOK], 0);
end;

function TFormPedidoVenda.ConfirmAction(const Msg: string): Boolean;
begin
  Result := MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

procedure TFormPedidoVenda.UpdateButtonStates;
var
  ClienteInformado: Boolean;
begin
  ClienteInformado := FCurrentCustomer.Code > 0;

  btnCarregarPedido.Visible := not ClienteInformado;
  btnCancelarPedido.Visible := not ClienteInformado;

  gbProduto.Enabled := ClienteInformado;

  btnGravarPedido.Enabled := ClienteInformado and (FOrderService.Items.Count > 0);
end;

procedure TFormPedidoVenda.edtCodigoClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8, #13]) then
    Key := #0;
  if Key = #13 then
    edtCodigoClienteExit(Sender);
end;

procedure TFormPedidoVenda.edtCodigoClienteExit(Sender: TObject);
var
  Code: Integer;
begin
  if TryStrToInt(edtCodigoCliente.Text, Code) and (Code > 0) then
  begin
    try
      LoadCustomerByCode(Code);
      UpdateButtonStates;
    except
      on E: Exception do
        ShowError('Erro ao carregar cliente: ' + E.Message);
    end;
  end;
end;

procedure TFormPedidoVenda.edtCodigoProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8, #13]) then
    Key := #0;
  if Key = #13 then
    edtCodigoProdutoExit(Sender);
end;

procedure TFormPedidoVenda.edtCodigoProdutoExit(Sender: TObject);
var
  Code: Integer;
begin
  if TryStrToInt(edtCodigoProduto.Text, Code) and (Code > 0) then
    LoadProductByCode(Code);
end;

procedure TFormPedidoVenda.edtQuantidadeKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', ',', '.', #8, #13]) then
    Key := #0;
  if Key = #13 then
    edtValorUnitario.SetFocus;
end;

procedure TFormPedidoVenda.edtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', ',', '.', #8, #13]) then
    Key := #0;
  if Key = #13 then
    btnAdicionarItemClick(Sender);
end;

procedure TFormPedidoVenda.btnAdicionarItemClick(Sender: TObject);
var
  Item: TOrderItem;
begin
  if not ValidateProductEntry then Exit;
  try
    Item := CreateOrderItemFromFields;
    if FEditingItemIndex >= 0 then
      FOrderService.RemoveAt(FEditingItemIndex);

    FOrderService.AddOrUpdateItem(Item);
    ClearProductFields;
    RefreshGrid;
    UpdateButtonStates;
    edtCodigoProduto.SetFocus;
  except
    on E: Exception do
      ShowError('Erro ao adicionar item: ' + E.Message);
  end;
end;

procedure TFormPedidoVenda.btnLimparItemClick(Sender: TObject);
begin
  ClearProductFields;
  edtCodigoProduto.SetFocus;
end;

procedure TFormPedidoVenda.gridItensDblClick(Sender: TObject);
var
  SelectedRow: Integer; Items: TList<TOrderItem>;
begin
  SelectedRow := gridItens.Row;
  if SelectedRow <= 0 then Exit;
  Items := FOrderService.Items;
  if SelectedRow > Items.Count then Exit;
  FEditingItemIndex := StrToInt(gridItens.Cells[5, SelectedRow]);
  SetProductFieldsFromItem(Items[FEditingItemIndex]);
  btnAdicionarItem.Caption := 'Atualizar Item';
  edtQuantidade.SetFocus;
end;

procedure TFormPedidoVenda.gridItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  SelectedRow: Integer;
begin
  case Key of
    VK_RETURN: gridItensDblClick(Sender);
    VK_DELETE: begin
      SelectedRow := gridItens.Row;
      if (SelectedRow > 0) and (SelectedRow <= FOrderService.Items.Count) then
        if ConfirmAction('Deseja realmente excluir este item?') then
        begin
          FOrderService.RemoveAt(StrToInt(gridItens.Cells[5, SelectedRow]));
          RefreshGrid;
        end;
    end;
  end;
end;

procedure TFormPedidoVenda.btnGravarPedidoClick(Sender: TObject);
begin
  if FCurrentCustomer.Code = 0 then
  begin
    ShowError('Informe um cliente!');
    Exit;
  end;
  if FOrderService.Items.Count = 0 then
  begin
    ShowError('Adicione ao menos um item ao pedido!');
    Exit;
  end;
  try
    //Atualizar o CustomerId no Service antes de gravar
    FOrderService.SetCustomerId(FCurrentCustomer.Code);
    
    FOrderService.Submit;
    edtNumeroPedido.Text := IntToStr(FOrderService.OrderNumber);
    ShowInfo(Format('Pedido %d gravado com sucesso!', [FOrderService.OrderNumber]));
  except
    on E: Exception do
      ShowError('Erro ao gravar pedido: ' + E.Message);
  end;
  btnNovoPedidoClick(nil);
end;

function TFormPedidoVenda.InputOrderNumber(const Title: string): Int64;
var
  Input: string;
begin
  Result := 0;
  if InputQuery(Title, 'Número do Pedido:', Input) then
    if not TryStrToInt64(Input, Result) or (Result <= 0) then
    begin
      ShowError('Número de pedido inválido!');
      Result := 0;
    end;
end;

procedure TFormPedidoVenda.LoadOrderById(OrderNumber: Int64);
begin
  if FOrderService.LoadOrderData(OrderNumber) then
  begin
    FCurrentCustomer := FOrderService.CurrentOrder.Customer;
    SetCustomerData(FCurrentCustomer);
    edtNumeroPedido.Text := IntToStr(OrderNumber);
    
    RefreshGrid;
    UpdateButtonStates;
  end
  else
  begin
    ShowError('Pedido não encontrado ou foi cancelado!');
  end;
end;

procedure TFormPedidoVenda.btnCarregarPedidoClick(Sender: TObject);
var
  OrderNumber: Int64;
begin
  OrderNumber := InputOrderNumber('Carregar Pedido');
  if OrderNumber > 0 then
    LoadOrderById(OrderNumber);
end;

procedure TFormPedidoVenda.btnCancelarPedidoClick(Sender: TObject);
var
  OrderNumber: Int64;
begin
  OrderNumber := InputOrderNumber('Cancelar Pedido');
  if OrderNumber = 0 then Exit;
  if not ConfirmAction(Format('Deseja realmente CANCELAR o pedido %d?', [OrderNumber])) then Exit;
  
  try
    FOrderService.CancelOrder(OrderNumber);
    ShowInfo(Format('Pedido %d cancelado com sucesso!', [OrderNumber]));
  except
    on E: Exception do
      ShowError('Erro ao cancelar pedido: ' + E.Message);
  end;
end;

procedure TFormPedidoVenda.btnNovoPedidoClick(Sender: TObject);
begin
  try
    ClearCustomerFields;
    ClearProductFields;
    FOrderService.NewOrder(0);
    edtNumeroPedido.Text := '0';
    RefreshGrid;
    UpdateButtonStates;
    edtCodigoCliente.SetFocus;
  except
    on E: Exception do
      ShowError('Erro ao iniciar novo pedido: ' + E.Message);
  end;
end;

end.

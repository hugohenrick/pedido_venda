unit uOrderRepository;

interface
uses uOrderService, uOrderTypes, System.Generics.Collections, FireDAC.Comp.Client,
Data.DB;

type
  TOrderRepositoryFD = class(TOrderRepositoryBase)
  private
    FConn: TFDConnection;
  public
    constructor Create(AConn: TFDConnection);
    function NextNumber: Int64; override;
    procedure Save(const Order: TOrder; const Items: TList<TOrderItem>); override;
    function FindCustomer(Code: Integer): TCustomer; override;
    function FindProduct(Code: Integer): TProduct; override;
    function LoadOrder(OrderNumber: Int64; out Order: TOrder; out Items: TList<TOrderItem>): Boolean; override;
    procedure CancelOrder(OrderNumber: Int64); override;
  end;

implementation

uses FireDAC.Stan.Param, System.SysUtils;

constructor TOrderRepositoryFD.Create(AConn: TFDConnection);
begin
  FConn := AConn;
end;

function TOrderRepositoryFD.NextNumber: Int64;
var 
  QueryNumberControl: TFDQuery;
  Transaction: TFDTransaction;
begin
  Result := 0;
  Transaction := TFDTransaction.Create(nil);
  QueryNumberControl := TFDQuery.Create(nil);
  try
    try
      Transaction.Connection := FConn;
      QueryNumberControl.Connection := FConn;
      QueryNumberControl.Transaction := Transaction;
    
      Transaction.StartTransaction;

      QueryNumberControl.SQL.Text := 'UPDATE controle_numeracao SET ultimo_numero = ultimo_numero + 1, ' +
                                     'updated_at = CURRENT_TIMESTAMP WHERE tabela = ''pedidos''';
      QueryNumberControl.ExecSQL;

      QueryNumberControl.SQL.Text := 'SELECT ultimo_numero FROM controle_numeracao WHERE tabela = ''pedidos''';
      QueryNumberControl.Open;

      if not QueryNumberControl.Eof then
        Result := QueryNumberControl.FieldByName('ultimo_numero').AsLargeInt;

      Transaction.Commit;
    except
      on E: Exception do
      begin
        if Transaction.Active then
          Transaction.Rollback;
        raise Exception.Create('Erro ao gerar próximo número do pedido: ' + E.Message);
      end;
    end;
  finally
    QueryNumberControl.Free;
    Transaction.Free;
  end;

end;

procedure TOrderRepositoryFD.Save(const Order: TOrder; const Items: TList<TOrderItem>);
var 
  QueryOrderHeader, QueryOrderItems: TFDQuery; 
  CurrentItem: TOrderItem;
  TotalValue: Currency;
begin
  FConn.StartTransaction;
  try
    QueryOrderHeader := TFDQuery.Create(nil);
    QueryOrderItems := TFDQuery.Create(nil);
    try
      QueryOrderHeader.Connection := FConn;
      QueryOrderItems.Connection := FConn;

      //Calcular valor total no Delphi
      TotalValue := 0;
      for CurrentItem in Items do
        TotalValue := TotalValue + CurrentItem.Total;

      QueryOrderHeader.SQL.Text :=
        'INSERT INTO pedidos(numero_pedido, codigo_cliente, data_emissao, valor_total, status) '+
        'VALUES (:numero_pedido, :codigo_cliente, NOW(), :valor_total, ''ATIVO'') '+
        'ON DUPLICATE KEY UPDATE codigo_cliente = VALUES(codigo_cliente), valor_total = VALUES(valor_total), status = ''ATIVO''';
      QueryOrderHeader.ParamByName('numero_pedido').AsLargeInt := Order.Number;
      QueryOrderHeader.ParamByName('codigo_cliente').AsInteger  := Order.CustomerId;
      QueryOrderHeader.ParamByName('valor_total').AsCurrency := TotalValue;
      QueryOrderHeader.ExecSQL;

      //Limpar itens existentes do pedido antes de inserir novos
      QueryOrderItems.SQL.Text := 'DELETE FROM pedidos_produtos WHERE numero_pedido = :numero_pedido';
      QueryOrderItems.ParamByName('numero_pedido').AsLargeInt := Order.Number;
      QueryOrderItems.ExecSQL;

      QueryOrderItems.SQL.Text :=
        'INSERT INTO pedidos_produtos(numero_pedido, codigo_produto, quantidade, vlr_unitario, vlr_total) '+
        'VALUES (:numero_pedido, :codigo_produto, :quantidade, :valor_unitario, :valor_total)';
      for CurrentItem in Items do
      begin
        QueryOrderItems.ParamByName('numero_pedido').AsLargeInt := Order.Number;
        QueryOrderItems.ParamByName('codigo_produto').AsInteger  := CurrentItem.ProductId;
        QueryOrderItems.ParamByName('quantidade').AsFloat    := CurrentItem.Qty;
        QueryOrderItems.ParamByName('valor_unitario').AsCurrency := CurrentItem.UnitPrice;
        QueryOrderItems.ParamByName('valor_total').AsCurrency := CurrentItem.Total;
        QueryOrderItems.ExecSQL;
      end;

      FConn.Commit;
    finally
      QueryOrderHeader.Free; 
      QueryOrderItems.Free;
    end;
  except
    FConn.Rollback;
    raise;
  end;
end;

function TOrderRepositoryFD.FindCustomer(Code: Integer): TCustomer;
var QueryCustomer: TFDQuery;
begin
  FillChar(Result, SizeOf(Result), 0);
  
  QueryCustomer := TFDQuery.Create(nil);
  try
    QueryCustomer.Connection := FConn;
    QueryCustomer.SQL.Text := 'SELECT codigo, nome, cidade, uf FROM clientes WHERE codigo = :codigo';
    QueryCustomer.ParamByName('codigo').AsInteger := Code;
    QueryCustomer.Open;
    
    if not QueryCustomer.IsEmpty then
    begin
      Result.Code := QueryCustomer.FieldByName('codigo').AsInteger;
      Result.Name := QueryCustomer.FieldByName('nome').AsString;
      Result.City := QueryCustomer.FieldByName('cidade').AsString;
      Result.UF := QueryCustomer.FieldByName('uf').AsString;
    end;
  finally
    QueryCustomer.Free;
  end;
end;

function TOrderRepositoryFD.FindProduct(Code: Integer): TProduct;
var QueryProduct: TFDQuery;
begin
  FillChar(Result, SizeOf(Result), 0);
  
  QueryProduct := TFDQuery.Create(nil);
  try
    QueryProduct.Connection := FConn;
    QueryProduct.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos WHERE codigo = :codigo';
    QueryProduct.ParamByName('codigo').AsInteger := Code;
    QueryProduct.Open;
    
    if not QueryProduct.IsEmpty then
    begin
      Result.Code := QueryProduct.FieldByName('codigo').AsInteger;
      Result.Description := QueryProduct.FieldByName('descricao').AsString;
      Result.SalePrice := QueryProduct.FieldByName('preco_venda').AsCurrency;
    end;
  finally
    QueryProduct.Free;
  end;
end;

function TOrderRepositoryFD.LoadOrder(OrderNumber: Int64; out Order: TOrder; out Items: TList<TOrderItem>): Boolean;
var 
  QueryOrderData, QueryOrderItems: TFDQuery;
  CurrentItem: TOrderItem;
begin
  Result := False;
  FillChar(Order, SizeOf(Order), 0);
  Items := nil;
  
  QueryOrderData := TFDQuery.Create(nil);
  QueryOrderItems := TFDQuery.Create(nil);
  try
    //Dados do pedido
    QueryOrderData.Connection := FConn;
    QueryOrderData.SQL.Text := 
      'SELECT p.numero_pedido, p.codigo_cliente, p.data_emissao, p.valor_total, ' +
      '       c.nome, c.cidade, c.uf ' +
      'FROM pedidos p ' +
      'INNER JOIN clientes c ON p.codigo_cliente = c.codigo ' +
      'WHERE p.numero_pedido = :numero AND p.status = ''ATIVO''';
    QueryOrderData.ParamByName('numero').AsLargeInt := OrderNumber;
    QueryOrderData.Open;
    
    if QueryOrderData.IsEmpty then
      Exit;
    
    //Dados do pedido
    Order.Number := QueryOrderData.FieldByName('numero_pedido').AsLargeInt;
    Order.CustomerId := QueryOrderData.FieldByName('codigo_cliente').AsInteger;
    Order.IssueDate := QueryOrderData.FieldByName('data_emissao').AsDateTime;
    Order.TotalValue := QueryOrderData.FieldByName('valor_total').AsCurrency;
    
    //Dados do cliente
    Order.Customer.Code := QueryOrderData.FieldByName('codigo_cliente').AsInteger;
    Order.Customer.Name := QueryOrderData.FieldByName('nome').AsString;
    Order.Customer.City := QueryOrderData.FieldByName('cidade').AsString;
    Order.Customer.UF := QueryOrderData.FieldByName('uf').AsString;
    
    //Itens do pedido
    Items := TList<TOrderItem>.Create;
    QueryOrderItems.Connection := FConn;
    QueryOrderItems.SQL.Text := 
      'SELECT pp.codigo_produto, pr.descricao, pp.quantidade, pp.vlr_unitario ' +
      'FROM pedidos_produtos pp ' +
      'INNER JOIN produtos pr ON pp.codigo_produto = pr.codigo ' +
      'WHERE pp.numero_pedido = :numero ' +
      'ORDER BY pp.autoincrem';
    QueryOrderItems.ParamByName('numero').AsLargeInt := OrderNumber;
    QueryOrderItems.Open;
    
    while not QueryOrderItems.Eof do
    begin
      CurrentItem.ProductId := QueryOrderItems.FieldByName('codigo_produto').AsInteger;
      CurrentItem.Description := QueryOrderItems.FieldByName('descricao').AsString;
      CurrentItem.Qty := QueryOrderItems.FieldByName('quantidade').AsFloat;
      CurrentItem.UnitPrice := QueryOrderItems.FieldByName('vlr_unitario').AsCurrency;
      
      Items.Add(CurrentItem);
      QueryOrderItems.Next;
    end;
    
    Result := True;
  finally
    QueryOrderData.Free;
    QueryOrderItems.Free;
  end;
end;

procedure TOrderRepositoryFD.CancelOrder(OrderNumber: Int64);
var 
  QueryCancelOrder: TFDQuery;
  Transaction: TFDTransaction;
begin
  Transaction := TFDTransaction.Create(nil);
  QueryCancelOrder := TFDQuery.Create(nil);
  try
    try
      Transaction.Connection := FConn;
      QueryCancelOrder.Connection := FConn;
      QueryCancelOrder.Transaction := Transaction;

      Transaction.StartTransaction;

      QueryCancelOrder.SQL.Text := 'UPDATE pedidos SET status = ''CANCELADO'' WHERE numero_pedido = :numero_pedido';
      QueryCancelOrder.ParamByName('numero_pedido').AsLargeInt := OrderNumber;
      QueryCancelOrder.ExecSQL;

      Transaction.Commit;
    except
      on E: Exception do
      begin
        if Transaction.Active then
          Transaction.Rollback;
        raise Exception.Create('Erro ao cancelar pedido: ' + E.Message);
      end;
    end;
  finally
    QueryCancelOrder.Free;
    Transaction.Free;
  end;
end;

end.


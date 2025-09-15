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

uses FireDAC.Stan.Param;

constructor TOrderRepositoryFD.Create(AConn: TFDConnection);
begin
  FConn := AConn;
end;

function TOrderRepositoryFD.NextNumber: Int64;
var Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'CALL sp_proximo_numero_pedido(@proximo)';
    Q.ExecSQL;
    
    Q.SQL.Text := 'SELECT @proximo as proximo_numero';
    Q.Open;
    Result := Q.FieldByName('proximo_numero').AsLargeInt;
  finally
    Q.Free;
  end;
end;

procedure TOrderRepositoryFD.Save(const Order: TOrder; const Items: TList<TOrderItem>);
var QH, QI: TFDQuery; It: TOrderItem;
begin
  FConn.StartTransaction;
  try
    QH := TFDQuery.Create(nil);
    QI := TFDQuery.Create(nil);
    try
      QH.Connection := FConn;
      QI.Connection := FConn;

      QH.SQL.Text :=
        'INSERT INTO pedidos(numero_pedido, codigo_cliente, data_emissao, valor_total) '+
        'VALUES (:numero_pedido, :codigo_cliente, NOW(), :valor_total) '+
        'ON DUPLICATE KEY UPDATE codigo_cliente = VALUES(codigo_cliente), valor_total = VALUES(valor_total)';
      QH.ParamByName('numero_pedido').AsLargeInt := Order.Number;
      QH.ParamByName('codigo_cliente').AsInteger  := Order.CustomerId;
      QH.ParamByName('valor_total').AsCurrency := 0; //Será calculado pela trigger
      QH.ExecSQL;

      //Limpar itens existentes do pedido antes de inserir novos
      QI.SQL.Text := 'DELETE FROM pedidos_produtos WHERE numero_pedido = :numero_pedido';
      QI.ParamByName('numero_pedido').AsLargeInt := Order.Number;
      QI.ExecSQL;

      QI.SQL.Text :=
        'INSERT INTO pedidos_produtos(numero_pedido, codigo_produto, quantidade, vlr_unitario, vlr_total) '+
        'VALUES (:numero_pedido, :codigo_produto, :quantidade, :valor_unitario, :valor_total)';
      for It in Items do
      begin
        QI.ParamByName('numero_pedido').AsLargeInt := Order.Number;
        QI.ParamByName('codigo_produto').AsInteger  := It.ProductId;
        QI.ParamByName('quantidade').AsFloat    := It.Qty;
        QI.ParamByName('valor_unitario').AsCurrency := It.UnitPrice;
        QI.ParamByName('valor_total').AsCurrency := It.Total;
        QI.ExecSQL;
      end;

      FConn.Commit;
    finally
      QH.Free; QI.Free;
    end;
  except
    FConn.Rollback;
    raise;
  end;
end;

function TOrderRepositoryFD.FindCustomer(Code: Integer): TCustomer;
var Q: TFDQuery;
begin
  FillChar(Result, SizeOf(Result), 0);
  
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT codigo, nome, cidade, uf FROM clientes WHERE codigo = :codigo';
    Q.ParamByName('codigo').AsInteger := Code;
    Q.Open;
    
    if not Q.IsEmpty then
    begin
      Result.Code := Q.FieldByName('codigo').AsInteger;
      Result.Name := Q.FieldByName('nome').AsString;
      Result.City := Q.FieldByName('cidade').AsString;
      Result.UF := Q.FieldByName('uf').AsString;
    end;
  finally
    Q.Free;
  end;
end;

function TOrderRepositoryFD.FindProduct(Code: Integer): TProduct;
var Q: TFDQuery;
begin
  FillChar(Result, SizeOf(Result), 0);
  
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos WHERE codigo = :codigo';
    Q.ParamByName('codigo').AsInteger := Code;
    Q.Open;
    
    if not Q.IsEmpty then
    begin
      Result.Code := Q.FieldByName('codigo').AsInteger;
      Result.Description := Q.FieldByName('descricao').AsString;
      Result.SalePrice := Q.FieldByName('preco_venda').AsCurrency;
    end;
  finally
    Q.Free;
  end;
end;

function TOrderRepositoryFD.LoadOrder(OrderNumber: Int64; out Order: TOrder; out Items: TList<TOrderItem>): Boolean;
var 
  QOrder, QItems: TFDQuery;
  Item: TOrderItem;
begin
  Result := False;
  FillChar(Order, SizeOf(Order), 0);
  Items := nil;
  
  QOrder := TFDQuery.Create(nil);
  QItems := TFDQuery.Create(nil);
  try
    //Dados do pedido
    QOrder.Connection := FConn;
    QOrder.SQL.Text := 
      'SELECT p.numero_pedido, p.codigo_cliente, p.data_emissao, p.valor_total, ' +
      '       c.nome, c.cidade, c.uf ' +
      'FROM pedidos p ' +
      'INNER JOIN clientes c ON p.codigo_cliente = c.codigo ' +
      'WHERE p.numero_pedido = :numero AND p.status = ''ATIVO''';
    QOrder.ParamByName('numero').AsLargeInt := OrderNumber;
    QOrder.Open;
    
    if QOrder.IsEmpty then
      Exit;
    
    //Dados do pedido
    Order.Number := QOrder.FieldByName('numero_pedido').AsLargeInt;
    Order.CustomerId := QOrder.FieldByName('codigo_cliente').AsInteger;
    Order.IssueDate := QOrder.FieldByName('data_emissao').AsDateTime;
    Order.TotalValue := QOrder.FieldByName('valor_total').AsCurrency;
    
    //Dados do cliente
    Order.Customer.Code := QOrder.FieldByName('codigo_cliente').AsInteger;
    Order.Customer.Name := QOrder.FieldByName('nome').AsString;
    Order.Customer.City := QOrder.FieldByName('cidade').AsString;
    Order.Customer.UF := QOrder.FieldByName('uf').AsString;
    
    //Itens do pedido
    Items := TList<TOrderItem>.Create;
    QItems.Connection := FConn;
    QItems.SQL.Text := 
      'SELECT pp.codigo_produto, pr.descricao, pp.quantidade, pp.vlr_unitario ' +
      'FROM pedidos_produtos pp ' +
      'INNER JOIN produtos pr ON pp.codigo_produto = pr.codigo ' +
      'WHERE pp.numero_pedido = :numero ' +
      'ORDER BY pp.autoincrem';
    QItems.ParamByName('numero').AsLargeInt := OrderNumber;
    QItems.Open;
    
    while not QItems.Eof do
    begin
      Item.ProductId := QItems.FieldByName('codigo_produto').AsInteger;
      Item.Description := QItems.FieldByName('descricao').AsString;
      Item.Qty := QItems.FieldByName('quantidade').AsFloat;
      Item.UnitPrice := QItems.FieldByName('vlr_unitario').AsCurrency;
      
      Items.Add(Item);
      QItems.Next;
    end;
    
    Result := True;
  finally
    QOrder.Free;
    QItems.Free;
  end;
end;

procedure TOrderRepositoryFD.CancelOrder(OrderNumber: Int64);
var Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'CALL sp_cancelar_pedido(:numero)';
    Q.ParamByName('numero').AsLargeInt := OrderNumber;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

end.


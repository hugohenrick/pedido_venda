unit uOrderService;

interface
uses System.Generics.Collections, uOrderTypes, System.SysUtils;

type
  TOrderRepositoryBase = class
  public
    function NextNumber: Int64; virtual;
    procedure Save(const Order: TOrder;
                   const Items: TList<TOrderItem>); virtual;
    function FindCustomer(Code: Integer): TCustomer; virtual;
    function FindProduct(Code: Integer): TProduct; virtual;
    function LoadOrder(OrderNumber: Int64; out Order: TOrder; out Items: TList<TOrderItem>): Boolean; virtual;
    procedure CancelOrder(OrderNumber: Int64); virtual;
  end;

  TOrderService = class
  private
    FItems: TList<TOrderItem>;
    FRepo: TOrderRepositoryBase;
    FOrder: TOrder;
  public
    constructor Create(ARepo: TOrderRepositoryBase);
    destructor Destroy; override;

    procedure NewOrder(ACustomerId: Integer);
    procedure AddOrUpdateItem(AItem: TOrderItem);
    procedure RemoveAt(Index: Integer);
    function  Items: TList<TOrderItem>;
    function  GrandTotal: Currency;

    procedure Submit;
    function  OrderNumber: Int64;
    
    function FindCustomer(Code: Integer): TCustomer;
    function FindProduct(Code: Integer): TProduct;
    function LoadOrderData(OrderNumber: Int64): Boolean;
    procedure CancelOrder(OrderNumber: Int64);
    procedure SetCustomerId(ACustomerId: Integer);
    
    property CurrentOrder: TOrder read FOrder;
  end;

implementation

{ TOrderRepositoryBase }
function TOrderRepositoryBase.NextNumber: Int64;
begin
  Result := 0;
end;

procedure TOrderRepositoryBase.Save(const Order: TOrder; const Items: TList<TOrderItem>);
begin
end;

function TOrderRepositoryBase.FindCustomer(Code: Integer): TCustomer;
begin
  FillChar(Result, SizeOf(Result), 0);
end;

function TOrderRepositoryBase.FindProduct(Code: Integer): TProduct;
begin
  FillChar(Result, SizeOf(Result), 0);
end;

function TOrderRepositoryBase.LoadOrder(OrderNumber: Int64; out Order: TOrder; out Items: TList<TOrderItem>): Boolean;
begin
  FillChar(Order, SizeOf(Order), 0);
  Items := nil;
  Result := False;
end;

procedure TOrderRepositoryBase.CancelOrder(OrderNumber: Int64);
begin
  //
end;

{ TOrderService }
constructor TOrderService.Create(ARepo: TOrderRepositoryBase);
begin
  FRepo := ARepo;
  FItems := TList<TOrderItem>.Create;
end;

destructor TOrderService.Destroy;
begin
  FItems.Free;
  FRepo.Free;
  inherited;
end;

procedure TOrderService.NewOrder(ACustomerId: Integer);
begin
  FOrder.Number := 0;
  FOrder.CustomerId := ACustomerId;
  FItems.Clear;
end;

procedure TOrderService.AddOrUpdateItem(AItem: TOrderItem);
begin
  if AItem.Qty <= 0 then raise Exception.Create('Quantidade inválida');
  if AItem.UnitPrice < 0 then raise Exception.Create('Preço inválido');

  FItems.Add(AItem);
end;

procedure TOrderService.RemoveAt(Index: Integer);
begin
  FItems.Delete(Index);
end;

function TOrderService.Items: TList<TOrderItem>;
begin
  Result := FItems;
end;

function TOrderService.GrandTotal: Currency;
var It: TOrderItem; Total: Currency;
begin
  Total := 0;
  for It in FItems do
    Total := Total + It.Total;
  Result := Total;
end;

procedure TOrderService.Submit;
begin
  if FItems.Count = 0 then
    raise Exception.Create('Pedido sem itens.');

  if FOrder.Number = 0 then
    FOrder.Number := FRepo.NextNumber;

  FRepo.Save(FOrder, FItems);
end;

function TOrderService.OrderNumber: Int64;
begin
  Result := FOrder.Number;
end;

function TOrderService.FindCustomer(Code: Integer): TCustomer;
begin
  Result := FRepo.FindCustomer(Code);
end;

function TOrderService.FindProduct(Code: Integer): TProduct;
begin
  Result := FRepo.FindProduct(Code);
end;

function TOrderService.LoadOrderData(OrderNumber: Int64): Boolean;
var
  Order: TOrder;
  Items: TList<TOrderItem>;
begin
  Result := FRepo.LoadOrder(OrderNumber, Order, Items);
  if Result then
  begin
    FOrder := Order;
    FItems.Clear;
    if Assigned(Items) then
    begin
      FItems.AddRange(Items);
      Items.Free;
    end;
  end;
end;

procedure TOrderService.CancelOrder(OrderNumber: Int64);
begin
  FRepo.CancelOrder(OrderNumber);
end;

procedure TOrderService.SetCustomerId(ACustomerId: Integer);
begin
  FOrder.CustomerId := ACustomerId;
end;

end.


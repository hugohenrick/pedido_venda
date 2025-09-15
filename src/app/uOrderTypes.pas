unit uOrderTypes;

interface

type
  TCustomer = record
    Code: Integer;
    Name: string;
    City: string;
    UF: string;
  end;

  TProduct = record
    Code: Integer;
    Description: string;
    SalePrice: Currency;
  end;

  TOrderItem = record
    ProductId: Integer;
    Description: string;
    Qty: Double;
    UnitPrice: Currency;
    function Total: Currency;
  end;

  TOrder = record
    Number: Int64;
    CustomerId: Integer;
    Customer: TCustomer;
    IssueDate: TDateTime;
    TotalValue: Currency;
  end;

implementation

function TOrderItem.Total: Currency;
begin
  Result := Qty * UnitPrice;
end;

end.


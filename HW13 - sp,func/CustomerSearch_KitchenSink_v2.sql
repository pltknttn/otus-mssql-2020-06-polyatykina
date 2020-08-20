USE WideWorldImporters
GO

CREATE or alter PROCEDURE dbo.CustomerSearch_KitchenSink_v2
  @CustomerID            int            = NULL,
  @CustomerName          nvarchar(100)  = NULL,
  @BillToCustomerID      int            = NULL,
  @CustomerCategoryID    int            = NULL,
  @BuyingGroupID         int            = NULL,
  @MinAccountOpenedDate  date           = NULL,
  @MaxAccountOpenedDate  date           = NULL,
  @DeliveryCityID        int            = NULL,
  @IsOnCreditHold        bit            = NULL,
  @OrdersCount			 INT			= NULL, 
  @PersonID				 INT			= NULL, 
  @DeliveryStateProvince INT			= NULL,
  @PrimaryContactPersonIDIsEmployee BIT = NULL

AS
BEGIN
  SET NOCOUNT ON;
  
  SELECT CustomerID, CustomerName, IsOnCreditHold
  FROM Sales.Customers AS Client
	JOIN Application.People AS Person ON 
		Person.PersonID = Client.PrimaryContactPersonID
	JOIN Application.Cities AS City ON
		City.CityID = Client.DeliveryCityID 
  WHERE Client.AccountOpenedDate >= COALESCE(@MinAccountOpenedDate, Client.AccountOpenedDate)
    AND Client.AccountOpenedDate <=  COALESCE(@MaxAccountOpenedDate, Client.AccountOpenedDate)
	AND Client.CustomerID = isnull(@CustomerID, Client.CustomerID)
    AND Client.CustomerName LIKE isnull(@CustomerName, Client.CustomerName)
    AND Client.BillToCustomerID = isnull(@BillToCustomerID, Client.BillToCustomerID)
    AND Client.CustomerCategoryID = isnull(@CustomerCategoryID, Client.CustomerCategoryID)
    AND Client.BuyingGroupID = isnull(@BuyingGroupID, Client.BuyingGroupID)
    AND Client.DeliveryCityID = isnull(@DeliveryCityID, Client.DeliveryCityID)
    AND Client.IsOnCreditHold = isnull(@IsOnCreditHold, Client.IsOnCreditHold)
	AND ((@OrdersCount IS NULL)
		OR ((SELECT COUNT(*) FROM Sales.Orders
			WHERE Orders.CustomerID = Client.CustomerID)
				>= @OrdersCount
			)
		)
	AND  Client.PrimaryContactPersonID = isnull(@PersonID, Client.PrimaryContactPersonID)
	AND  City.StateProvinceID = isnull(@DeliveryStateProvince, City.StateProvinceID)
	AND  Person.IsEmployee = isnull(@PrimaryContactPersonIDIsEmployee, Person.IsEmployee); 
END
USE WideWorldImporters
GO
CREATE OR ALTER PROCEDURE dbo.CustomerSearch_KitchenSink
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
  
  DECLARE @Command NVARCHAR(max)  = '
  SELECT CustomerID, CustomerName, IsOnCreditHold
  FROM Sales.Customers AS Client
	JOIN Application.People AS Person ON Person.PersonID = Client.PrimaryContactPersonID
	JOIN Application.Cities AS City ON City.CityID = Client.DeliveryCityID
  WHERE Client.AccountOpenedDate >= COALESCE(@MinAccountOpenedDate, Client.AccountOpenedDate) 
    AND Client.AccountOpenedDate <= COALESCE(@MaxAccountOpenedDate, Client.AccountOpenedDate)',
         @Params nvarchar(max) = '
		 @CustomerID int, @CustomerName nvarchar(100), @BillToCustomerID int, @CustomerCategoryID int, @BuyingGroupID int, 
         @MinAccountOpenedDate  date, @MaxAccountOpenedDate  date, @DeliveryCityID int, @IsOnCreditHold bit, @OrdersCount INT, 
		 @PersonID INT, @DeliveryStateProvince INT, @PrimaryContactPersonIDIsEmployee BIT';

  IF @CustomerID IS NOT NULL SET @Command += ' AND Client.CustomerID = @CustomerID'
  IF @CustomerName IS NOT NULL SET @Command += ' AND Client.CustomerName LIKE @CustomerName'
  IF @BillToCustomerID IS NOT NULL  SET @Command += ' AND Client.BillToCustomerID = @BillToCustomerID'
  IF @CustomerCategoryID IS NOT NULL  SET @Command += ' AND Client.CustomerCategoryID = @CustomerCategoryID'
  IF @BuyingGroupID IS NOT NULL SET @Command += ' AND Client.BuyingGroupID = @BuyingGroupID'
  IF @DeliveryCityID IS NOT NULL SET @Command += ' AND Client.DeliveryCityID = @DeliveryCityID'
  IF @IsOnCreditHold IS NOT NULL SET @Command += ' AND Client.IsOnCreditHold = @IsOnCreditHold'
  IF @OrdersCount IS NOT NULL SET @Command += ' AND ((SELECT COUNT(*) FROM Sales.Orders WHERE Orders.CustomerID = Client.CustomerID) >= @OrdersCount)'
  IF @PersonID IS NOT NULL SET @Command += ' AND Client.PrimaryContactPersonID = @PersonID'
  IF @DeliveryStateProvince IS NOT NULL SET @Command += ' AND City.StateProvinceID = @DeliveryStateProvince'
  IF @PrimaryContactPersonIDIsEmployee IS NOT NULL SET @Command += ' AND Person.IsEmployee = @PrimaryContactPersonIDIsEmployee'

  EXEC sp_executesql @Command, @Params, @CustomerID,
										@CustomerName,
										@BillToCustomerID,
										@CustomerCategoryID,
										@BuyingGroupID,
										@MinAccountOpenedDate,
										@MaxAccountOpenedDate,
										@DeliveryCityID,
										@IsOnCreditHold,
										@OrdersCount,
										@PersonID,
										@DeliveryStateProvince,
										@PrimaryContactPersonIDIsEmployee; 
END
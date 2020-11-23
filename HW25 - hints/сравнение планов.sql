use WideWorldImporters
go

Select 
	ord.CustomerID, 
	det.StockItemID, 
	SUM(det.UnitPrice) SUMUnitPrice, 
	SUM(det.Quantity) SUMQuantity, 
	COUNT(ord.OrderID) COUNTOrderID
FROM Sales.Orders AS ord
JOIN Sales.OrderLines AS det
	ON det.OrderID = ord.OrderID
JOIN Sales.Invoices AS Inv
	ON Inv.OrderID = ord.OrderID
JOIN Sales.CustomerTransactions AS Trans
	ON Trans.InvoiceID = Inv.InvoiceID
JOIN Warehouse.StockItemTransactions AS ItemTrans
	ON ItemTrans.StockItemID = det.StockItemID
WHERE Inv.BillToCustomerID != ord.CustomerID
	
	AND (Select SupplierId
		  FROM Warehouse.StockItems AS It
		  Where It.StockItemID = det.StockItemID) = 12
	
	AND (SELECT SUM(Total.UnitPrice*Total.Quantity)
		  FROM Sales.OrderLines AS Total
		  Join Sales.Orders AS ordTotal
					On ordTotal.OrderID = Total.OrderID
		 WHERE ordTotal.CustomerID = Inv.CustomerID) >= 250000
	
	AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID
go

;WITH Customers as (
SELECT ordTotal.CustomerID 
  FROM Sales.OrderLines AS Total
	  JOIN Sales.Orders AS ordTotal ON ordTotal.OrderID = Total.OrderID
GROUP BY ordTotal.CustomerID 
HAVING SUM(Total.UnitPrice*Total.Quantity) > 250000
)
Select 
	ord.CustomerID, 
	det.StockItemID, 
	SUM(det.UnitPrice) SUMUnitPrice, 
	SUM(det.Quantity)  SUMQuantity, 
	COUNT(ord.OrderID) COUNTOrderID
FROM Sales.Orders AS ord
INNER JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID  
INNER JOIN Warehouse.StockItems AS It ON It.StockItemID = det.StockItemID AND IT.SupplierID = 12 
INNER JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID 
INNER JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
INNER JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID 
WHERE Inv.CustomerID in (SELECT CustomerID from Customers)   
  AND Inv.BillToCustomerID != ord.CustomerID
  AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID  
go
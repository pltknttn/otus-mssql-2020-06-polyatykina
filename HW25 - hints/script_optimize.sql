use WideWorldImporters
go

SET STATISTICS IO, TIME, XML ON;

--SET SHOWPLAN_ALL ON;  
--SET SHOWPLAN_ALL OFF;  

--SET SHOWPLAN_XML ON;
--SET SHOWPLAN_XML OFF;

GO 

-- drop index if exists IX_Sales_Invoices_OrderId_CustomerId_BillToCustomerId on Sales.Invoices
--create nonclustered index IX_Sales_Invoices_OrderId_CustomerId_BillToCustomerId on Sales.Invoices (OrderId, CustomerID, BillToCustomerId) include (InvoiceId, InvoiceDate)
 
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
DBCC SHOW_STATISTICS (N'[Sales].[Invoices]', N'FK_Sales_Invoices_OrderID')
DBCC SHOW_STATISTICS (N'[Sales].[Invoices]', N'PK_Sales_Invoices') 
--DBCC SHOW_STATISTICS (N'[Sales].[Invoices]', N'FK_Sales_Invoices_CustomerID')  
--DBCC SHOW_STATISTICS (N'[Sales].[Invoices]', N'FK_Sales_Invoices_BillToCustomerID')  
DBCC SHOW_STATISTICS (N'[Sales].[Invoices]', N'IX_Sales_Invoices_OrderId_CustomerId_BillToCustomerId')  
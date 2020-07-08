use [WideWorldImporters]
go


/*1. ��� ������, � �������� ������� ���� "urgent" ��� �������� ���������� � "Animal"
�������: Warehouse.StockItems.*/

SELECT [StockItemID]
      ,[StockItemName]
      ,[SupplierID]
      ,[ColorID]
      ,[UnitPackageID]
      ,[OuterPackageID]
      ,[Brand]
      ,[Size]
      ,[LeadTimeDays]
      ,[QuantityPerOuter]
      ,[IsChillerStock]
      ,[Barcode]
      ,[TaxRate]
      ,[UnitPrice]
      ,[RecommendedRetailPrice]
      ,[TypicalWeightPerUnit]
      ,[MarketingComments]
      ,[InternalComments]
      ,[Photo]
      ,[CustomFields]
      ,[Tags]
      ,[SearchDetails]
      ,[LastEditedBy] 
  FROM [Warehouse].[StockItems]
  where StockItemName like '%urgent%' or StockItemName like 'animal%'

 /*2. ����������� (Suppliers), � ������� �� ���� ������� �� ������ ������ (PurchaseOrders). ������� ����� JOIN, � ����������� ������� ������� �� �����.
�������: Purchasing.Suppliers, Purchasing.PurchaseOrders.*/

 select 
       s.[SupplierID]
      ,s.[SupplierName]
      ,s.[SupplierCategoryID]
      ,s.[PrimaryContactPersonID]
      ,s.[AlternateContactPersonID]
      ,s.[DeliveryMethodID]
      ,s.[DeliveryCityID]
      ,s.[PostalCityID]
      ,s.[SupplierReference]
      ,s.[BankAccountName]
      ,s.[BankAccountBranch]
      ,s.[BankAccountCode]
      ,s.[BankAccountNumber]
      ,s.[BankInternationalCode]
      ,s.[PaymentDays]
      ,s.[InternalComments]
      ,s.[PhoneNumber]
      ,s.[FaxNumber]
      ,s.[WebsiteURL]
      ,s.[DeliveryAddressLine1]
      ,s.[DeliveryAddressLine2]
      ,s.[DeliveryPostalCode]
      ,s.[DeliveryLocation]
      ,s.[PostalAddressLine1]
      ,s.[PostalAddressLine2]
      ,s.[PostalPostalCode]
      ,s.[LastEditedBy]
   from [Purchasing].[Suppliers] s
   left join [Purchasing].PurchaseOrders po on po.SupplierID = s.SupplierID
where po.SupplierID is null

/*3. ������ (Orders) � ����� ������ ����� 100$ ���� ����������� ������ ������ ����� 20 ���� � �������������� ����� ������������ ����� ������ (PickingCompletedWhen).
�������:
* OrderID
* ���� ������ � ������� ��.��.����
* �������� ������, � ������� ���� �������
* ����� ��������, � �������� ��������� �������
* ����� ����, � ������� ��������� ���� ������� (������ ����� �� 4 ������)
* ��� ��������� (Customer)
�������� ������� ����� ������� � ������������ ��������, ��������� ������ 1000 � ��������� ��������� 100 �������. ���������� ������ ���� �� ������ ��������, ����� ����, ���� ������ (����� �� �����������).
�������: Sales.Orders, Sales.OrderLines, Sales.Customers.*/

 select 
       o.[OrderID]      
      ,convert(varchar(30), o.[OrderDate], 104)  OrderDateDDMMYYYY
	  ,DATENAME(month, o.[OrderDate])            OrderMonth 
	  ,FORMAT ( o.[OrderDate], 'MMMM', 'ru-Ru' ) OrderMonthRus
	  ,DATENAME(quarter, o.[OrderDate])          [Quarter]
	  ,case when MONTH(o.[OrderDate]) between 1 and 4 then 1
	        when MONTH(o.[OrderDate]) between 5 and 8 then 2
			else 3 end                           [Third] 
	  ,c.CustomerName
   from [Sales].[Orders] o
      join [Sales].[OrderLines] ol on ol.OrderID = o.OrderID 
	  join [Sales].[Customers] c on c.CustomerID = o.CustomerID
   where  o.PickingCompletedWhen is not null
   group 
      by o.[OrderID]
        ,o.[CustomerID] 
		,c.CustomerName
		,o.[OrderDate]
   having max(ol.UnitPrice) > 0 or count(ol.OrderLineID) > 20

/*4. ������ ����������� (Purchasing.Suppliers), ������� ���� ��������� � ������ 2014 ���� � ��������� Air Freight ��� Refrigerated Air Freight (DeliveryMethodName).
�������:
* ������ �������� (DeliveryMethodName)
* ���� ��������
* ��� ����������
* ��� ����������� ���� ������������ ����� (ContactPerson).
�������: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.*/

select dm.DeliveryMethodName
      ,s.SupplierName 
      ,po.[ExpectedDeliveryDate]
      ,p.FullName  SupplierContactPerson
      ,po.[LastEditedWhen]
  from [Purchasing].Suppliers s
    join [Purchasing].PurchaseOrders po on po.SupplierID = s.SupplierID
	join [Application].DeliveryMethods dm on dm.DeliveryMethodID = po.DeliveryMethodID
	join [Application].[People] p on p.PersonID = po.ContactPersonID
 where po.ExpectedDeliveryDate between '20140101' and '20140131'
   and dm.DeliveryMethodName in( 'Air Freight', 'Refrigerated Air Freight')
group by dm.DeliveryMethodName
      ,s.SupplierName 
      ,po.[ExpectedDeliveryDate]
      ,p.FullName
      ,po.[LastEditedWhen]


/*5. ������ ��������� ������ (�� ����) � ������ ������� � ������ ����������, ������� ������� ����� (SalespersonPerson).*/

select top 10 
       o.OrderDate
     , c.CustomerName
	 , p.FullName SalespersonPerson
 from Sales.Orders o
   join Sales.Customers c on c.CustomerID = o.CustomerID
   join [Application].[People] p on p.PersonID = o.SalespersonPersonID
group by o.OrderDate
     , c.CustomerName
	 , p.FullName
order by o.OrderDate desc

/*6. ��� �� � ����� �������� � �� ���������� ��������, ������� �������� ����� Chocolate frogs 250g. ��� ������ �������� � Warehouse.StockItems.*/

select o.CustomerID
     , c.CustomerName
	 , c.PhoneNumber
   from Warehouse.StockItems si
       join Sales.OrderLines ol on ol.StockItemID = si.SupplierID
	   join Sales.Orders o on o.OrderID = ol.OrderLineID
	   join Sales.Customers c on c.CustomerID = o.CustomerID
   where si.StockItemName = 'Chocolate frogs 250g'
group by o.CustomerID
     , c.CustomerName
	 , c.PhoneNumber
use [WideWorldImporters]
go


/*1. Все товары, в названии которых есть "urgent" или название начинается с "Animal"
Таблицы: Warehouse.StockItems.*/

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
  where StockItemName like '%urgent%' COLLATE Latin1_General_CS_AS
     or StockItemName like 'Animal%' COLLATE Latin1_General_CS_AS

 /*2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders). Сделать через JOIN, с подзапросом задание принято не будет.
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.*/

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

/*3. Заказы (Orders) с ценой товара более 100$ либо количеством единиц товара более 20 штук и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа в формате ДД.ММ.ГГГГ
* название месяца, в котором была продажа
* номер квартала, к которому относится продажа
* треть года, к которой относится дата продажи (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой, пропустив первую 1000 и отобразив следующие 100 записей. Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).
Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.*/

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
   having max(ol.UnitPrice) > 100 or sum(ol.Quantity) > 20
   order by [Quarter] ASC, [Third] ASC, [OrderDate] ASC
   OFFSET 1000 ROWS FETCH NEXT 100 ROWS ONLY

/*4. Заказы поставщикам (Purchasing.Suppliers), которые были исполнены в январе 2014 года с доставкой Air Freight или Refrigerated Air Freight (DeliveryMethodName).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.*/

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


/*5. Десять последних продаж (по дате) с именем клиента и именем сотрудника, который оформил заказ (SalespersonPerson).*/

select top 10 
       o.OrderDate
     , c.CustomerName
	 , p.FullName SalespersonPerson
 from Sales.Orders o
   join Sales.Customers c on c.CustomerID = o.CustomerID
   join [Application].[People] p on p.PersonID = o.SalespersonPersonID
order by o.OrderDate desc

/*6. Все ид и имена клиентов и их контактные телефоны, которые покупали товар Chocolate frogs 250g. Имя товара смотреть в Warehouse.StockItems.*/

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
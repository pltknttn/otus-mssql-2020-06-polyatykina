use [WideWorldImporters]
go

/*SQL SERVER 2019*/

/*--------------------------------------------------------------------------------------------------

4. Выберите города (ид и название), в которые были доставлены товары, входящие в тройку самых дорогих товаров, а также имя сотрудника, который осуществлял упаковку заказов (PickedByPersonID).

!!!  В задани некорректо указано поле PickedByPersonID - это Person who picked this shipment
!!!  PackedByPersonID - Person who packed this shipment (or checked the packing) 
!!!  Упаковка заказа и его сборка(комплектация) разные действия.
*/
 
 
select distinct cs.CityID, cs.CityName, p.FullName PickedByPerson
   from [Sales].InvoiceLines il 
	  join [Sales].Invoices i on i.InvoiceID = il.InvoiceID
	  join [Sales].[Customers] c on c.CustomerID = i.CustomerID
      join [Application].[Cities] cs on cs.CityID = c.DeliveryCityID
	  join [Application].[People] p on p.PersonID = i.PackedByPersonID
   where il.StockItemID in (select top 3 StockItemID from [Warehouse].[StockItems] order by UnitPrice desc) 
 
select distinct cs.CityID, cs.CityName, p.FullName PickedByPerson
   from [Sales].InvoiceLines il 
      join (select top 3 StockItemID from [Warehouse].[StockItems] order by UnitPrice desc)  si on il.StockItemID = si.StockItemID
	  join [Sales].Invoices i on i.InvoiceID = il.InvoiceID
	  join [Sales].[Customers] c on c.CustomerID = i.CustomerID
      join [Application].[Cities] cs on cs.CityID = c.DeliveryCityID
	  join [Application].[People] p on p.PersonID = i.PackedByPersonID 
	   
;with Goods as (select top 3 StockItemID from [Warehouse].[StockItems] order by UnitPrice desc) 
    , Invoices as (select distinct i.CustomerID, i.PackedByPersonID
	                 from [Sales].Invoices i
					     join [Sales].InvoiceLines il on i.InvoiceID = il.InvoiceID
						 join Goods g on g.StockItemID = il.StockItemID) 
select distinct cs.CityID, cs.CityName, p.FullName PickedByPerson
   from Invoices i 
      join [Sales].[Customers] c on c.CustomerID = i.CustomerID
      join [Application].[Cities] cs on cs.CityID = c.DeliveryCityID
	  join [Application].[People] p on p.PersonID = i.PackedByPersonID
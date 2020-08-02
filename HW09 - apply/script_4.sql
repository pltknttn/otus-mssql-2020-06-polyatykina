/*
4. Перепишите ДЗ из оконных функций через CROSS APPLY
Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки
*/

use [WideWorldImporters]
go

/*
Задание из урока 8
6. Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки
*/
 
 /*через оконные функциии*/
 ;with Sales as (
select il.StockItemID
     , max(i.InvoiceDate) InvoiceDate 
	 , i.CustomerID
	 , max(il.UnitPrice)  UnitPrice  
	 , ROW_NUMBER() OVER (PARTITION BY i.CustomerID ORDER BY max(il.UnitPrice) DESC) AS rn 
 from Sales.Invoices i join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID 
group by il.StockItemID 
	 , i.CustomerID 
) 
select i.CustomerID,
       c.CustomerName,
	   i.StockItemID,
       si.[StockItemName],
	   i.UnitPrice,
	   i.InvoiceDate
  from Sales i 
  JOIN Warehouse.[StockItems] si on si.StockItemID = i.StockItemID
  JOIN Sales.Customers c on c.CustomerID = i.CustomerID
where i.rn <= 2
ORDER BY c.CustomerName, i.UnitPrice desc, si.[StockItemName]

/*через CROSS APPLY*/
 select 
       c.CustomerID,
       c.CustomerName,
	   goods.StockItemID,
       si.[StockItemName],
	   goods.UnitPrice,
	   goods.InvoiceDate
    from Sales.Customers c  
	cross apply (
				 select top 2
					   il.StockItemID
					 , max(i.InvoiceDate) InvoiceDate
					 , max(il.UnitPrice)  UnitPrice   
				 from Sales.Invoices i join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID 
				 where i.CustomerID =  c.CustomerID
				group by il.StockItemID
				order by UnitPrice desc
              ) as goods
	join Warehouse.[StockItems] si on si.StockItemID = goods.StockItemID
 ORDER BY c.CustomerName, goods.UnitPrice desc, si.[StockItemName]

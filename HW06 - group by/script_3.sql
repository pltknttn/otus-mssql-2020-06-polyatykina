use WideWorldImporters
go

/*
3. Вывести сумму продаж, дату первой продажи и количество проданного по месяцам, по товарам, продажи которых менее 50 ед в месяц.
Группировка должна быть по году, месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.

Опционально:
Написать запросы 1-3 так, чтобы если в каком-то месяце не было продаж, то этот месяц также отображался бы в результатах, но там были нули.

*/

/*вариант 1*/
 select 
       YEAR(i.InvoiceDate)  [Year], 
	   FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU') [Month],
       SUM(il.Quantity*il.UnitPrice) TotalSum,
	   MIN(i.InvoiceDate)   FirstSaleDate,
	   SUM(il.Quantity)     TotalQuantity,
	   si.StockItemName
  from Sales.Invoices i
     join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
	 join Warehouse.StockItems si on si.StockItemID = il.StockItemID
 group by YEAR(i.InvoiceDate), FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU'), si.StockItemName
 having SUM(il.Quantity) < 50


 /*вариант 2*/
 select result.[Year],
        result.[Month],
		result.TotalSum,
		result.FirstSaleDate,
		result.TotalQuantity,
		si.StockItemName
 from (
  select 
       YEAR(i.InvoiceDate)  [Year], 
	   FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU') [Month],
       SUM(il.Quantity*il.UnitPrice) TotalSum,
	   MIN(i.InvoiceDate)   FirstSaleDate,
	   SUM(il.Quantity)     TotalQuantity,
	   il.StockItemID
  from Sales.Invoices i
     join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID 
 group by YEAR(i.InvoiceDate), FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU'), il.StockItemID
 ) result
 join Warehouse.StockItems si on si.StockItemID = result.StockItemID
 where result.TotalQuantity < 50

 /*Опционально: Посчитаем с 2012г по текущий год, по всем месяцам
 Итог - отчет за период с 2012 по текущий год по товарам, которые либо не продавались, либо их продано было менее 50 единиц в месяц.
 */ 
;with Years as (
             select cast(2012 as int ) [Year] 
             union all 
			 select [Year] + 1 
			   from Years
			  where [Year] <= year(getdate())
            ),
  MonthsYears as (
	     select [Year], 1 [Month], FORMAT(DATEFROMPARTS([Year],1,1), 'MMMM', 'ru-RU') [MonthName] from Years
		 union all
		  select [Year], [Month] + 1 [Month], FORMAT(DATEFROMPARTS([Year],[Month] + 1,1), 'MMMM', 'ru-RU') [MonthName]  
		    from MonthsYears
		   where [Month] < 12 
	 ),
   Sales as (
    select 
       YEAR(i.InvoiceDate)  [Year], 
	   DATEPART(MONTH, i.InvoiceDate) [Month],
       SUM(il.Quantity*il.UnitPrice) TotalSum,
	   MIN(i.InvoiceDate)   FirstSaleDate,
	   SUM(il.Quantity)     TotalQuantity,
	   il.StockItemID
  from Sales.Invoices i
     join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
	 join Warehouse.StockItems si on si.StockItemID = il.StockItemID
  group by YEAR(i.InvoiceDate), DATEPART(MONTH, i.InvoiceDate), il.StockItemID
 )
 select MonthsYears.[Year],
        MonthsYears.[MonthName],
		isnull(Sales.TotalSum,0) TotalSum,
		Sales.FirstSaleDate,
		isnull(Sales.TotalQuantity,0) TotalQuantity,
		si.StockItemName
    from  MonthsYears 
	cross join Warehouse.StockItems si
    left join Sales on Sales.[Year] = MonthsYears.[Year] and Sales.[Month] = MonthsYears.[Month] and si.StockItemID = Sales.StockItemID
 where isnull(Sales.TotalQuantity,0) < 50
 order by MonthsYears.[Year], MonthsYears.[Month]



use WideWorldImporters
go

/*
2. Отобразить все месяцы, где общая сумма продаж превысила 10 000

Вывести:
* Год продажи
* Месяц продажи
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах. 
*/

/*вариант 1*/
select YEAR(i.InvoiceDate)  [Year], 
	   FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU') [Month],
       SUM(il.Quantity*il.UnitPrice) TotalSum
  from Sales.Invoices i
     join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
 group by YEAR(i.InvoiceDate), FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU') 
 having SUM(il.Quantity*il.UnitPrice) > 10000
 
 /*вариант 2*/
 select result.[Year],
        result.[Month],
		result.TotalSum
    from (
 select 
       YEAR(i.InvoiceDate)  [Year], 
	   FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU') [Month],
       SUM(il.Quantity*il.UnitPrice) TotalSum
  from Sales.Invoices i
     join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
 group by YEAR(i.InvoiceDate), FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU') ) result
 where result.TotalSum > 10000
  

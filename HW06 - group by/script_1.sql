use WideWorldImporters
go
 
/*
1. ѕосчитать среднюю цену товара, общую сумму продажи по мес¤цам

¬ывести:
* √од продажи
* ћес¤ц продажи
* —редн¤¤ цена за мес¤ц по всем товарам
* ќбща¤ сумма продаж

ѕродажи смотреть в таблице Sales.Invoices и св¤занных таблицах.

ќпционально:
Ќаписать запросы 1-3 так, чтобы если в каком-то мес¤це не было продаж, то этот мес¤ц также отображалс¤ бы в результатах, но там были нули.
*/

select YEAR(i.InvoiceDate)  [Year], 
	   FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU') [Month],
       SUM(il.Quantity*il.UnitPrice) TotalSum,
	   AVG(il.UnitPrice) AvgUnitPrice
  from Sales.Invoices i
     join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
 group by YEAR(i.InvoiceDate), FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU')

 /*ќпционально: ѕосчитаем с 2012г по текущий год, по всем мес¤цам*/
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
	 )
 select 
       my.[Year]  [Year],  
	   my.[MonthName]   [Month],
       isnull(SUM(il.Quantity*il.UnitPrice),0) TotalSum,
	   isnull(AVG(il.UnitPrice),0)             AvgUnitPrice
   from MonthsYears my
    left join Sales.Invoices i on YEAR(i.InvoiceDate) = my.[Year] and DATEPART(MONTH, i.InvoiceDate) = my.[Month]
    left join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
 group by   my.[Year], my.[MonthName], my.[Month]
 order by my.[Year], my.[Month]


/*≈сли бы потребовались итоги по году и всего*/
select case when GROUPING(YEAR(i.InvoiceDate)) = 1 then N'¬сего'
            when GROUPING(FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU')) = 1 then N'¬сего за год'
			else N'¬сего за мес¤ц' end Result,   
       YEAR(i.InvoiceDate)  [Year], 
	   FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU') [Month],
       SUM(il.Quantity*il.UnitPrice) TotalSum,
	   AVG(il.UnitPrice) AvgUnitPrice
  from Sales.Invoices i
     join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
GROUP BY ROLLUP(YEAR(i.InvoiceDate), FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU'))


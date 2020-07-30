/*
Оконные функции
1. Напишите запрос с временной таблицей и перепишите его с табличной переменной. 
Сравните планы.
В качестве запроса с временной таблицей и табличной переменной можно взять свой запрос 
или следующий запрос:
Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года (в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки)
Выведите id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом
Пример
Дата продажи Нарастающий итог по месяцу
2015-01-29 4801725.31
2015-01-30 4801725.31
2015-01-31 4801725.31
2015-02-01 9626342.98
2015-02-02 9626342.98
2015-02-03 9626342.98
Продажи можно взять из таблицы Invoices.
Нарастающий итог должен быть без оконной функции.

2. Если вы брали предложенный выше запрос, то сделайте расчет суммы нарастающим итогом с помощью оконной функции.
Сравните 2 варианта запроса - через windows function и без них.
Написать какой быстрее выполняется, сравнить по set statistics time on;

3. Вывести список 2х самых популярных продуктов (по кол-ву проданных) в каждом месяце за 2016й год (по 2 самых популярных продукта в каждом месяце)

4. Функции одним запросом
Посчитайте по таблице товаров, в вывод также должен попасть ид товара, название, брэнд и цена
пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
посчитайте общее количество товаров и выведете полем в этом же запросе
посчитайте общее количество товаров в зависимости от первой буквы названия товара
отобразите следующий id товара исходя из того, что порядок отображения товаров по имени
предыдущий ид товара с тем же порядком отображения (по имени)
названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
сформируйте 30 групп товаров по полю вес товара на 1 шт
Для этой задачи НЕ нужно писать аналог без аналитических функций

5. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал
В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки

6. Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки

Опционально можно сделать вариант запросов для заданий 2,5,6 без использования windows function и сравнить скорость как в задании 1.

Bonus из предыдущей темы
Напишите запрос, который выбирает 10 клиентов, которые сделали больше 30 заказов и последний заказ был не позднее апреля 2016.
*/

use [WideWorldImporters]
go

SET STATISTICS IO, TIME ON;
GO
  
/*1. Напишите запрос с временной таблицей и перепишите его с табличной переменной. */
drop table if exists #Sales
create table #Sales
(
    InvoiceID int not null PRIMARY KEY,
	InvoiceDate date not null,
	CustomerName nvarchar(255) not null,
	CustomerID int not null INDEX #IX_Sales_CustomerID (CustomerID),
	SumSale decimal(16, 2) not null 
)
insert into #Sales (InvoiceID, InvoiceDate, CustomerName, CustomerID, SumSale)
select
      i.InvoiceID
     ,i.InvoiceDate
     ,c.CustomerName  
	 ,i.CustomerID  
	 ,sum(il.Quantity * isnull(il.UnitPrice,0)) SumSale
 from Sales.Invoices i 
 join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
 join Sales.Customers c on c.CustomerID = i.CustomerID 
 where i.InvoiceDate >= '20150101'
 group by i.InvoiceID, i.InvoiceDate, c.CustomerName,i.CustomerID   

 select i.InvoiceID
     ,  i.CustomerName
	 ,  i.InvoiceDate
	 ,  i.SumSale
	 ,  (select sum(s.SumSale) from #Sales s  where s.CustomerID = i.CustomerID and YEAR(i.InvoiceDate) = YEAR(s.InvoiceDate) and MONTH(i.InvoiceDate) = MONTH(s.InvoiceDate)) CumulativeTotal
   from #Sales i
   order by i.InvoiceDate, i.CustomerName
/*
Table 'Worktable'. Scan count 31440, logical reads 138485
Table '#Sales______________________________________________________________________________________________________________000000000025'. Scan count 2, logical reads 618, 
*/

declare @Sales table
(
    InvoiceID int not null  PRIMARY KEY,
	InvoiceDate date not null,
	CustomerName nvarchar(255) not null,
	CustomerID int not null INDEX #IX_Sales_CustomerID (CustomerID),
	SumSale decimal(16, 2) not null 
)
insert into @Sales (InvoiceID, InvoiceDate, CustomerName, CustomerID, SumSale)
select
      i.InvoiceID
     ,i.InvoiceDate
     ,c.CustomerName  
	 ,i.CustomerID  
	 ,sum(il.Quantity * isnull(il.UnitPrice,0)) SumSale
 from Sales.Invoices i 
 join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
 join Sales.Customers c on c.CustomerID = i.CustomerID 
 where i.InvoiceDate >= '20150101'
 group by i.InvoiceID, i.InvoiceDate, c.CustomerName,i.CustomerID   

  
 select i.InvoiceID
     ,  i.CustomerName
	 ,  i.InvoiceDate
	 ,  i.SumSale
	 ,  (select sum(s.SumSale) from @Sales s  where s.CustomerID = i.CustomerID and YEAR(i.InvoiceDate) = YEAR(s.InvoiceDate) and MONTH(i.InvoiceDate) = MONTH(s.InvoiceDate)) CumulativeTotal
   from @Sales i
 order by i.InvoiceDate, i.CustomerName
/*
Table '#B4FDF0E2'. Scan count 31441, logical reads 9715269, physical reads 0, page server reads 0, read-ahead reads 0
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 290

без order by
Table '#B861B234'. Scan count 31441, logical reads 9715269,*/    

 select i.InvoiceID
     ,  i.CustomerName
	 ,  i.InvoiceDate
	 ,  i.SumSale
	 ,  (select sum(s.SumSale) from @Sales s  where s.CustomerID = i.CustomerID and YEAR(i.InvoiceDate) = YEAR(s.InvoiceDate) and MONTH(i.InvoiceDate) = MONTH(s.InvoiceDate)) CumulativeTotal
   from @Sales i
   order by i.InvoiceDate, i.CustomerName
  OPTION(RECOMPILE)
 /*
Table 'Worktable'. Scan count 92200, logical reads 378072
Table '#B315A870'. Scan count 8, logical reads 618
 */

/*
Временная таблица и табличная переменна с RECOMPILE дают почти одинаковые результаты - по декларированной в 3 раза больше чтений, 
'Worktable' - значит SQLServer выполнил предобработку в промежуточную таблицу.
 
Временная таблица и табличная переменна без RECOMPILE - существенные различия по времени выполнения, 
план показывает, что по временной ожидаемо было 1 строка, реально 31 441, 
для каждой строки происходит происходит поиск по всему диапазону это 31 441, в итоге читаем около 31 441*31 441 = 988536481, всего было считано 988473600 строки
У нас нет стоимости выполнения 0%. 
- видим  Index Scan, но операторы сравнения  (s.CustomerID = i.CustomerID) и фильтрации (YEAR(i.InvoiceDate) = YEAR(s.InvoiceDate) and MONTH(i.InvoiceDate) = MONTH(s.InvoiceDate)) не выполняются

с RECOMPILE стоимость появляется, используем статистику на момент выполнения
- видим  Index Scan, но операторы сравнения  (s.CustomerID = i.CustomerID) и фильтрации (YEAR(i.InvoiceDate) = YEAR(s.InvoiceDate) and MONTH(i.InvoiceDate) = MONTH(s.InvoiceDate)) уже выполняются.

Убрала индексы из @Sales и выполнила без RECOMPILE - результат 
Table '#A6AFD18B'. Scan count 31441, logical reads 9683828
считано 988473600 строк, операции сравнения не выполняются (s.CustomerID = i.CustomerID) , фильтрации нет (YEAR(i.InvoiceDate) = YEAR(s.InvoiceDate) and MONTH(i.InvoiceDate) = MONTH(s.InvoiceDate)), стоимость 0
получается что SQLServer для табличных переменных что с индексами, что без работает сравнительно одинаково - если нет статиститики, то делает по каждой строке большое кол-во чтений в таблице поиска

без индексов @Sales и c RECOMPILE - видим Table Scan, но операторы сравнения  (s.CustomerID = i.CustomerID) и фильтрации (YEAR(i.InvoiceDate) = YEAR(s.InvoiceDate) and MONTH(i.InvoiceDate) = MONTH(s.InvoiceDate)) выполняются
Table 'Worktable'. Scan count 92408, logical reads 380238,
Table '#A89819FD'. Scan count 2, logical reads 616,

*/


/*
2. Если вы брали предложенный выше запрос, то сделайте расчет суммы нарастающим итогом с помощью оконной функции.
Сравните 2 варианта запроса - через windows function и без них.
*/

;with Sales as (
select i.CustomerID
     , YEAR(i.InvoiceDate)  [Year]
     , MONTH(i.InvoiceDate) [Month] 
	 , sum(il.Quantity * il.UnitPrice) Total
 from Sales.Invoices i 
 join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
 where i.InvoiceDate >= '20150101'
 group by i.CustomerID, YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)
)
select  i.InvoiceID
     ,  c.CustomerName
	 ,  i.InvoiceDate
	 ,  SUM(il.Quantity * isnull(il.UnitPrice,0)) SumSale
	 ,  (select sum(s.Total) from Sales s where  s.CustomerID = i.CustomerID and YEAR(i.InvoiceDate)  = s.[Year] and MONTH(i.InvoiceDate) = s.[Month]) CumulativeTotal
  from  Sales.Invoices i 
      join Sales.Customers c on c.CustomerID = i.CustomerID
      join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
where i.InvoiceDate >= '20150101'
 group by  i.InvoiceID
         , i.CustomerID
		 , c.CustomerName
		 , i.InvoiceDate
order by i.InvoiceDate, c.CustomerName
 

;with Sales as (
select
      i.InvoiceID
     ,i.InvoiceDate
     ,i.CustomerID
     ,YEAR(i.InvoiceDate)  [Year]
     ,MONTH(i.InvoiceDate) [Month] 
	 ,sum(il.Quantity * isnull(il.UnitPrice,0)) SumSale
 from Sales.Invoices i 
 join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
 where i.InvoiceDate >= '20150101'
 group by i.InvoiceID, i.InvoiceDate, i.CustomerID, YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)
)
select  InvoiceID,
        CustomerName,
		InvoiceDate,
		SumSale,
		sum(SumSale) over (partition by i.CustomerID, i.[Year], i.[Month]
	                           ORDER BY i.InvoiceDate
							   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) CumulativeTotal
  from Sales i 
join Sales.Customers c on c.CustomerID = i.CustomerID 
order by i.InvoiceDate, c.CustomerName 

/*Запрос 2 выполняется чуть быстрее - 
Table 'Invoices'. Scan count 1, logical reads 11400 против Table 'Invoices'. Scan count 2, logical reads 22800 для первого запроса
и ожидаемая стоимоть запроса меньше*/


/*3. Вывести список 2х самых популярных продуктов (по кол-ву проданных) в каждом месяце за 2016-й год (по 2 самых популярных продукта в каждом месяце)*/
 
 ;with Sales as (
select il.StockItemID
     , FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU') [MonthName]
	 , MONTH (i.InvoiceDate) [Month]
	 , sum(il.Quantity) Quantity 	 
	 , ROW_NUMBER() OVER (PARTITION BY MONTH (i.InvoiceDate) ORDER BY sum(il.Quantity) DESC ) AS rn 
 from Sales.Invoices i
   join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
where YEAR(i.InvoiceDate) = 2016
group by il.StockItemID, FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU'), MONTH (i.InvoiceDate)
) 
select i.[MonthName],
       si.[StockItemName],
	   i.Quantity
  from Sales i JOIN Warehouse.[StockItems] si on si.StockItemID = i.StockItemID
where i.rn <= 2
 ORDER BY i.[Month], si.[StockItemName]
  

;with Sales as (
select il.StockItemID
     , FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU') [MonthName]
	 , MONTH (i.InvoiceDate) [Month]
	 , sum(il.Quantity) Quantity 	 
 from Sales.Invoices i
   join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
where YEAR(i.InvoiceDate) = 2016
group by il.StockItemID, FORMAT(i.InvoiceDate, 'MMMM', 'ru-RU'), MONTH (i.InvoiceDate)
)
select i.[MonthName],
       si.[StockItemName],
	   i.Quantity
  from Sales i JOIN Warehouse.[StockItems] si on si.StockItemID = i.StockItemID  
  where i.StockItemID IN (SELECT top 2 ii.StockItemID 
                            FROM Sales ii 
						   WHERE ii.[Month] = i.[Month] 
					       ORDER BY Quantity desc) 
ORDER BY i.[Month], si.[StockItemName]


/*4. Функции одним запросом
Посчитайте по таблице товаров, 
в вывод также должен попасть ид товара, название, брэнд и цена
пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
посчитайте общее количество товаров и выведете полем в этом же запросе
посчитайте общее количество товаров в зависимости от первой буквы названия товара
отобразите следующий id товара исходя из того, что порядок отображения товаров по имени
предыдущий ид товара с тем же порядком отображения (по имени)
названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
сформируйте 30 групп товаров по полю вес товара на 1 шт
Для этой задачи НЕ нужно писать аналог без аналитических функций*/

select si.StockItemID
     , si.StockItemName
	 , si.[Brand]
	 , si.UnitPrice
	 , ROW_NUMBER() over (order by si.StockItemName) RowNum
	 , ROW_NUMBER() over (partition by substring(si.StockItemName,1,1) order by si.StockItemName) RowNum2
	 , count(*) over() TotalItems
	 , count(*) over(partition by substring(si.StockItemName,1,1)) TotalItems2 
	 , LEAD(si.StockItemID) over (order by si.StockItemName) NextStockItemID
	 , LAG(si.StockItemID) over (order by si.StockItemName)  PrevStockItemID
	 , LAG(si.StockItemName, 2, N'No items') over(order by si.StockItemName) PrevStockItemName
	 , NTILE(30) OVER(ORDER BY si.[TypicalWeightPerUnit]) GroupTypicalWeightPerUnit
	 , si.[TypicalWeightPerUnit]
  from Warehouse.[StockItems] si
order by GroupTypicalWeightPerUnit, si.StockItemName


/*
5. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал
В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки
*/

 ;with  LastInvoices as (
 select top(1) with ties  
Invoices.InvoiceID, Invoices.SalespersonPersonID, Invoices.CustomerID, Invoices.InvoiceDate, 
row_number() OVER (partition by Invoices.SalespersonPersonID order by Invoices.InvoiceDate desc) rn
from Sales.Invoices
order by row_number() OVER (partition by Invoices.SalespersonPersonID order by Invoices.InvoiceDate desc) 
 ) 
select   
       p.PersonID
     , p.FullName 
     , i.CustomerID
	 , c.CustomerName
	 , i.InvoiceDate 
	 , sum(il.Quantity * il.UnitPrice) SalesSum
  from [Application].[People] p
      left join LastInvoices i on i.SalespersonPersonID = p.PersonID 
	  left join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID 
	  left join Sales.Customers c on c.CustomerID = i.CustomerID
 where  p.IsSalesperson = 1 
group by p.PersonID
     , p.FullName 
     , i.CustomerID
	 , c.CustomerName
	 , i.InvoiceDate 

/*6. Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки
*/

--SET STATISTICS IO, TIME ON;
--GO

 ;with Sales as (
select il.StockItemID
     , i.InvoiceDate 
	 , i.CustomerID
	 , max(il.UnitPrice)  UnitPrice  
	 , ROW_NUMBER() OVER (PARTITION BY i.CustomerID ORDER BY max(il.UnitPrice) DESC ) AS rn 
 from Sales.Invoices i
   join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
where YEAR(i.InvoiceDate) = 2016
group by il.StockItemID
     , i.InvoiceDate 
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


 /*
Опционально можно сделать вариант запросов для заданий 2,5,6 без использования windows function и сравнить скорость как в задании 1.
-- 
-- Выбираю задание 6
*/

 ;with Sales as (
select il.StockItemID
     , i.InvoiceDate 
	 , i.CustomerID
	 , max(il.UnitPrice)     UnitPrice    
 from Sales.Invoices i
   join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
where YEAR(i.InvoiceDate) = 2016
group by il.StockItemID
     , i.InvoiceDate 
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
where EXISTS
          ( SELECT G.*
		      FROM (SELECT TOP 2 ii.StockItemID, ii.InvoiceDate,i.UnitPrice  FROM Sales ii WHERE ii.CustomerID = i.CustomerID ORDER BY ii.UnitPrice desc) G
			 WHERE G.StockItemID = i.StockItemID and G.InvoiceDate = i.InvoiceDate and G.UnitPrice = i.UnitPrice
			 ) 
 ORDER BY c.CustomerName, i.UnitPrice desc, si.[StockItemName] 
 

 /*
 Итог выполнения с включенным SET STATISTICS IO, TIME ON;

 запрос с  windows function:

 SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

(1326 rows affected)
Table 'InvoiceLines'. Scan count 2, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 161, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'InvoiceLines'. Segment reads 1, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Invoices'. Scan count 1, logical reads 11400, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Customers'. Scan count 1, logical reads 40, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'StockItems'. Scan count 1, logical reads 6, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 31 ms,  elapsed time = 141 ms.


 запрос без windows function:

SQL Server parse and compile time: 
   CPU time = 31 ms, elapsed time = 37 ms.

(1326 rows affected)
Table 'InvoiceLines'. Scan count 438087, logical reads 5266800, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 161, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'InvoiceLines'. Segment reads 1, segment skipped 0.
Table 'Worktable'. Scan count 29427, logical reads 255926, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Invoices'. Scan count 2, logical reads 22800, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Customers'. Scan count 1, logical reads 40, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'StockItems'. Scan count 1, logical reads 6, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 5579 ms,  elapsed time = 5582 ms.

 Первый запрос работает быстрее,
 второй запрос работает медленнее Table 'Invoices' - SQL Server делает больше чтений, что бы отфильтровать данные
 
 */



/*
Bonus из предыдущей темы
Напишите запрос, который выбирает 10 клиентов, которые сделали больше 30 заказов и последний заказ был не позднее апреля 2016
*/
select top(10)  
       o.CustomerID, 
	   c.CustomerName,
	   count(o.OrderID) CountOrders, 
	   max(o.OrderDate) LastOrderDate
  from [Sales].[Orders] o
    JOIN Sales.Customers c on c.CustomerID = o.CustomerID
group by o.CustomerID, c.CustomerName
having count(o.OrderID) > 30 and max(o.OrderDate) >= '20160401'

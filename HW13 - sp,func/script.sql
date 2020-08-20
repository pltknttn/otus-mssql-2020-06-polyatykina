use WideWorldImporters
go

/*Написать хранимую процедуру возвращающую Клиента с набольшей разовой суммой покупки*/
create or alter procedure [Reports].p_GetClientWithHighestOneTimePurchase 
as
begin
    set nocount on; 

    select top 1 
	       c.CustomerID,
	       c.CustomerName,
		   sum(il.Quantity * il.UnitPrice) SumSale,
		   max(i.InvoiceDate) LastInvoiceDate
	  from Sales.Customers c
      left join Sales.Invoices i on i.CustomerID = c.CustomerID
      left join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID 
	group by c.CustomerID, c.CustomerName, i.InvoiceID
	order by SumSale desc;
	return;
end
go

/*
1) Написать функцию возвращающую Клиента с набольшей суммой покупки.
*/
 

create or alter function [Reports].f_GetCustomerWithMaxSumSale()
returns int
as
BEGIN 
    return (select TOP 1 FIRST_VALUE(i.CustomerID) OVER(ORDER BY sum(il.Quantity * il.UnitPrice) DESC) 
	         from Sales.Invoices i 
			     join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID 
		    group by i.CustomerID);
END
GO

SELECT [Reports].f_GetSuperCustomer()
go
/*
2) Написать хранимую процедуру с входящим параметром
СustomerID, выводящую сумму покупки по этому клиенту.
Использовать таблицы :
Sales.Customers
Sales.Invoices
Sales.InvoiceLines
*/
create or alter procedure [Reports].p_GetSaleInfo (@CustomerID int)
as
begin
    set nocount on; 

    select c.CustomerID,
	       c.CustomerName,
		   sum(il.Quantity * il.UnitPrice) SumSale,
		   max(i.InvoiceDate) LastInvoiceDate
	  from Sales.Customers c
      left join Sales.Invoices i on i.CustomerID = c.CustomerID
      left join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
	where c.CustomerID = @CustomerID 
	group by c.CustomerID, c.CustomerName;
	return;
end
go

declare @CustomerId int = [Reports].f_GetCustomerWithMaxSumSale();
exec [Reports].p_GetSaleInfo  @CustomerId
go

/*
3) Создать одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему.
*/

create or alter function [Reports].f_GetCustomerWithMinSumSale()
returns int
as
BEGIN 
    return (select TOP 1 FIRST_VALUE(i.CustomerID) OVER(ORDER BY sum(il.Quantity * il.UnitPrice) ASC) 
	         from Sales.Invoices i 
			     join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID 
		    group by i.CustomerID);
END
GO

create or alter procedure [Reports].p_GetCustomerWithMinSumSale
as
begin
    set nocount on; 

	select TOP 1 i.CustomerID 
	  from Sales.Invoices i 
	  join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
	 group by i.CustomerID
	 order BY sum(il.Quantity * il.UnitPrice) asc; 

	return;
end
go

create or alter procedure [Reports].p_GetCustomerWithMinSumSale_v2(@CustomerID int output)
as
begin
    set nocount on; 
	 
	select TOP 1 @CustomerID = i.CustomerID 
	  from Sales.Invoices i 
	  join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID
	 group by i.CustomerID
	 order BY sum(il.Quantity * il.UnitPrice) asc; 

	return;
end
go

SET STATISTICS IO, TIME ON;
GO
BEGIN

select [Reports].f_GetCustomerWithMinSumSale() CustomerID option(recompile)
/* SQL Server Execution Times:
   CPU time = 47 ms,  elapsed time = 57 ms.*/

declare @tab table (CustomerID int)
insert into @tab exec [Reports].p_GetCustomerWithMinSumSale
/*
-- отрабатывает вычисление внутри процедуры, exec [Reports].p_GetCustomerWithMinSumSale
 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
Table 'InvoiceLines'. Scan count 2, logical reads 0, physical reads 0
Table 'InvoiceLines'. Segment reads 1, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, 
Table 'Invoices'. Scan count 1, logical reads 166, physical reads 0, 

 SQL Server Execution Times:
   CPU time = 47 ms,  elapsed time = 64 ms.
-----------------------------------------------------------------------------------------

-- результат выполненя процедуры помещается в темп 'Worktable'
-- в этом месте у нас идет вставка в insert into @tab, @tab = #AE4E3493
 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
Table '#AC65EC21'. Scan count 0, logical reads 1, physical reads 0
Table 'Worktable'. Scan count 1, logical reads 5, physical reads 0
*/
select CustomerID from @tab
/*
-- вывод результата из таблички
 SQL Server Execution Times:
   CPU time = 47 ms,  elapsed time = 117 ms.

(1 row affected)
Table '#AC65EC21'. Scan count 1, logical reads 1, physical reads 0
*/

declare @CustomerID int
exec [Reports].p_GetCustomerWithMinSumSale_v2 @CustomerID output
select @CustomerID
/*
-- выполнили процедуру
 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
Table 'InvoiceLines'. Scan count 2, logical reads 0
Table 'InvoiceLines'. Segment reads 1, segment skip
Table 'Worktable'. Scan count 0, logical reads 0,  
Table 'Invoices'. Scan count 1, logical reads 166, 

SQL Server Execution Times:
   CPU time = 62 ms,  elapsed time = 63 ms.

-- показали результат
SQL Server Execution Times:
   CPU time = 62 ms,  elapsed time = 69 ms.
*/

/*В данном случае функцию использовать выгоднее, так как она быстрее, в сравнении с 1ой процедурой меньше логических чтени и меньше tempdb использовали,
в сранении со 2ой процедурой то здесь уже преимущество минимально, запись более компактная если только и читабельнее (но помним о скрытой реализации).
так как вычисляется клиент с минимальной суммой покупки - некая скалярная величина, то в зависимости от требований бизнеса можно использовать функцию.
 
- минусы функции - что происходит в запросе внутри скрыто, сколько внутри ф-ции обрабатывается данных тоже скрыто.
  Поэтому когда используются ф-ции нужно всегда анализировать запрос внутри ф-ции и оптимизировать его отдельно.
  В запросах ф-ция вычисляется для каждой строки, поэтому при отладке запроса нужно обращать внимание на производительность используемых ф-ций.
  Хорошо отлаженные функции можно использовать  
  в некоторой степени ф-ция в select это как вложенный запрос, но при этом оптимизатор не пытается придумать оптимальный план с учетом таблиц из этого запроса, 
  для оптимизатора это вычисляемый столбец.

- процедура -  когда надо передавать данные из процедуры в промещуточную таблицу может потратить много ресурсов на больших объемах, т.к. 
  сначала положили результат выполнения в temp, затем его перекопировали и это тоже время.
*/
END
GO

SET STATISTICS IO, TIME OFF;
GO

/*
4) Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла.
*/
create or alter function [Reports].f_GetSaleInfo( @CustomerID int)
returns table  
as
RETURN (
    select sum(il.Quantity * il.UnitPrice) SumSale,
		   max(i.InvoiceDate) LastInvoiceDate
	  from Sales.Invoices i  
      join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID 
	where i.CustomerID= @CustomerID 
	);  
GO
 
/*вариант 1*/
select c.CustomerID,
       c.CustomerName,
	   (select top 1 SumSale from [Reports].f_GetSaleInfo(c.CustomerID)) SumSale
  from Sales.Customers c

 /*вариант 2*/
select c.CustomerID,
       c.CustomerName,
	   i.SumSale,
	   i.LastInvoiceDate
  from Sales.Customers c
  outer apply [Reports].f_GetSaleInfo(c.CustomerID) i
   
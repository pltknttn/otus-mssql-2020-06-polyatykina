use [WideWorldImporters]
go

/*SQL SERVER 2019*/

/*--------------------------------------------------------------------------------------------------


3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей из Sales.CustomerTransactions. Представьте несколько способов (в том числе с CTE).*/
/*!!! Трактовать задание можно по разному, поэтому делаю несколько вариантов !!!*/
/*!!! "Выберите информацию по клиентам" -  нет контретики, поэтому предполагаю что можно вывести название клиента и к примеру максимальную сумму. !!!*/

/*вариант 1. в задании речь идет о 5 максимальных суммах.*/
 

 select ct.CustomerID, c.CustomerName, max(ct.TransactionAmount) MaxTransactionAmount
  from Sales.CustomerTransactions ct 
      join [Sales].[Customers] c on c.CustomerID = ct.CustomerID
 where ct.TransactionAmount >= ANY(select distinct top 5 TransactionAmount from Sales.CustomerTransactions order by TransactionAmount desc)
 group by ct.CustomerID, c.CustomerName
 
 select ct.CustomerID, c.CustomerName, max(ct.TransactionAmount) MaxTransactionAmount
  from Sales.CustomerTransactions ct 
      join [Sales].[Customers] c on c.CustomerID = ct.CustomerID
	  join (select distinct top 5 TransactionAmount from Sales.CustomerTransactions order by TransactionAmount desc) ta on ta.TransactionAmount = ct.TransactionAmount 
 group by ct.CustomerID, c.CustomerName
  
 ;with TA as (select distinct top 5 TransactionAmount from Sales.CustomerTransactions order by TransactionAmount desc)
  select ct.CustomerID, c.CustomerName, max(ct.TransactionAmount) MaxTransactionAmount
  from Sales.CustomerTransactions ct 
      join [Sales].[Customers] c on c.CustomerID = ct.CustomerID
	  join TA on ta.TransactionAmount = ct.TransactionAmount 
 group by ct.CustomerID, c.CustomerName

/*вариант 2. " пять максимальных платежей" = 5 платежей с самой большой суммой платежа*/
 
 select ct.CustomerID, c.CustomerName, ct.TransactionAmount MaxTransactionAmount
   from Sales.CustomerTransactions ct 
       join [Sales].[Customers] c on c.CustomerID = ct.CustomerID
   where ct.TransactionAmount = (select max(TransactionAmount) from Sales.CustomerTransactions ct)
   group by ct.CustomerID, c.CustomerName, ct.TransactionAmount
   having count(*) = 5
 
;with CT as (select ct.CustomerID, max(ct.TransactionAmount) MaxTransactionAmount, count(ct.TransactionAmount) CountTransactionAmount
              from Sales.CustomerTransactions ct  
			 group by ct.CustomerID )
select ct.CustomerID, c.CustomerName, ct.MaxTransactionAmount
  from  [Sales].[Customers] c
     join CT on ct.CustomerID = c.CustomerID and ct.CountTransactionAmount = 5
  where ct.MaxTransactionAmount >= ALL(select MaxTransactionAmount from CT)


/*вариант 3. 5 максимальных сумм, "Выберите информацию по клиентам" = ид клиента */
 
 select distinct ct.CustomerID 
  from Sales.CustomerTransactions ct 
      join [Sales].[Customers] c on c.CustomerID = ct.CustomerID
 where ct.TransactionAmount >= ANY(select distinct top 5 TransactionAmount from Sales.CustomerTransactions order by TransactionAmount desc) 
 
 select distinct ct.CustomerID 
  from Sales.CustomerTransactions ct 
      join [Sales].[Customers] c on c.CustomerID = ct.CustomerID
	  join (select distinct top 5 TransactionAmount from Sales.CustomerTransactions order by TransactionAmount desc) ta on ta.TransactionAmount = ct.TransactionAmount  
 
 ;with TA as (select distinct top 5 TransactionAmount from Sales.CustomerTransactions order by TransactionAmount desc)
  select distinct ct.CustomerID 
  from Sales.CustomerTransactions ct 
      join [Sales].[Customers] c on c.CustomerID = ct.CustomerID
	  join TA on ta.TransactionAmount = ct.TransactionAmount  
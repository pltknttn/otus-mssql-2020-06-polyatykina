use [WideWorldImporters]
go

/*SQL SERVER 2019*/

/*-------------------------------------------------------------------------------------------------- 


1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), и не сделали ни одной продажи 04 июля 2015 года. 
Вывести ИД сотрудника и его полное имя. 
Продажи смотреть в таблице Sales.Invoices.*/
 
select p.PersonID, p.FullName 
  from [Application].[People] p 
  where p.IsSalesperson = 1 
    and p.PersonID not in (select i.SalespersonPersonID from Sales.Invoices i where i.InvoiceDate = '20150704')
 
 ;with Orders as (select i.SalespersonPersonID from Sales.Invoices i where i.InvoiceDate = '20150704')
select p.PersonID, p.FullName 
  from [Application].[People] p 
  where p.IsSalesperson = 1 
    and not exists (select o.SalespersonPersonID from Orders o where o.SalespersonPersonID = p.PersonID)
 
 ;with Orders as (select i.SalespersonPersonID from Sales.Invoices i where i.InvoiceDate  = '20150704')
select p.PersonID, p.FullName 
  from [Application].[People] p 
  where p.IsSalesperson = 1 
    and NOT p.PersonID = ANY(select o.SalespersonPersonID from Orders o )
 
 select p.PersonID, p.FullName 
  from [Application].[People] p
     left join [Sales].Invoices i on i.SalespersonPersonID = p.PersonID and i.InvoiceDate = '20150704'
  where p.IsSalesperson = 1 and i.OrderID is null
    
;with Orders as (select i.SalespersonPersonID from Sales.Invoices i where i.InvoiceDate  = '20150704')
select p.PersonID, p.FullName 
  from [Application].[People] p
      left join Orders o on o.SalespersonPersonID = p.PersonID
  where p.IsSalesperson = 1 and o.SalespersonPersonID is null




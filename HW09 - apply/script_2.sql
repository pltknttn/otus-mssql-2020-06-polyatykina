/*
2. Для всех клиентов с именем, в котором есть Tailspin Toys
вывести все адреса, которые есть в таблице, в одной колонке

Пример результатов
CustomerName AddressLine
Tailspin Toys (Head Office) Shop 38
Tailspin Toys (Head Office) 1877 Mittal Road
Tailspin Toys (Head Office) PO Box 8975
Tailspin Toys (Head Office) Ribeiroville
.....
*/

use [WideWorldImporters]
go

select unpvt.CustomerName, unpvt.AddressLine
 from (
select 
      CustomerName,
      DeliveryAddressLine1,
	  DeliveryAddressLine2,
	  PostalAddressLine1,
	  PostalAddressLine2
from Sales.Customers
where CustomerName like '%Tailspin Toys%'
) p UNPIVOT (AddressLine for Name in (DeliveryAddressLine1, DeliveryAddressLine2, PostalAddressLine1, PostalAddressLine2)) unpvt

use WideWorldImporters
go

SET STATISTICS IO, TIME ON;
GO

exec dbo.CustomerSearch_KitchenSinkOtus 149;
/*
cost = 82% и сложный план выполнени¤
 
Table 'Cities'. Scan count 0, logical reads 2, physical reads 0
Table 'People'. Scan count 0, logical reads 2, physical reads 0
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0
Table 'Customers'. Scan count 1, logical reads 6, physical reads 0
*/

exec dbo.CustomerSearch_KitchenSink 149;
/*
cost = 18%, план менее ветвистый и читабельный
 
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0
Table 'Customers'. Scan count 0, logical reads 2, physical reads 0

меньше таблиц обрабатываем 
*/
--------------------------------------------------------------



 exec dbo.CustomerSearch_KitchenSinkOtus;
 /*
 Cost = 32%
 
 Table 'Cities'. Scan count 0, logical reads 1326, physical reads 60
 Table 'People'. Scan count 0, logical reads 1326, physical reads 8
 Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0
 Table 'Customers'. Scan count 1, logical reads 1330, physical reads 0 

  SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 117 ms.
 */

 exec dbo.CustomerSearch_KitchenSink;

 /*
  Cost = 68%
 Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0
 Table 'Customers'. Scan count 1, logical reads 40, physical reads 0

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 129 ms.
 */
 --------------------------------------------------------------------------------


 exec dbo.CustomerSearch_KitchenSinkOtus
  @CustomerID            = NULL,
  @CustomerName          = NULL,
  @BillToCustomerID      = NULL,
  @CustomerCategoryID    = NULL,
  @BuyingGroupID         = NULL,
  @MinAccountOpenedDate  = NULL,
  @MaxAccountOpenedDate  = NULL,
  @DeliveryCityID        = NULL,
  @IsOnCreditHold        = NULL,
  @OrdersCount			 = 45, 
  @PersonID				 = NULL, 
  @DeliveryStateProvince = NULL,
  @PrimaryContactPersonIDIsEmployee = NULL;
  /*
 Cost = 39%
  Table 'Cities'. Scan count 0, logical reads 1341, 
  Table 'People'. Scan count 0, logical reads 1341, 
  Table 'Orders'. Scan count 663, logical reads 1549
  Table 'Worktable'. Scan count 0, logical reads 0, 
  Table 'Customers'. Scan count 1, logical reads 40,
  
   SQL Server Execution Times:
   CPU time = 16 ms,  elapsed time = 106 ms.
  */


 exec dbo.CustomerSearch_KitchenSink
  @CustomerID            = NULL,
  @CustomerName          = NULL,
  @BillToCustomerID      = NULL,
  @CustomerCategoryID    = NULL,
  @BuyingGroupID         = NULL,
  @MinAccountOpenedDate  = NULL,
  @MaxAccountOpenedDate  = NULL,
  @DeliveryCityID        = NULL,
  @IsOnCreditHold        = NULL,
  @OrdersCount			 = 45, 
  @PersonID				 = NULL, 
  @DeliveryStateProvince = NULL,
  @PrimaryContactPersonIDIsEmployee = NULL;

/*
 Cost = 61%

Table 'Workfile'. Scan count 0, logical reads 0, 
Table 'Worktable'. Scan count 0, logical reads 0,
Table 'Cities'. Scan count 0, logical reads 1376,
Table 'People'. Scan count 0, logical reads 1376,
Table 'Worktable'. Scan count 0, logical reads 0,
Table 'Customers'. Scan count 1, logical reads 40
Table 'Orders'. Scan count 1, logical reads 191, 


 SQL Server Execution Times:
   CPU time = 15 ms,  elapsed time = 114 ms.
*/
-----------------------------------------------------------------


/*ради интереса есть ли разница isnull vs ( or ) сделала еще процедуру*/
 exec dbo.CustomerSearch_KitchenSink_v2
  @CustomerID            = NULL,
  @CustomerName          = NULL,
  @BillToCustomerID      = NULL,
  @CustomerCategoryID    = NULL,
  @BuyingGroupID         = NULL,
  @MinAccountOpenedDate  = NULL,
  @MaxAccountOpenedDate  = NULL,
  @DeliveryCityID        = NULL,
  @IsOnCreditHold        = NULL,
  @OrdersCount			 = 45, 
  @PersonID				 = NULL, 
  @DeliveryStateProvince = NULL,
  @PrimaryContactPersonIDIsEmployee = NULL;

/*
Table 'People'. Scan count 0, logical reads 804, physical reads 0, 
Table 'Cities'. Scan count 0, logical reads 804, physical reads 0
Table 'Orders'. Scan count 402, logical reads 945, physical reads 0, 
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, 
Table 'Customers'. Scan count 1, logical reads 1330, physical reads 0

 SQL Server Execution Times:
   CPU time = 31 ms,  elapsed time = 149 ms.

-- выходит что несмотр¤ на соблазн написать isnull лучше писать ( or )
*/

 exec dbo.CustomerSearch_KitchenSink_v2;
 /*
 Table 'People'. Scan count 0, logical reads 804, physical reads 0, 
 Table 'Cities'. Scan count 0, logical reads 804, physical reads 0, 
 Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, 
 Table 'Customers'. Scan count 1, logical reads 1330, physical reads 0


 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 101 ms.

*/

exec dbo.CustomerSearch_KitchenSink_v2 149;
/*
Table 'People'. Scan count 0, logical reads 2, physical reads 0, 
Table 'Cities'. Scan count 0, logical reads 2, physical reads 0, 
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0,
Table 'Customers'. Scan count 1, logical reads 6, physical reads 0,

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 53 ms.
*/

-- isnull не ухудшил ( or ), зато читабельнее

/*ѕо данному примеру отус - dynamic, на мой взгл¤д несмотр¤ на много условий работает лучше чем dynamic, минусы сложный план запроса, плюсы прогнозируема¤ сложность выполнени¤.
¬ dynamic план и сложность запроса растет в зависимости от количества параметров, что несет в себе скрытое неизвестное 
ќднако в нашем случае это простой пример и join двух таблиц с агрегацией по третьей, 
в зависимости от цели и структуры может быть и будет плюс, но ¤ бы предпочла ¤вный запрос
*/

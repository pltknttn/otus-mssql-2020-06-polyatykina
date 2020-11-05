use WideWorldImporters
go

-- наполним данные для запроса
if (select count(*) from Application.BrokerTask) = 0
begin
	;with InvoicesCustomers as (
	select CustomerID ClientId, min(InvoiceDate) DateFrom, max(InvoiceDate) DateTo
	  from Sales.Invoices
	group by CustomerID
	)
	insert into Application.BrokerTask(TaskTypeId, Request)
	select cast(1 as int) TaskTypeId,
		  (select ClientId '@ClientId', DateFrom '@DateFrom', case when DateTo = DateFrom then cast(null as date) else  DateTo end '@DateTo' 
			 from InvoicesCustomers Clients
			 where Clients.ClientId = f.CustomerID
			FOR XML path('Client'), root('Report')) Request
	  from Sales.Customers f
end

select * from Application.BrokerTask   

declare @StartTaskId int = 10,
        @CountWork int = 1,
		@TaskId int = 0
while(@CountWork > 0)
begin
    set @TaskId = @StartTaskId + 1
	set @CountWork -= 1
		
	select * from Application.BrokerTask where Id = @TaskId
	if @@ROWCOUNT = 0 break;

	exec Application.SendNewBrokerTask @TaskId  
end

SELECT * FROM dbo.InitiatorQueueWWI;

SELECT *  FROM dbo.TargetQueueWWI; 
 
--запрос на просмотр открытых диалогов
SELECT conversation_handle, is_initiator, s.name as 'local service', 
far_service, sc.name 'contract', ce.state_desc
FROM sys.conversation_endpoints ce
LEFT JOIN sys.services s
ON ce.service_id = s.service_id
LEFT JOIN sys.service_contracts sc
ON ce.service_contract_id = sc.service_contract_id
ORDER BY conversation_handle;




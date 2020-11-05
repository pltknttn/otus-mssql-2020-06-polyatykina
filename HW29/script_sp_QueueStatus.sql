USE [WideWorldImporters];
go

CREATE OR ALTER PROCEDURE Application.GetBrokerTaskQueue 
as
begin
     SET NOCOUNT ON;

	 SELECT *  FROM dbo.InitiatorQueueWWI;

	 SELECT *  FROM dbo.TargetQueueWWI;

	 return (0) 
end
go

CREATE OR ALTER PROCEDURE Application.GetBrokerQueueStatus
as
begin
     SET NOCOUNT ON;

	SELECT * FROM sys.service_contract_message_usages; --Данное представление каталога содержит по одной строке для каждой пары (контракт, тип сообщения)
	SELECT * FROM sys.service_contract_usages; --Это представление каталога содержит строку для пары (служба, контракт).
	SELECT * FROM sys.service_queue_usages;--Это представление каталога возвращает по одной строке для каждой связи между службой и очередью службы.

	--системная очередь, содержащая текущие сообщения и ошибки 
	SELECT * FROM sys.transmission_queue;

	SELECT	conversation_handle, 
			is_initiator, 
			s.name as 'local service', 
			far_service, 
			sc.name 'contract', 
			ce.state_desc
	FROM sys.conversation_endpoints ce
	LEFT JOIN sys.services s
		ON ce.service_id = s.service_id
	LEFT JOIN sys.service_contracts sc
		ON ce.service_contract_id = sc.service_contract_id
	ORDER BY conversation_handle;

	return (0) 
end
go
use WideWorldImporters;
GO

DROP SERVICE [//WWI/SB/TargetService]
GO

DROP SERVICE [//WWI/SB/InitiatorService]
GO

DROP QUEUE [dbo].[TargetQueueWWI]
GO 

DROP QUEUE [dbo].[InitiatorQueueWWI]
GO

DROP CONTRACT [//WWI/SB/Contract]
GO

DROP MESSAGE TYPE [//WWI/SB/RequestMessage]
GO

DROP MESSAGE TYPE [//WWI/SB/ReplyMessage]
GO

DROP PROCEDURE IF EXISTS  Application.SendNewBrokerTask;
go

DROP PROCEDURE IF EXISTS  Application.GetNewBrokerTask;
go

DROP PROCEDURE IF EXISTS  Application.ConfirmBrokerTask;
go

DROP PROCEDURE IF EXISTS Application.BrokerCleantransmissionQueue;
go

DROP PROCEDURE IF EXISTS Application.GetBrokerTaskQueue;
go

DROP PROCEDURE IF EXISTS Application.GetBrokerQueueStatus;
go

DROP TABLE IF EXISTS Application.BrokerTask 
go

DROP TABLE IF EXISTS Application.BrokerTaskType
go

DROP TABLE IF EXISTS Application.BrokerTaskStatus
go 

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
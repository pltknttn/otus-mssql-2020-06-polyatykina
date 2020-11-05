USE [WideWorldImporters]
GO 

ALTER QUEUE [dbo].[InitiatorQueueWWI] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = OFF) 
	, ACTIVATION (   STATUS = ON ,
        PROCEDURE_NAME = Application.ConfirmBrokerTask, MAX_QUEUE_READERS = 100, EXECUTE AS OWNER) ; 
GO

ALTER QUEUE [dbo].[TargetQueueWWI] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = OFF)
	, ACTIVATION (  STATUS = ON ,
        PROCEDURE_NAME = Application.GetNewBrokerTask, MAX_QUEUE_READERS = 100, EXECUTE AS OWNER) ; 

GO 


use WideWorldImporters
go

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--процедура изначальной отправки запроса в очередь таргета
CREATE OR ALTER PROCEDURE Application.SendNewBrokerTask @TaskId INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

    --Sending a Request Message to the Target	
	DECLARE @InitDlgHandle UNIQUEIDENTIFIER; --open init dialog
	DECLARE @RequestMessage NVARCHAR(max); --сообщение, которое будем отправлять
	
	BEGIN TRAN  
	
	if isnull(@TaskId,0) = 0
	begin
	    select top 1 @TaskId = Id from Application.BrokerTask where TaskStatusId = 1 order by RequestDate asc
	end

	update Application.BrokerTask set TaskStatusId = 2, TaskStatusChangedDate = GETUTCDATE(), Reply = null, ReplyDate = null from Application.BrokerTask WHERE Id = @TaskId
		 
	SELECT @RequestMessage = (SELECT Id TaskId, TaskTypeId FROM Application.BrokerTask BrokerTask WHERE Id = @TaskId FOR XML AUTO, root('RequestMessage')); 
	
	--Determine the Initiator Service, Target Service and the Contract 
	BEGIN DIALOG @InitDlgHandle FROM SERVICE [//WWI/SB/InitiatorService] TO SERVICE '//WWI/SB/TargetService'
	ON CONTRACT [//WWI/SB/Contract] WITH ENCRYPTION=OFF; 
	 
	SEND ON CONVERSATION @InitDlgHandle  MESSAGE TYPE [//WWI/SB/RequestMessage] (@RequestMessage);
		 
	COMMIT TRAN; 

	select @RequestMessage RequestMessage; 
END
GO

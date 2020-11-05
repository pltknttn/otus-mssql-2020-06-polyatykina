use WideWorldImporters
go

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--процедура обработки очереди таргетом
CREATE OR ALTER PROCEDURE Application.GetNewBrokerTask
AS
BEGIN

    SET NOCOUNT ON;
	SET XACT_ABORT ON;

	DECLARE @TargetDlgHandle UNIQUEIDENTIFIER, --идентификатор диалога
			@Message NVARCHAR(max),--полученное сообщение
			@MessageType Sysname,--тип полученного сообщения
			@ReplyMessage NVARCHAR(max),--ответное сообщение
			@TaskId INT,
			@TaskTypeId INT,
			@xml XML,
			@TaskRequest NVARCHAR(max),
			@TaskReply   NVARCHAR(max); 
	
	BEGIN TRAN; 

	--Receive message from Initiator
	RECEIVE TOP(1)
		@TargetDlgHandle = Conversation_Handle,
		@Message = Message_Body,
		@MessageType = Message_Type_Name
	FROM dbo.TargetQueueWWI; 
	  
	SET @xml = CAST(@Message AS XML); 
	 
	--получаем TaskId из xml
	SELECT @TaskId = R.Iv.value('@TaskId','INT'), @TaskTypeId = R.Iv.value('@TaskTypeId','INT') FROM @xml.nodes('/RequestMessage/BrokerTask') as R(Iv);

	update bt set TaskStatusId = 3, TaskStatusChangedDate = GETUTCDATE() from Application.BrokerTask bt  WHERE bt.Id = @TaskId	
	 
	--обрабатываем запросы
	IF @TaskTypeId = 1
	BEGIN
		 select @TaskRequest = Request from Application.BrokerTask WHERE Id = @TaskId
		    SET @xml = CAST(@TaskRequest AS XML) 	
			
		 ;with Clients as (
		 select distinct 
		        f.x.value('@ClientId','INT') ClientId,
		        isnull(f.x.value('@DateFrom','datetime'), cast('19000101' as datetime)) DateFrom,
				isnull(f.x.value('@DateTo','datetime'), cast('50000101' as datetime)) DateTo 
		   from @xml.nodes('/Report/Client') as f(x)
		   )
		select @TaskReply = ( 
		select Client.ClientId, isnull(count(o.OrderID),0) CountOrders
		  from Clients Client
		    left join Sales.Orders o on o.CustomerID = Client.ClientId and o.OrderDate between Client.DateFrom and Client.DateTo
		 group by Client.ClientId
         FOR XML AUTO, root('Report'))

		update bt set Reply = @TaskReply, ReplyDate = GETUTCDATE(), TaskStatusId = 4, TaskStatusChangedDate = GETUTCDATE()
		  from Application.BrokerTask bt WHERE bt.Id = @TaskId	
	END;
			
	-- Confirm and Send a reply
	IF @MessageType=N'//WWI/SB/RequestMessage'
	BEGIN
	    SELECT @ReplyMessage = (SELECT Id TaskId, TaskTypeId FROM Application.BrokerTask BrokerTask WHERE Id = @TaskId FOR XML AUTO, root('ReplyMessage'));  
	
		SEND ON CONVERSATION @TargetDlgHandle MESSAGE TYPE [//WWI/SB/ReplyMessage] (@ReplyMessage); END CONVERSATION @TargetDlgHandle;--закроем диалог со стороны таргета
	END 
		
	COMMIT TRAN;

	SELECT @Message AS ReceivedRequestMessage, @MessageType MessageType, @ReplyMessage AS SentReplyMessage; --в лог. замедляет работу 
END
go
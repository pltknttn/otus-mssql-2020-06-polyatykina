use WideWorldImporters
go

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--процедура обработки очереди источника
CREATE OR ALTER PROCEDURE Application.ConfirmBrokerTask
AS
BEGIN
    SET NOCOUNT ON;
	SET XACT_ABORT ON;

	--Receiving Reply Message from the Target.	
	DECLARE @InitiatorReplyDlgHandle UNIQUEIDENTIFIER, --хэндл диалога
			@ReplyReceivedMessage NVARCHAR(1000),
			@TaskId INT,
			@xml XML
	
	BEGIN TRAN; 

	--получим сообщение из очереди инициатора
		RECEIVE TOP(1)
			 @InitiatorReplyDlgHandle=Conversation_Handle
			,@ReplyReceivedMessage=Message_Body
		FROM dbo.InitiatorQueueWWI; 
		
		END CONVERSATION @InitiatorReplyDlgHandle; --закроем диалог со стороны инициатора
		 
		SET @xml = CAST(@ReplyReceivedMessage AS XML); 
	 
	    --получаем TaskId из xml
	    SELECT @TaskId = R.Iv.value('@TaskId','INT')  FROM @xml.nodes('/ReplyMessage/BrokerTask') as R(Iv);

	   update bt set TaskStatusId = 5, TaskStatusChangedDate = GETUTCDATE() from Application.BrokerTask bt  WHERE bt.Id = @TaskId	
			   
	COMMIT TRAN; 

	SELECT @ReplyReceivedMessage AS ReceivedRepliedMessage; --в консоль

END
GO



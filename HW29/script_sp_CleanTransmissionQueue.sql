USE [WideWorldImporters];
go

CREATE OR ALTER PROCEDURE Application.BrokerCleantransmissionQueue @Conversation uniqueidentifier = null
as
begin
	SET NOCOUNT ON;
     
	if @Conversation is null
	begin
		WHILE EXISTS(SELECT 1 FROM sys.transmission_queue)
		BEGIN
		  --sys.transmission_queue системная очередь, содержаща¤ текущие сообщения и ошибки
		  SET @Conversation =  (SELECT TOP(1) conversation_handle  FROM sys.transmission_queue);
		  END CONVERSATION @Conversation WITH CLEANUP;
		END;
	end
	else
	begin if EXISTS(SELECT 1 FROM sys.transmission_queue where conversation_handle = @Conversation)
	    END CONVERSATION @Conversation WITH CLEANUP;
	end 

	return (0)
end
go

 
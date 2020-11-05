USE WideWorldImporters;
GO

/*создаем очереди и сервисы для обслуживания очередей
будет обмен по принципу "источник - цель(приемник)"
*/

--создаем очередь приемника
CREATE QUEUE TargetQueueWWI;

--создаем сервис обслуживающий очередь приемника
CREATE SERVICE [//WWI/SB/TargetService]  ON QUEUE TargetQueueWWI ([//WWI/SB/Contract]);
GO

--создаем очередь для источника
CREATE QUEUE InitiatorQueueWWI;

--создаем сервис обслуживающий очередь источника
CREATE SERVICE [//WWI/SB/InitiatorService]  ON QUEUE InitiatorQueueWWI ([//WWI/SB/Contract]);
GO

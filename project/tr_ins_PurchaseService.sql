use FitnessClub
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or alter TRIGGER tr_ins_PurchaseService ON dbo.PurchaseService AFTER insert, update
AS 
BEGIN 
	SET NOCOUNT ON;
	 
	 /*≈сли не успели использовать услуги, то при следующей покупке этой же услуги восстановим остатки*/
	 ;with PeopleService as (select distinct PeopleId, SeviceId from inserted where cast(PaitDate as date) =  cast(getdate() as date))
	    update PurchaseService set DateEnd = DATEADD(day, s.Term/2 + 1, getdate())
		   from PurchaseService ps 
			 join PeopleService people on people.PeopleId = ps.PeopleId and people.SeviceId = ps.SeviceId
			 join uv_ClientPurshaseService hs on hs.PurchaseId = ps.Id  and hs.Active = 0  and hs.Frozen = 0 and hs.LeftQuantity > 0	
			 join Service s on s.Id = ps.SeviceId
END
GO

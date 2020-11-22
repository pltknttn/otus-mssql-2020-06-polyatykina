use FitnessClub
go

create or alter view uv_ClientPurshaseService
as 
select ps.Id               PurchaseId,
       max(ps.Date)        PurchaseDate,
	   ps.PeopleId         PeopleId,
       max(ps.SeviceId)    SeviceId,
	   max(co.Quantity)    Quantity,
       sum(co.Quantity)    UsedQuantity,
	   max(co.Quantity) - sum(co.Quantity) LeftQuantity,
	   a.Id                AgreementId, 
	   a.Frozen            Frozen,
	   max(ps.DateStart)                     DateStart,
	   isnull(ps.DateEnd, a.PeriodEnd)       DateEnd,
	   ps.PaitDate                           PaitDate,
	   IIF(a.Frozen = 0 and ps.PaitDate is not null and dbo.f_GetCurrentAgreement(ps.PeopleId) > 0 
	   and  dbo.f_GetCurrentDay()  <= coalesce(ps.DateEnd, a.PeriodEnd, dbo.f_GetMaxDay()), 1, 0) Active	    
  from  dbo.PurchaseService ps  
	join dbo.CheckOperation co on co.PurchaseId = ps.Id 
	join dbo.Agreement a on a.PeopleId = ps.PeopleId and ps.Date between a.PeriodStart and isnull(a.PeriodEnd, dbo.f_GetMaxDay())
group by ps.Id, a.Id, a.Frozen, ps.PeopleId, ps.PaitDate, ps.DateEnd, a.PeriodEnd
go
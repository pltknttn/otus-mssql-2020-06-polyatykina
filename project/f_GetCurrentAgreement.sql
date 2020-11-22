use FitnessClub
go

create or alter function dbo.f_GetCurrentAgreement (@PeopleId int)
returns int
as
begin
    return (select max(a.Id) from dbo.Agreement a 
	        where a.PeopleId = @PeopleId and dbo.f_GetCurrentDay() between a.PeriodStart and isnull(a.PeriodEnd, dbo.f_GetMaxDay()) );
end
go

--select dbo.f_GetCurrentAgreement(1)
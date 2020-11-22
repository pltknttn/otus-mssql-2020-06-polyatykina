use FitnessClub
go

create or alter function dbo.f_GetCurrentDay()
returns date
as
begin
    return cast(getdate() as date)
end
go

create or alter function dbo.f_GetMinDay()
returns date
as
begin
    return cast(0 as datetime)
end
go
 

create or alter function dbo.f_GetMaxDay()
returns date
as
begin
    return '50000101'
end
go

--select dbo.f_GetCurentDay(), dbo.f_GetMinDay(), dbo.f_GetMaxDay()
use FitnessClub
go

create or alter procedure p_SaveMaterialCategory
@Id int,
@Name nvarchar(150)
as
declare @msg nvarchar(255)
begin
     set @Id = isnull(@Id,0) 

	 if exists(select * from MaterialCategory where Name = @Name and Id <> @Id)
	 begin 
	     set @msg = 'Категория "'+@Name+'" уже существует!';
	     raiserror(@msg,16,1)
		 return (-1)
	 end

    ;merge MaterialCategory t
	 using (select @Id Id,
	              @Name Name 
	       ) s on s.Id = t.Id
    when matched then update set Name = s.Name 
	when not matched then insert (Name) values(s.Name);
	return (0)
end
go

create or alter procedure p_DeleteMaterialCategory @Id int
as
begin
     if exists(select * from Material where CategoryId = @Id)
	 begin 
	     raiserror('Категория используется в материалах!',16,1)
		 return (-1)
	 end 

	 delete from MaterialCategory where Id = @Id
end
go

create or alter procedure p_SaveMaterial
@Id int = 0,
@Name nvarchar(150),
@CategoryId int,
@Price decimal(16,2) = 0,
@Description  nvarchar(300) = null
as
declare @msg nvarchar(255)
begin      
     if @CategoryId is null or not exists(select * from MaterialCategory where Id = @CategoryId)
	 begin 
	     raiserror('Категория не существует!',16,1)
		 return (-1)
	 end
	 
	 set @Id = isnull(@Id,0)
	 set @Price = isnull(@Price,0)

	 if @Id <> 0 and not exists(select * from Material where Id = @Id)
	 begin 
	     raiserror('Материал не существует!',16,1)
		 return (-1)
	 end

	 if exists(select * from Material where Name = @Name and CategoryId = @CategoryId and Id <> @Id)
	 begin 
	     set @msg = 'Материал "'+@Name+'" уже существует!';
	     raiserror(@msg,16,1)
		 return (-1)
	 end

     ;merge Material t
	 using (select 
	              @Id Id,
	              @Name Name,
				  @CategoryId  CategoryId,
				  @Price Price,
				  @Description Description
	       ) s on s.Id = t.Id
    when matched then update set Name = s.Name, CategoryId = s.CategoryId, Price = s.Price, Description = s.Description
	when not matched then insert (Name, CategoryId, Price, Description) values(s.Name, s.CategoryId, s.Price, s.Description);
	return (0)
end
go

create or alter procedure p_DeleteMaterial @Id int
as
begin
     if exists(select * from PurchaseMaterial where MaterialId = @Id)
	 or exists(select * from CheckOperation where MaterialId = @Id)
	 begin 
	     raiserror('Материал реализовывался, проверьте продажи!',16,1)
		 return (-1)
	 end 

	 delete from Material where Id = @Id
end
go


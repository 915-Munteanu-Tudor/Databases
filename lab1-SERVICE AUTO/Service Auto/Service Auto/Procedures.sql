use master
go

--a) modify the column type
 
 create procedure SetRepairCost
 as
	alter table Cars
		alter column car_repair_cost float
go


 create procedure SetRepairCostBack
 as
	alter table Cars
		alter column car_repair_cost int
go

select * from Cars
exec SetRepairCostBack

--b) add/remove a column

 create procedure AddFamilyName
 as
	alter table Mechanics
		add family_name varchar(25)
go

 create procedure RemoveFamilyName
 as
	alter table Mechanics
		drop column family_name
go

exec AddFamilyName
select family_name from Mechanics
exec RemoveFamilyName
select * from Mechanics

--c) add/remove default constraint

 create procedure DefaultWorkshopSpace15
 as
	alter table Workshop
		add constraint DefaultSpaceConstraint default(15) for workshop_space
go

 create procedure RemoveDefault
 as
	alter table Workshop
		drop constraint DefaultSpaceConstraint
go

select * from Workshop
exec DefaultWorkshopSpace15
exec RemoveDefault

--d) add/remove a primary key

 create procedure AddCarOwnersPK
 as
	alter table CarOwners
		drop constraint IDPK
	alter table CarOwners
		add constraint id_name_pk primary key(ID, name)
go

 create procedure RemoveCarOwnersPK
 as
	alter table CarOwners
		drop constraint id_name_pk
	alter table CarOwners
		add constraint IDPK primary key(ID)
go

exec AddCarOwnersPK
exec RemoveCarOwnersPK

--e) add/remove a candidate key

 create procedure AddCarOwnersCK
 as
	alter table CarOwners
		add constraint CandidateKeySpace unique (name)
go

 create procedure RemoveCarOwnersCK
 as
	alter table CarOwners
		drop constraint CandidateKeySpace
go

exec AddCarOwnersCK
exec RemoveCarOwnersCK

--f) add/remove a foreign key

 create procedure RemoveCarOwnersIdFK
 as
	alter table CarOwners
		drop constraint car_id_fk
go

 create procedure AddCarOwnersIDFK
 as
	alter table CarOwners
		add constraint car_id_fk foreign key (car_id) references Cars(id_car)
go

exec AddCarOwnersIDFK
exec RemoveCarOwnersIdFK

--g) create/drop a table

create procedure CreateTableCarOwners
as
	create table CarOwners(
		ID int not null
		constraint IDPK primary key,
		name varchar(35) not null,
		car_id int not null
	);
go 

create procedure DropTableCarOwners
as
	drop table CarOwners
go 

exec CreateTableCarOwners
select * from CarOwners
exec DropTableCarOwners


--version history

create table VersionHistory(
	version int
)

insert into VersionHistory values(0)
drop table VersionHistory

Create table ProcedureTable (
	UndoProcedure varchar(100),
	RedoProcedure varchar(100),
	Version int primary key
)

drop table VersionHistory
drop table ProcedureTable
exec GoToVersion 0

CREATE PROCEDURE GoToVersion (@Version int)
as
declare @var int;
	set @var = (select top 1 VH.version
				from VersionHistory VH)

declare @size int;
	set @size = (select max(PT.Version)
				from ProcedureTable PT)

declare @statements char(100);
declare @procedure nvarchar(100);
declare @var2 int
if @Version < 0 or @Version > @size
begin
	print 'version does not exist'
end
else
begin
while @var != @Version
begin
	if @var > @Version
		begin
			declare UndoCursor cursor
			for select PT.UndoProcedure
				from ProcedureTable PT
			open UndoCursor
			select @var2 = 0
			while @var2 != @var
				begin
					fetch from UndoCursor into @statements
					select @var2 = @var2 + 1
				end

				select @procedure = 'exec ' + @statements
				print @procedure
				print 'this was the procedure'
				exec sp_executesql @procedure
				update VersionHistory
					set version = version - 1
				set @var = @var -1
				--fetch from UndoCursor into @statements

			close UndoCursor
			deallocate UndoCursor
		end
			else
				begin
					declare RedoCursor cursor for select PT.RedoProcedure from ProcedureTable PT
					open RedoCursor
					select @var2 = -1
					while @var2 != @var
						begin
							fetch from RedoCursor into @statements
							select @var2 = @var2+1
						end

						select @procedure = 'exec ' + @statements
						print @procedure
						print 'this was the procedure'
						exec sp_executesql @procedure
						update VersionHistory
							set version = version + 1
						set @var = @var + 1
						--fetch from RedoCursor into @statements

					close RedoCursor
					deallocate RedoCursor
					end
end
end
go


insert into ProcedureTable(UndoProcedure, RedoProcedure, Version)
values
		('DropTableCarOwners', 'CreateTableCarOwners', 1),
		('RemoveFamilyName', 'AddFamilyName', 2),
		('SetRepairCostBack', 'SetRepairCost', 3),
		('RemoveDefault', 'DefaultWorkshopSpace15', 4),
		('RemoveCarOwnersCK', 'AddCarOwnersCK', 5),
		('RemoveCarOwnersIdFK', 'AddCarOwnersIdFK', 6),
		('RemoveCarOwnersPK', 'AddCarOwnersPK', 7)

select * from ProcedureTable
select * from VersionHistory

execute GoToVersion @Version = 0



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
exec DefaultWorkshopSpace12
exec RemoveDefault

--d) add/remove a primary key

 create procedure AddCarOwnersPK
 as
	alter table CarOwners
		drop constraint IdPK
	alter table CarOwners
		add constraint id_name_pk primary key(ID, name)
go

 create procedure RemoveCarOwnersPK
 as
	alter table CarOwners
		drop constraint id_name_pk
	alter table CarOwners
		add constraint id_mechanic primary key(ID)
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
		constraint IdPK primary key,
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
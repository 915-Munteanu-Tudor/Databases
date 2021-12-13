use master
go

create view RandomView
as
	select rand() as value
go

create function RandomInt(@lower int, @upper int)
	returns int
as
begin
	return floor((select value from RandomView) * (@upper - @lower) + @lower)
end
go

create or alter procedure PopulateTable @tableName varchar(50), @nrRows int
as
begin
	declare @currentRow int, @command varchar(256)
	set @currentRow = 0
	while @currentRow < @nrRows
		begin
			select @command = 'Insert' + @tableName + ' ' + convert(varchar(10), @currentRow)
			exec (@command)
			set @currentRow = @currentRow + 1
		end
end
go

create procedure ClearTable @tableName varchar(50)
as
	exec ('DELETE FROM ' + @tableName)
go

--tbl wwith 1 pk and no fk
create or alter procedure InsertTools @seed int
as
begin
	insert into Tools(tool_id, tool_name, tool_age)
	values(@seed, 'tool' + convert(varchar(50), @seed), dbo.RandomInt(1, 30))
end
go

--tbl with 1pk and 1 fk
create or alter procedure InsertParts @seed int
as
begin
	insert into Parts(part_id, part_name, part_cost, tool_id)
	values(@seed, 'part' + convert(varchar(50), @seed), dbo.RandomInt(1, 650), (select top 1 tool_id from Tools))
end
go

--tbl with multicolumn pk
create or alter procedure InsertMechanicsCars @seed int
as
begin
	declare @mechanicId int, @carId int, @added smallint
	select @added = 0
	while @added = 0
		begin
			set @carId = (select top 1 id_car From Cars order by newid())
			set @mechanicId = (select top 1 id_mechanic from Mechanics order by newid())
			--check the uniqueness of intorduced data
			IF EXISTS(SELECT *
                      FROM (
                               SELECT *
                               FROM MechanicsCars
                               WHERE mechanic_id = @mechanicId
                           ) as [MC*]
                      WHERE car_id = @carId
				)
				BEGIN
					CONTINUE
				END
            INSERT INTO MechanicsCars(mechanic_id, car_id)
            VALUES (@mechanicId, @carId)

            SELECT @added = 1
        END
END
go

EXEC InsertTools 1000
SELECT *
FROM Tools
DELETE
FROM Tools
WHERE tool_id = 1000

EXEC InsertParts 1000
SELECT *
FROM Parts
DELETE
FROM Parts
WHERE part_id = 1000

EXEC InsertMechanicsCars 0
SELECT * from MechanicsCars

SELECT *
INTO BackupTools
FROM Tools

SELECT *
INTO BackupParts
FROM Parts

SELECT *
INTO BackupMechanicsCars
FROM MechanicsCars

Delete Tools
Delete Parts
Delete MechanicsCars
--drop table BackupMechanicsCars

exec PopulateTable 'Tools', 3000
exec PopulateTable 'Parts', 1500
exec PopulateTable 'MechanicsCars', 200

select * from Tools
select * from Parts
select * from MechanicsCars

select * from BackupTools
select * from BackupParts
select * from BackupMechanicsCars

--cars with cost greater than 1000
create or alter view ExpensiveCars as
select C.id_car, C.car_brand, C.car_repair_cost
from Cars C
where C.car_repair_cost > 1000

select * from ExpensiveCars

--tools that can be used to assembly the existing parts
create or alter view UsefulTools as
select T.tool_id, T.tool_name
from BackupTools T
	inner join BackupParts P on T.tool_id= P.tool_id

select * from UsefulTools

--all cars grouped by brand which have an appointment
create or alter view CarsWithAppointment as
select C.car_brand, count(C.car_brand) as Number
from Cars C inner join Appointments A on A.car_id = C.id_car
group by C.car_brand

select * from CarsWithAppointment
DROP table Managers
DROP table Mechanics
DROP table Cars
DROP table Appointments
DROP table Parts
DROP table Tools
DROP table Workshop
DROP table WorkshopCars
DROP table MechanicsCars
DROP table Accidents

-- a manager coordinates many mechanics, but a mechanic is coordinated by only one manager 1:n--

CREATE TABLE Managers(
	id_manager int not null primary key,
	name_manager varchar(25),
	
);

CREATE TABLE Mechanics(
	id_mechanic int not null primary key,
	name_mechanic varchar(50),
	experience_mechanic int,
	has_superiour_studies bit,
	coordinator_manager int foreign key references Managers(id_manager)
	on delete cascade
);

-- an accident has more cars, a car has one accident 1:n --

CREATE TABLE Accidents(
	id_accident int not null primary key,
	accident_day int check (accident_day < 32 and accident_day >0),
	accident_month int check (accident_month < 13 and accident_month >0),
	accident_year int,
	accident_cause varchar(100)
);

CREATE TABLE Cars(
	id_car int not null primary key,
	car_brand varchar(25),
	car_age int,
	car_repair_cost int ,
	accident_id int foreign key references Accidents(id_accident)
	on delete cascade
);

-- a car has many mechanics which work at it, a mecanic has many cars to work at  m:n --

CREATE TABLE MechanicsCars(
	mechanic_id int foreign key references Mechanics(id_mechanic),
	car_id int foreign key references Cars(id_Car)
	on delete cascade, 
	primary key(mechanic_id, car_id)

);



-- a car has many appointments to be repaired, an appointment is only for a car 1:n --

CREATE TABLE Appointments(
	id_appointment int not null primary key,
	appointment_day int,
	appointment_month int,
	appointment_year int,
	appointment_hour int,
	car_id int foreign key references Cars(id_car)
	on delete cascade
);

-- a car is repaired in many workrooms and in a workroom are repaired more cars m:n --

CREATE TABLE Workshop(
	workshop_id int not null primary key,
	workshop_space int,
	workshop_usage varchar(100)
);

CREATE TABLE WorkshopCars(
	workshop_id int foreign key references Workshop(workshop_id),
	car_id int foreign key references Cars(id_car),
	primary key(workshop_id, car_id)
);


-- a part can be assembled using only one tool and a tool is used to assemble only one part 1:1 --

CREATE TABLE Tools(
	tool_id int not null primary key,
	tool_name varchar(25),
	tool_age int
);
	

CREATE TABLE Parts(
	part_id int not null primary key,
	part_name varchar(25),
	part_cost int,
	tool_id int unique foreign key references Tools(tool_id)
	on delete cascade
);

insert into dbo.Tools values(1, 'screwdriver', 2)
insert into dbo.Tools values(2, 'key', 2)
insert into dbo.Tools values(3, 'french-key', 1)


insert into dbo.Parts values(1, 'screw', 10, 1)
insert into dbo.Parts values(2, 'pipe', 100, 2)
insert into dbo.Parts values(3, 'wheel', 350, 2)
insert into dbo.Parts values(3, 'wheel', 350, 3)


insert into dbo.Managers Values(21, 'Bogdan');
insert into dbo.Managers Values(32, 'Maria');


INSERT INTO dbo.Mechanics Values(44, 'Costel', 3, 1, 21);
INSERT INTO dbo.Mechanics Values(43, 'Costel', 5, 0, 32);
INSERT INTO dbo.Mechanics Values(64, 'George', 7, 0, 32);
INSERT INTO dbo.Mechanics Values(387, 'George', 15, 1, 21);
INSERT INTO dbo.Mechanics Values(23, 'Mirel', 4, 0, 32);
INSERT INTO dbo.Mechanics Values(98, 'Armando', 9, 1, 32);

GO

INSERT INTO dbo.Accidents Values(55, 21, 5, 2021, 'nu a acordat prioritate');
INSERT INTO dbo.Accidents Values(69, 21, 4, 2020, 'nu a acordat prioritate');
INSERT INTO dbo.Accidents Values(32, 21, 8, 2021, 'vorbea la telefon');
INSERT INTO dbo.Accidents Values(129, 22, 12, 2021, 'dormea la volan');
INSERT INTO dbo.Accidents Values(87, 12, 10, 2020, 'a trecut pe rosu');
GO

INSERT INTO dbo.Cars Values(22, 'Volksvagen', 12, 435, 55);
INSERT INTO dbo.Cars Values(33, 'Renault', 3, 546, 87);
INSERT INTO dbo.Cars Values(126, 'Range-Rover', 1, 2319, 87);
INSERT INTO dbo.Cars Values(456, 'Volvo', 5, 632, 55);
INSERT INTO dbo.Cars Values(35, 'Volvo', 7, 1231, 87);
INSERT INTO dbo.Cars Values(239, 'Volvo', 15, 237, 87);
INSERT INTO dbo.Cars Values(69, 'Audi', 13, 451, 87);
INSERT INTO dbo.Cars Values(1239, 'Audi', 11, 767, 129);


INSERT INTO dbo.Appointments Values(437, 12, 1, 2022,14, 22);
INSERT INTO dbo.Appointments Values(583, 7, 5, 2021,10, 126);
INSERT INTO dbo.Appointments Values(963, 3, 2, 2021,22, 35);


INSERT INTO dbo.MechanicsCars VALUES(44,33);
INSERT INTO dbo.MechanicsCars VALUES(44,126);
INSERT INTO dbo.MechanicsCars VALUES(44,22);
INSERT INTO dbo.MechanicsCars VALUES(64,33);

INSERT INTO dbo.Workshop VALUES(12,10, 'painting');
INSERT INTO dbo.Workshop VALUES(13,3, 'disassembly');
INSERT INTO dbo.Workshop VALUES(41,12, 'painting');
INSERT INTO dbo.Workshop VALUES(103,6, 'painting');
INSERT INTO dbo.Workshop VALUES(29,3, 'assembly');

INSERT INTO dbo.WorkshopCars VALUES(12, 22);
INSERT INTO dbo.WorkshopCars VALUES(12, 33);
INSERT INTO dbo.WorkshopCars VALUES(29, 22);



GO

--updates
Update Cars
set id_car = id_car + 1
where id_car = 22 or id_car = 33 

Update Cars
set car_repair_cost = car_repair_cost + 150
where car_age between 2 and 5 or car_age is null

Update Mechanics
set experience_mechanic = experience_mechanic +
(select count(*) from MechanicsCars
where Mechanics.id_mechanic = MechanicsCars.mechanic_id)

--deletes
Delete
from Cars
where car_brand Like 'R%' and car_age is not null

Delete
from Cars
where Cars.id_car in(
	Select MC.car_id
	From MechanicsCars MC 
	where MC.mechanic_id = 44
)

--unuion
select distinct C.car_brand + '(ok)'
from Cars C
where c.car_age > 10 or (c.accident_id = 87 or c.car_repair_cost < 450)
union
select distinct C.car_brand + '(ok)'
from Cars C
where c.car_age < 5 or (c.car_repair_cost < 650 and c.accident_id = 55)

select distinct M.name_mechanic
from Mechanics M
where M.experience_mechanic > 5 or (M.has_superiour_studies = 'True' and M.coordinator_manager = 21)

--intersection
--(atelierele cu spatiu >=10 si nefolosite)
select W.workshop_id
from Workshop W
where W.workshop_space >= 10
intersect
select W.workshop_id
from Workshop W
where not exists (
	select WC.workshop_id
	from WorkshopCars WC
	where WC.workshop_id = W.workshop_id
)

--(cars repaired by costel with age<5)
select C.id_car
from Cars C
where C.id_car in (
	select MC.car_id
	from MechanicsCars MC
	where MC.mechanic_id in(
		select M.id_mechanic
		from Mechanics M
		where M.name_mechanic = 'Costel' and C.car_age <5
	)
)


-- set-difference
--(masinile care nu au mecanic)
select C.id_car
from Cars C
except
select C.id_Car
from Cars C
where exists (
	select MC.car_id
	from MechanicsCars MC
	where MC.car_id = C.id_car
)

--(ateliere nefolosite)
select W.workshop_id
from Workshop W
where W.workshop_id not in (12, 29)

select top 2 car_brand,
	   CarAge
from (
	select car_brand,
		   car_age as CarAge
	from Cars) as CarImportantDetails
ORDER BY car_brand

select top 3 name_mechanic + ' add_family name',
	   SuperiorStudies
from (
	select name_mechanic,
		   has_superiour_studies as SuperiorStudies
	from Mechanics) as MechanicsWithStudies
order by SuperiorStudies

--joins
select *
from Appointments AP inner join Cars C on AP.car_id = C.id_car  inner join Accidents A on A.id_accident = C.accident_id 

select *
from Mechanics M full join MechanicsCars MC on  M.id_mechanic = MC.mechanic_id full join Cars C on C.id_car = MC.car_id full join WorkshopCars Wc on Wc.car_id = c.id_car full join Workshop W on W.workshop_id = Wc.workshop_id

select*
from Managers M right join Mechanics Mc on Mc.coordinator_manager = M.id_manager

select*
from Tools T left join Parts P on T.tool_id = P.tool_id


--group by
SELECT count(M.id_mechanic) as NrOfMechanics, M.name_mechanic
FROM Mechanics M
GROUP BY M.name_mechanic
HAVING MIN(M.experience_mechanic) > 5


SELECT C.car_brand
FROM Cars C
GROUP BY C.car_brand
HAVING sum(C.car_repair_cost) < (select AVG(car_repair_cost)
										from Cars)

SELECT M.name_mechanic
FROM Mechanics M
GROUP BY M.name_mechanic
HAVING sum(M.experience_mechanic) >= (select AVG(experience_mechanic)
										from Mechanics)

SELECT C.car_brand
FROM Cars C
GROUP BY C.car_brand
HAVING avg(C.car_age) > (select AVG(car_age)
								from Cars)

--any and all

--rewrite <all

select C.id_car
from Cars C
group by c.id_car
having sum(C.car_age) < (select min(car_age) from Cars where car_brand = 'volvo')

select C.id_car
from Cars C
where C.car_age < all(
	select C1.car_age
	from Cars C1
	where  c1.car_brand = 'volvo'
)

--rewrite for <any

select C.id_car
from Cars C
group by c.id_car
having sum(C.car_repair_cost) < (select max(car_repair_cost) from Cars where car_brand = 'audi')

select C.id_car, C.car_repair_cost
from Cars C
where C.car_repair_cost < any(
	select C1.car_repair_cost
	from Cars C1
	where C1.car_brand = 'audi' 
)

--rewrite for =any
select C.id_car
from Cars C
where C.id_car in(
	select WC.car_id
	from WorkshopCars WC
)

select C.id_car
from Cars C
where C.id_car = any(
	select WC.car_id
	from WorkshopCars WC
)

--rewrite <>all
select C.id_car
from Cars C
where C.id_car not in(
	select C1.car_id
	from MechanicsCars C1
)

select C.id_car
from Cars C
where C.id_car <> all(
	select C1.car_id
	from MechanicsCars C1
)

--DELETE FROM Mechanics;
--DELETE FROM MechanicsCars;
--DELETE FROM Accidents;
--DELETE FROM Cars;
--DELETE FROM Managers;
--DELETE FROM Tools;
--DELETE FROM Parts;

SELECT * FROM dbo.Tools;
SELECT * FROM dbo.Parts;
select * from dbo.Cars;
SELECT * FROM dbo.Managers;
SELECT * FROM dbo.Mechanics;
SELECT * FROM dbo.MechanicsCars;
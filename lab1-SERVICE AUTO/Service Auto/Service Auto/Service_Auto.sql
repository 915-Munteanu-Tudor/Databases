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

--DELETE FROM Mechanics;
--DELETE FROM MechanicsCars;
--DELETE FROM Accidents;
--DELETE FROM Cars;
--DELETE FROM Managers;
--DELETE FROM Tools;
--DELETE FROM Parts;

Select * from dbo.Accidents
select * from dbo.Appointments
select * from dbo.Cars
SELECT * FROM dbo.Managers;
SELECT * FROM dbo.Mechanics;
SELECT * FROM dbo.MechanicsCars;
SELECT * FROM dbo.Parts;
SELECT * FROM dbo.Tools;
select * from dbo.Workshop
select * from dbo.WorkshopCars

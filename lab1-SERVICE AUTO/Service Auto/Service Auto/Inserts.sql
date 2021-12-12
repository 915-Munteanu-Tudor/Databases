USE master
go

insert into dbo.Tools values(1, 'screwdriver', 2)
insert into dbo.Tools values(2, 'key', 2)
insert into dbo.Tools values(3, 'french-key', 1)
insert into dbo.Tools values(4, 'saw', 3)



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
INSERT INTO dbo.Mechanics Values(101, 'Laurentiu', 12, 0, 32);
INSERT INTO dbo.Mechanics Values(99, 'Amir', 1, 1, 21);
INSERT INTO dbo.Mechanics Values(69, 'Manole', 21, 1, 32);
INSERT INTO dbo.Mechanics Values(199, 'Mario', 52, 1, 21);
INSERT INTO dbo.Mechanics Values(201, 'Gigi', 101, 0, 32);
INSERT INTO dbo.Mechanics Values(202, 'Luca', 66, 1, 32);
INSERT INTO dbo.Mechanics Values(254, 'Petru', 16, 0, 21);
INSERT INTO dbo.Mechanics Values(256, 'Petru', 112, 1, 32);


GO

INSERT INTO dbo.Accidents Values(55, 21, 5, 2021, 'nu a acordat prioritate');
INSERT INTO dbo.Accidents Values(69, 21, 4, 2020, 'nu a acordat prioritate');
INSERT INTO dbo.Accidents Values(32, 21, 8, 2021, 'vorbea la telefon');
INSERT INTO dbo.Accidents Values(129, 22, 12, 2021, 'dormea la volan');
INSERT INTO dbo.Accidents Values(87, 12, 10, 2020, 'a trecut pe rosu');
GO

INSERT INTO dbo.Cars Values(21, 'Volksvagen', 6, 325, 69);
INSERT INTO dbo.Cars Values(22, 'Volksvagen', 12, 435, 55);
INSERT INTO dbo.Cars Values(26, 'Audi', 2, 671, 55);
INSERT INTO dbo.Cars Values(33, 'Renault', 3, 546, 87);
INSERT INTO dbo.Cars Values(34, 'Renault', 7, 221, 69);
INSERT INTO dbo.Cars Values(127, 'Range-Rover', 2, 319, 129);
INSERT INTO dbo.Cars Values(126, 'Range-Rover', 1, 2319, 87);
INSERT INTO dbo.Cars Values(456, 'Volvo', 5, 632, 55);
INSERT INTO dbo.Cars Values(35, 'Volvo', 7, 1231, 87);
INSERT INTO dbo.Cars Values(239, 'Volvo', 15, 237, 87);
INSERT INTO dbo.Cars Values(69, 'Audi', 13, 451, 87);
INSERT INTO dbo.Cars Values(1239, 'Audi', 11, 767, 129);
INSERT INTO dbo.Cars Values(129, 'Porsche', 1, 1167, 32);
INSERT INTO dbo.Cars Values(2121, 'Lamborghini', 2, 3167, 55);
INSERT INTO dbo.Cars Values(2111, 'Chevrollette', 4, 147, 55);
INSERT INTO dbo.Cars Values(111, 'Chevrollette', 5, 1112, 69);



INSERT INTO dbo.Appointments Values(437, 12, 1, 2022,14, 22);
INSERT INTO dbo.Appointments Values(436, 11, 2, 2022,13, 21);
INSERT INTO dbo.Appointments Values(583, 7, 5, 2021,10, 126);
INSERT INTO dbo.Appointments Values(963, 3, 2, 2021,22, 35);


INSERT INTO dbo.MechanicsCars VALUES(44,33);
INSERT INTO dbo.MechanicsCars VALUES(44,126);
INSERT INTO dbo.MechanicsCars VALUES(44,22);
INSERT INTO dbo.MechanicsCars VALUES(43,33);
INSERT INTO dbo.MechanicsCars VALUES(43,111);
INSERT INTO dbo.MechanicsCars VALUES(387,69);
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

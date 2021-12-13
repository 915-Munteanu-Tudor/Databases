use master
go

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

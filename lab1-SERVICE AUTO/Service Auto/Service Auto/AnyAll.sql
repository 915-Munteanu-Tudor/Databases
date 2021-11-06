use master
go


--any and all

--rewrite <all

select C.car_brand, count(C.id_car) as NrCars
from Cars C
where(
	C.car_age < ( SELECT min(car_age) FROM Cars where car_brand = 'volvo' )
) group by c.car_brand

select C.car_brand, count(C.id_car) as NrCars
from Cars C
where C.car_age < all(
	select C1.car_age
	from Cars C1
	where  c1.car_brand = 'volvo'
) group by c.car_brand

--rewrite for <any

select count(C.id_car) as NrCars, C.car_brand
from Cars C
where(
	C.car_repair_cost < ( SELECT max(car_repair_cost) FROM Cars where car_brand = 'audi' )
) group by C.car_brand

select count(C.id_car) as NrCars, C.car_brand
from Cars C
where C.car_repair_cost < any(
	select C1.car_repair_cost
	from Cars C1
	where C1.car_brand = 'audi' 
) group by C.car_brand

--rewrite for =any
select C.id_car, C.car_brand
from Cars C
where C.id_car in(
	select WC.car_id
	from WorkshopCars WC
)

select C.id_car, C.car_brand
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

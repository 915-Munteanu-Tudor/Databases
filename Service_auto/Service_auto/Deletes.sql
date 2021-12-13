use master
go


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
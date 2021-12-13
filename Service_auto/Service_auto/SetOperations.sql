use master
go


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

--(ateliere nefolosite, NON SET OPERATIONS)
select W.workshop_id
from Workshop W
where W.workshop_id not in (12, 29)

select top 3 car_brand,
	   CarAge
from (
	select car_brand,
		   car_age as CarAge
	from Cars) as CarImportantDetails
ORDER BY car_brand

select top 4 MechanicName + ' add_family name',
	   SuperiorStudies
from (
	select name_mechanic as MechanicName,
		   has_superiour_studies as SuperiorStudies
	from Mechanics) as MechanicsWithStudies
order by SuperiorStudies

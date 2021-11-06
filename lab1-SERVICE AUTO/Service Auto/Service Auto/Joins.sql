use master
go

--joins
select *
from Appointments AP inner join Cars C on AP.car_id = C.id_car  inner join Accidents A on A.id_accident = C.accident_id 

select *
from Mechanics M full join MechanicsCars MC on  M.id_mechanic = MC.mechanic_id full join Cars C on C.id_car = MC.car_id full join WorkshopCars Wc on Wc.car_id = c.id_car full join Workshop W on W.workshop_id = Wc.workshop_id

select*
from Managers M right join Mechanics Mc on Mc.coordinator_manager = M.id_manager

select*
from Tools T left join Parts P on T.tool_id = P.tool_id

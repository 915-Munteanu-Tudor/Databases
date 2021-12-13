use master
go


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

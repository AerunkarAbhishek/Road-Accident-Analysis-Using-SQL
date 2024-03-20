#############   Road Accident Analysis $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



create database Vehicle;

use Vehicle;

create procedure A()
select * from accident a ;

call A();

create procedure V()
select * from vehicle v ;

call V();

alter table accident 
rename column Date to Dates;

update accident 
set dates = str_to_date (dates,"%d-%m-%Y")

alter table accident 
modify column dates date;

****************************************************************************************************************
#Question 1: *How many accidents occured in Rural vs Urban Area?

select Area, count(*) as Total from accident a
group by Area;
 

******************************************************************************************************
# Question 2: Day Name wise accident count

select dayname(dates) DayOfName, count(*) Total from accident a
group by dayname(dates)
order by Total desc;

******************************************************************************************************

#Question 3: Average Age of Vehicles involved in accidents based on their type

select VehicleType,count(AccidentIndex) as Total_accident,round(avg(Agevehicle)) as Avg_Vehicle from vehicle v 
group by VehicleType
having round(avg(Agevehicle)) is not null
order by Avg_Vehicle desc;

***************************************************************************************************************
 
call A();
call V();

###############################################################################################################

# Question 4: Can we identify any trends in accidents based on the age of vehicles involved?*/

select AgeGroup, count(accidentindex),round(avg(agevehicle))
from (
select accidentindex, agevehicle, 
case
	when agevehicle between 0 and 4 then "New"
	when agevehicle between 5 and 8 then "Regular"
	when agevehicle between 9 and 10 then "old"
	else "Very Old" end as `AgeGroup`
from vehicle) as abc
group by AgeGroup;


**********************************************************************************************************

/*Question 5: What is the percentage trend of each weather condition towards accidents*/

call A();

select count(*),
WeatherConditions, 
round((count(*)/ 
(select count(*) from accident)) * 100) as Percentage
from accident a 
group by WeatherConditions 
order by percentage desc;

************************************************************************************************************
# Question 6: Do accidents often involve impacts on the left-hand side of vehicles?  */

select * from vehicle v 

select  LeftHand, count(*) as Total_Vehicle from vehicle v 
where LeftHand in ("No","Yes")
group by LeftHand 

******************************************************************************************************************
/*Question 7: Are there any relationships between journey purposes and 
 the severity of accidents?*/

select * from accident a 

select * from vehicle v
  
select v.JourneyPurpose,count(a.severity),
case 
	when count(a.severity) between 0 and 100 then "Very LOw"
	when count(a.severity) between 101 and 1000 then "Low"
	when count(a.severity) between 1001 and 5000 then "Medium"
	when count(a.severity) between 5001 and 20000 then "High"
	else "Very High" end as Status
from 
vehicle v inner join accident a 
on v.accidentindex=a.accidentindex
group by v.JourneyPurpose,a.severity
having v.journeypurpose != "Not Known"
order by count(a.severity) desc limit 5;

/*Question 8: Calculate the average age of vehicles involved in accidents , considering Day light and point of impact*/

select round(avg(v.AgeVehicle)), count(v.Accidentindex) Total_Accident, a.LightConditions, v.PointImpact  
from accident a join vehicle v
on a.AccidentIndex = v.AccidentIndex 
where a.LightConditions = "Daylight"
group by a.LightConditions, v.PointImpact 
order by Total_Accident desc;

*****************************************************************************************************************
/*Question 9: Calculate the percentage distribution of accident severity.*/


SELECT Severity, COUNT(*) AS Total_Accidents,
       ROUND((COUNT(*) / (SELECT COUNT(*) FROM accident)) * 100, 2) AS Percentage
FROM accident
GROUP BY Severity;

***************************************************************************************************************************

/*Question 10: List the top 3 vehicle types involved in accidents with the highest average age.*/

select  VehicleType, round(Avg(AgeVehicle),2) as Average_Age from vehicle v
group by VehicleType
order by Average_Age desc
limit 3;

**************************************************************************************************************
/*Question 11: Find the average age of vehicles for each propulsion type.*/

select  propulsion,avg(AgeVehicle) as Average_Age from vehicle v
where AgeVehicle is not null
group by Propulsion 
order by avg(AgeVehicle) desc;

**********************************************************************************************************
#Question 12: Calculate the percentage of accidents that occurred in daylight and darkness..*/

select LightConditions, count(*) Total_Accident, 
round((count(*)/ (select count(*) from accident )) * 100,2) as Percentage
from accident a 
group by LightConditions 

***********************************************************************************************************
/*Question 13: Count the number of accidents for each road condition.*/

select RoadConditions, count(*) as Total_Accident from accident a 
group by RoadConditions

************************************************************************************************************

SELECT VehicleType, ROUND(AVG(SpeedLimit), 2) AS AverageSpeedLimit
FROM accident A
JOIN vehicle V ON A.AccidentIndex = V.AccidentIndex
where vehicleType not in ("Data missing or Out Of range")
GROUP BY VehicleType
ORDER BY AverageSpeedLimit DESC
LIMIT 3;

***********************************************************************************************************
/*Question 15: Find the average age of vehicles for each area where accidents occurred.*/

select a.Area, count(v.Accidentindex) Total_Accident,round(avg(v.AgeVehicle),2) Average_Age from vehicle v join accident a 
on v.AccidentIndex = a.AccidentIndex 
group by a.Area

************************************************************************************************************
/*Question 16: Find the average age of vehicles for each weather condition
 *  where the average speed limit is higher than the overall average speed limit*/

select  a.RoadConditions  , avg(a.SpeedLimit) from accident a join vehicle v
on a.AccidentIndex = v.AccidentIndex
group by  a.RoadConditions  
having   avg(a.SpeedLimit) > (select avg(SpeedLimit) from accident a)
order by avg(a.SpeedLimit) desc;
                   
SELECT roadconditions, ROUND(AVG(SpeedLimit), 2) AS AverageSpeedLimit
FROM accident
GROUP BY roadconditions
HAVING AverageSpeedLimit > (SELECT AVG(SpeedLimit) FROM accident);
 
**************************************************************************************************************
/*Question 17:Calculate the percentage distribution of accidents 
 * for each road condition in areas with a speed limit above 50.*/

SELECT A.RoadConditions, COUNT(*) AS TotalAccidents,
       ROUND((COUNT(*) / (SELECT COUNT(*) FROM accident 
       WHERE Area = A.Area AND SpeedLimit > 50)) * 100, 2) AS Percentage
FROM accident A
WHERE A.SpeedLimit > 50
GROUP BY A.RoadConditions, A.Area;

**************************************************************************************************************
/*Question 18:Count the number of accidents where the weather 
 * condition contains the word 'wind'.*/

select weatherConditions ,count(*) Total_Accident from accident a 
where WeatherConditions like "%wind%"
group by weatherConditions

############################################################################################################
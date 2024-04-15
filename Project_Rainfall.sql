use rainfall_india;
create database rainfall_India;
use rainfall_India;
create table rainfall_data(
state_name varchar(700) , 
district_name varchar(700)primary key ,
Jan varchar(700),Feb varchar(700), Mar varchar(700), Apr varchar(700),
 May varchar(700), 
Jun varchar(700),
Jul varchar(700), Aug varchar(700), Sep varchar(700), 
Oct varchar(700), Nov varchar(700), Dece varchar(700), 
Annual varchar(700)
);
drop table rainfall_data;
select * from rainfall_data;
alter table rainfall_data;
update rainfall_data set zone="North" where state_name in ("GUJARAT", "PUNJAB")
--- Rainfall Data for the year 2021---- Main Objective of the Project---
--- 1. Count the no of district in the state---
--- 2. Total Annual Rainfall in all State---
--- 4. Average Rainfall in all State---
--- 5. Maximum Rainfall District---
--- 6. Minimum Rainfall District---
--- 7. Name of districts having less than the average annual rainfall in the state---
--- 8. Average Rainfall District---
--- 9. Quater wise Rainfall i.e., Jan to Mar, Apr to Jun, Jul to Sep, Oct to Dece
--- 10. If Avg Rainfall in the district Ranges from---
--  11. 0 to 50 cm - then declare it as severe drought 
--  12. 50 to 100 cm- then declare it as drought
--  13. 100 to 150 cm- then declare it as Good Rainfall
--  14. 150 to 200 cm- then declare it as flood
--  15. More than 200 cm- then declare it as severe flood
--- 16. Select in the district where avg rainfall in a year is above average---
--- 17. Select in the state where avg rainfall in a year is above average---

------------------------------ Solutions------------------------------------------
--- 1. Count the no of district in the state---
select state_name, count(district_name) as NumberofDistrict from rainfall_data 
group by state_name;


---2. Total Annual Rainfall in all State---
select state_name, round(sum(Annual)) from rainfall_data 
group by state_name;
--- 2.1. Average Rainfall in all State---
select state_name, round(avg(Annual)) from rainfall_data group by state_name;
--- 2.2. Maximum Rainfall District---
select state_name, district_name, round(max(Annual)) as Max_Rainfall from rainfall_data
 group by district_name order by Annual asc;
 --- 2.3. Minimum Rainfall District---
 select state_name, district_name, round(min(Annual)) as Min_Rainfall from rainfall_data
 group by district_name order by Annual asc;
 --- 2.4. Name of districts having less than the average annual rainfall in the state---
 select state_name, district_name from rainfall_data where 
 annual < (select round(avg(annual)))
 order by state_name;
--- 2.5. Average Rainfall District---
select  state_name, district_name, round((avg(annual)/12),2) as avg_annual_rainfall
from rainfall_data group by district_name
--- 3. Quater wise Avg Rainfall i.e., Jan to Mar, Apr to Jun, Jul to Sep, 
      Oct to Dece of District---
select state_name, district_name, 
round((avg(Jan+Feb+Mar)/3),2) as Quater1_avg_rainfall, 
round((avg(Apr+May+Jun)/3),2) as Quarter2_avg_rainfall,
round((avg(Jul+Aug+Sep)/3),2) as Quarter3_avg_rainfall,
round((avg(Oct+Nov+Dece)/3),2) as Quarter4_avg_rainfall 
from rainfall_data group by district_name;
--- 4. Select in the district where avg rainfall in a year is above average---
select a.state_name,district_name,annual,Avg_Annual_Rainfall from rainfall_data 
a inner join
(select state_name, avg(Annual) as Avg_Annual_Rainfall 
from rainfall_data group by state_name) b on a.state_name=b.state_name 
where annual>Avg_Annual_Rainfall;
--- 5. Select in the state where avg rainfall in a year is above national average---

select * from 
(select state_name, avg(Annual) as Avg_Annual_Rainfall 
from rainfall_data group by state_name) tbl1 inner join
(select avg(Avg_Annual_Rainfall) nationalavg from
(select state_name, avg(Annual) as Avg_Annual_Rainfall 
from rainfall_data group by state_name) tbl) tbl2 where tbl1.Avg_Annual_Rainfall>nationalavg
 order by Avg_Annual_Rainfall desc


--- 10. If Avg Rainfall in the district Ranges from---
--  11. 0 to 50 cm - then declare it as severe drought 
select state_name, district_name, 
avg(Jan+Feb+Mar+Apr+May+Jun+Jul+Aug+Sep+Oct+Nov+Dece) < 100 as avg_rainfall
from rainfall_data group by district_name;
use rainfall_india;
select state_name,avg(annual)/12 as avgrainfall, 
case when avg(annual)/12<50 then 'drought' else '' end as 'rainfallsts' 
from rainfall_data group by state_name;
CREATE view new_tbl as select state_name,(avg(Jan)) avgjan
,avg(Feb)  avgFeb,avg(Mar) avgmar, 
avg(Apr) avgapr, avg(May) avgmay, avg(Jun) avgjun, avg(Jul) avgjul,avg(Aug) avgaug, 
avg(Sep) avgsep, avg(Oct) avgoct, avg(Nov) avgnov, avg(dece) avgdece
from rainfall_data group by state_name;

---For the 5th question view have been apply and create 2 tables mentioned below----
create view tbl_rain_fall_mnt as
select state_name,'avgjan' monthnm,avgjan avgrain from new_tbl
union all
select state_name,'avgfeb' monthnm,avgFeb avgrain from new_tbl
union all 
select state_name,'avgmar' monthnm,avgmar from new_tbl
union all
select state_name,'avgapr' monthnm,avgapr from new_tbl
union all
select state_name,'avgmay' monthnm,avgmay from new_tbl
union all
select state_name,'avgjun' monthnm,avgjun from new_tbl
union all
select state_name,'avgjul' monthnm,avgjul from new_tbl
union all
select state_name,'avgaug' monthnm,avgaug from new_tbl
union all
select state_name,'avgsep' monthnm,avgsep from new_tbl
union all
select state_name,'avgoct' monthnm,avgoct from new_tbl
union all
select state_name,'avgnov' monthnm,avgnov from new_tbl
union all
select state_name,'avgdece' monthnm,avgdece from new_tbl
select * from tbl_rain_fall_mnt

---5. In which Month avg rainfall is maximum in the state and declare the state Name----
create view tbl_max_mnth_rain_fall as
select a.state_name,monthnm,avgrain from tbl_rain_fall_mnt a inner join
(select max(avgrain) maxavgrain,state_name from tbl_rain_fall_mnt group by state_name) b
on a.state_name=b.state_name and b.maxavgrain=a.avgrain

select state_name,monthnm,avgrain from tbl_max_mnth_rain_fall a inner join 
(select max(avgrain) cc from tbl_rain_fall_mnt) b on a.avgrain=b.cc

---6. In which Month avg rainfall is minimum in the state and declare the state Name----
create view tbl_max_mnth_rain_fall as
select a.state_name,monthnm,avgrain from tbl_rain_fall_mnt a inner join
(select round(min(avgrain)) minavgrain,state_name from tbl_rain_fall_mnt 
group by state_name) b
on a.state_name=b.state_name and b.minavgrain=a.avgrain

select state_name, monthnm,avgrain from tbl_max_mnth_rain_fall a inner join 
(select min(avgrain) cc from tbl_rain_fall_mnt) b on a.avgrain=b.cc

---7. Declare the state name where avg rainfall is more than 200 cm as "Flood"---
use rainfall_india;
select state_name,avg(annual)/12 as avgrainfall,
case when round(((avg(annual))/12),2)>200 then "Flood" else " " end as "rainfallsts"
from rainfall_data group by state_name;

---8. Declare the state name where avg rainfall is less than 50 cm as "Drought"---
use rainfall_india;
select state_name,avg(annual)/12 as avgrainfall,
case when round(((avg(annual))/12),2)<50 then "Drought" else " " end as "rainfallsts"
from rainfall_data group by state_name;

---9. Annual rainfall and Avg Rainfall of Capital within State--- 
 select a.state_id, a.state_name, capital_name, Established_date, Population,
 annual, round((annual)/12,2) as avgrainfallofcapital
 from info_data b left join rainfall_data a
 on a.district_name=b.capital_name
 
 
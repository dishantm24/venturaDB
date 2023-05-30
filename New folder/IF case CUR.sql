

DROP TABLE	IF EXISTS #cur;


--DECLARE @max1 as INT ,@max2 as INT,@max3 as INT ,@max4 as INT;
--SET @max1  = (Select count(*) from CUR1)--268
--SET @max2  = (Select count(*)  from CUR2)--271
--SET @max3  = (Select count(*) from CUR3)--271
--SET @max4  = (Select count(*)  from CUR4)--269




--SELECT SUM(CASE WHEN Title is null THEN 1 ELSE 0 END) 
--AS [Number Of Null Values] 
--    , COUNT(Title) AS [Number Of Non-Null Values] , 
--	column2 same logic, column 3 same logic, column 4 same logic 
--    FROM Person.Person


--DECLARE @max1 as INT ,@max2 as INT,@max3 as INT ,@max4 as INT;
--SET @max1  = (select 
--SUm(CASE when cuid1 is null then 1 else 0 END ) as 'number of null lavlues1' ,
--count(cuid1) as 'cuid1' from #cur)--268
--SET @max2  = (Select count(*)  from CUR2)--271
--SET @max3  = (Select count(*) from CUR3)--271
--SET @max4  = (Select count(*)  from CUR4)--269


--IF  @max1  > @max2 OR @max1> @max3 OR @max1>@max4
--select 
--cu1.ClntId as cuid1,cu2.ClntId as cuid2,cu3.ClntId as cuid3,cu4.ClntId as cuid4
--, cu1.IntraDayMrgnCall as CRAM1,cu2.IntraDayMrgnCall as CRAM2, cu3.IntraDayMrgnCall
--as CRAM3 ,cu4.IntraDayMrgnCall as 'CRAM4'
--into #cur1
--from CUR1 cu1
--full outer join CUR2 cu2 on cu1.ClntId = cu2.ClntId
--full outer join CUR3 cu3 on cu2.ClntId = cu3.ClntId
--full outer join CUR4 cu4 on cu3.ClntId = cu4.ClntId

--IF (@max2 > @max1 OR @max2> @max3 OR @max2 > @max4)

--select 
--cu1.ClntId as cuid1,cu2.ClntId as cuid2,cu3.ClntId as cuid3,cu4.ClntId as cuid4
--, cu1.IntraDayMrgnCall as CRAM1,cu2.IntraDayMrgnCall as CRAM2, cu3.IntraDayMrgnCall
--as CRAM3 ,cu4.IntraDayMrgnCall as 'CRAM4'
--into #cur2
--from CUR2 cu2
--full outer join CUR1 cu1 on cu2.ClntId = cu1.ClntId
--full outer join CUR3 cu3 on cu1.ClntId = cu3.ClntId
--full outer join CUR4 cu4 on cu3.ClntId = cu4.ClntId

--IF  (@max3 > @max1 OR @max3> @max2 OR @max3 > @max4)
--select 
--cu1.ClntId as cuid1,cu2.ClntId as cuid2,cu3.ClntId as cuid3,cu4.ClntId as cuid4
--, cu1.IntraDayMrgnCall as CRAM1,cu2.IntraDayMrgnCall as CRAM2, cu3.IntraDayMrgnCall
--as CRAM3 ,cu4.IntraDayMrgnCall as 'CRAM4'
--into #cur3
--from CUR3 cu3
--full outer join CUR2 cu2 on cu3.ClntId = cu2.ClntId
--full outer join CUR1 cu1 on cu2.ClntId = cu1.ClntId
--full outer join CUR4 cu4 on cu1.ClntId = cu4.ClntId

--ELSE 
select 
cu1.ClntId as cuid1,cu2.ClntId as cuid2,cu3.ClntId as cuid3,cu4.ClntId as cuid4
, cu1.IntraDayMrgnCall as CRAM1,cu2.IntraDayMrgnCall as CRAM2, cu3.IntraDayMrgnCall
as CRAM3 ,cu4.IntraDayMrgnCall as 'CRAM4'
into #cur
from CUR4 cu4
full outer join CUR1 cu1 on cu4.ClntId = cu1.ClntId
full outer join CUR2 cu2 on cu1.ClntId = cu2.ClntId
full outer join CUR3 cu3 on cu2.ClntId = cu3.ClntId

select 
SUm(CASE when cuid1 is null then 1 else 0 END ) as 'number of null lavlues1' ,
count(cuid1) as 'cuid1',

SUm(CASE when cuid2 is null then 1 else 0 END ) as 'number of null lavlues2' ,
count(cuid2) as 'cuid2',

SUm(CASE when cuid3 is null then 1 else 0 END ) as 'number of null lavlues3' ,
count(cuid3) as 'cuid3',

SUm(CASE when cuid4 is null then 1 else 0 END ) as 'number of null lavlues4' ,
count(cuid4) as 'cuid4'

from #cur

DECLARE @max1 as INT ,@max2 as INT,@max3 as INT ,@max4 as INT;
SET @max1  = (Select count(*) from CUR1)--268
SET @max2  = (Select count(*)  from CUR2)--271
SET @max3  = (Select count(*) from CUR3)--271
SET @max4  = (Select count(*)  from CUR4)--269


IF  @max1  > @max2 OR @max1> @max3 OR @max1>@max4
Select cuid1 from #cur

IF (@max2 > @max1 OR @max2> @max3 OR @max2 > @max4)

Select cuid2 from #cur

IF  (@max3 > @max1 OR @max3> @max2 OR @max3 > @max4)

Select cuid3 from #cur

Else 

select cuid4 from #cur


--IF  cuid1 > cuid2 OR cuid1 > cuid3  OR cuid1 > cuid4 

--Select cuid1 from #cur
--when cuid2 > cuid1 OR cuid2 > cuid3  OR cuid2 > cuid4 then cuid2
--when cuid3> cuid2 OR cuid3 > cuid1  OR cuid3 > cuid4 then cuid3 
--Else 
--cuid4
--end  as CUID
--from #final
--Select * from CASH1 ca left join CUR1 cu on ca.ClntId = cu.ClntId

--Delete the unwanted Records 
--delete from CASH1 where ValtnDt = 'ValtnDt'
--delete from CASH2 where ValtnDt = 'ValtnDt'
--delete from CASH3 where ValtnDt = 'ValtnDt'
--delete from CASH4 where ValtnDt = 'ValtnDt'

--delete from CUR1 where TradDt = 'TradDt'
--delete from CUR2 where TradDt = 'TradDt'
--delete from CUR3 where TradDt = 'TradDt'
--delete from CUR4 where TradDt = 'TradDt'

--delete from FNO1 where TradDt = 'TradDt'
--delete from FNO2 where TradDt = 'TradDt'
--delete from FNO3 where TradDt = 'TradDt'
--delete from FNO4 where TradDt = 'TradDt'

--Delete from NCDX1 where Date ='Date'
--Delete from NCDX2 where Date ='Date'
--Delete from NCDX3 where Date ='Date'
--Delete from NCDX4 where Date ='Date'

--delete from COM1 where ValtnDt = 'ValtnDt'
--delete from COM2 where ValtnDt = 'ValtnDt'
--delete from COM3 where ValtnDt = 'ValtnDt'
--delete from COM4 where ValtnDt = 'ValtnDt'


--Main Code
DROP TABLE	IF EXISTS #cur;

DROP TABLE	IF EXISTS #ncdx;
DECLARE @max1 as INT ,@max2 as INT,@max3 as INT ,@max4 as INT;
SET @max1  = (Select count(*) from CUR1)--268
SET @max2  = (Select count(*)  from CUR2)--271
SET @max3  = (Select count(*) from CUR3)--271
SET @max4  = (Select count(*)  from CUR4)--269

DECLARE @max5 as INT ,@max6 as INT,@max7 as INT ,@max8 as INT;
SET @max5  =(Select count(*) from NCDX1)
SET @max6  =(Select count(*) from NCDX2)
SET @max7  =(Select count(*) from NCDX3)
SET @max8  =(Select count(*) from NCDX4)




select 
cu1.ClntId as cuid1,cu2.ClntId as cuid2,cu3.ClntId as cuid3,cu4.ClntId as cuid4
, cu1.IntraDayMrgnCall as CRAM1,cu2.IntraDayMrgnCall as CRAM2, cu3.IntraDayMrgnCall
as CRAM3 ,cu4.IntraDayMrgnCall as 'CRAM4'
into #cur
from CUR4 cu4
full outer join CUR1 cu1 on cu4.ClntId = cu1.ClntId
full outer join CUR2 cu2 on cu4.ClntId = cu2.ClntId
full outer join CUR3 cu3 on cu4.ClntId = cu3.ClntId;



select nc1.Client_Code as ncid1,nc2.Client_Code as ncid2 , nc3.Client_Code as ncid3,nc4.Client_Code as ncid4
,(convert(FLOAT,nc1.Initial_Margin) + convert (FLOAT, nc1.ELM_Margin )) as NCAM1
,(convert(FLOAT,nc2.Initial_Margin) + convert (FLOAT, nc2.ELM_Margin )) as NCAM2
,(convert(FLOAT,nc3.Initial_Margin) + convert (FLOAT, nc3.ELM_Margin )) as NCAM3
,(convert(FLOAT,nc4.Initial_Margin) + convert (FLOAT, nc4.ELM_Margin )) as NCAM4
into #ncdx
from 
NCDX4 nc4
full outer join NCDX1 nc1 on nc4.Client_Code = nc1.Client_Code
full outer join NCDX3 nc3 on nc4.Client_Code = nc3.Client_Code
full outer join NCDX2 nc2 on nc4.Client_Code = nc2.Client_Code;

with 

CASH as (
select ca1.ClntId as Cid1 ,ca2.ClntId as Cid2 , ca3.ClntId as Cid3,ca4.ClntId as Cid4 
,ca1.TtlMrgnAmt as CAM1 ,ca2.TtlMrgnAmt as CAM2 ,ca3.TtlMrgnAmt as CAM3,ca4.TtlMrgnAmt as CAM4
from CASH4 ca4
full outer   join CASH3 ca3 on ca4.ClntId = ca3.ClntId
full outer join CASH2 ca2 on ca4.ClntId = ca2.ClntId
full outer join CASH1 ca1 ON ca4.ClntId = ca1.ClntId
),

FNO as (

Select fn1.ClntId as fid1,fn2.ClntId as fid2,fn3.ClntId as fid3,fn4.ClntId as fid4
,fn1.IntraDayMrgnCall as FAM1,fn2.IntraDayMrgnCall as FAM2,fn3.IntraDayMrgnCall as FAM3,fn4.IntraDayMrgnCall as FAM4
from FNO4 fn4
full outer join FNO3 fn3 on fn4.ClntId =fn3.ClntId
full outer join FNO2 fn2 on fn4.ClntId = fn2.ClntId
full outer join FNO1 fn1 on fn4.ClntId = fn1.ClntId

),

MCX as (

Select mc1.column5 as mid1
,mc2.column5 as mid2
,mc3.column5 as mid3
,mc4.column5 as mid4
, mc1.column9 as MAM1 
,mc2.column9 as MAM2
,mc3.column9 as MAM3
,mc4.column9 as MAM4
from MCX4 mc4
full outer join MCX3 mc3 on mc4.column5 = mc3.column5
full outer  join MCX2 mc2 on mc4.column5 = mc2.column5
full outer join MCX1 mc1 on mc4.column5 = mc1.column5

),

CUR as (

Select CRAM1,CRAM2,CRAM3,CRAM4, case 

when @max1  > @max2  then cuid1
when (@max2 > @max3 ) then cuid2
when (@max3 > @max4 ) then cuid3
else cuid4
end as 'FinalCUR'
from #cur




),

NCDX as 
(

Select 
NCAM1,NCAM2,NCAM3,NCAM4,
Case 
when @max5 > @max6  then ncid1
when @max6 > @max7  then ncid2
when @max7 > @max8 then ncid3
Else ncid4
END as 'FINALNCDX'
from #ncdx
)

,

COMD as (
select cm1.ClntId as cmid1,cm2.ClntId as cmid2,cm3.ClntId as cmid3,cm2.ClntId as cmid4
from COM1 cm1 
full outer join COM2 cm2 on cm1.ClntId = cm2.ClntId
full outer join COM3 cm3 on cm2.ClntId = cm3.ClntId
full outer join COM4 cm4 on cm3.ClntId = cm4.ClntId
),



CTE as (
select ClntId from CASH1 
union 
select ClntId from CASH2
union 
select ClntId from CASH3
union 
select ClntId from CASH4
union 
Select ClntId from FNO1
union 
Select ClntId from FNO2
union 
Select ClntId from FNO3
union 
Select ClntId from FNO4
union 
Select column5 from MCX1
union 
Select column5 from MCX2
union 
Select column5 from MCX3
union 
Select column5 from MCX4
union 
Select ClntId from CUR1
union 
Select ClntId from CUR2
union 
Select ClntId from CUR3
union 
Select ClntId from CUR4
union 
Select Client_Code from NCDX1
union
Select Client_Code from NCDX2
union
Select Client_Code from NCDX3
union
Select Client_Code from NCDX4


)
,
CTE1 AS (

select  cte.ClntId as ClientId
,ISNULL(CAM1,0) AS CAM1,ISNULL(CAM2,0) AS CAM2,ISNULL(CAM3,0) AS CAM3,ISNULL(CAM4,0) AS CAM4,
ISNULL(FAM1,0) AS FAM1,ISNULL(FAM2,0) AS FAM2,ISNULL(FAM3,0) AS FAM3,ISNULL(FAM4,0) AS FAM4,
ISNULL(CRAM1,0) AS CRAM1,ISNULL(CRAM2,0) AS CRAM2,ISNULL(CRAM3,0) AS CRAM3,ISNULL(CRAM4,0) AS CRAM4,
ISNULL(MAM1,0) AS MAM1,ISNULL(MAM2,0) AS MAM2,ISNULL(MAM3,0) AS MAM3,ISNULL(MAM4,0) AS MAM4,
ISNULL(NCAM1,0) AS NCAM1,ISNULL(NCAM2,0) AS NCAM2,ISNULL(NCAM3,0) AS NCAM3,ISNULL(NCAM4,0) AS NCAM4
from CTE cte
full outer  join  CASH cash on cte.ClntId = cash.Cid4
full outer join FNO fno on cte.ClntId = fno.fid4
full outer  join MCX mcx on cte.ClntId = mcx.mid4
full outer join CUR cur on cte.ClntId = cur.FinalCUr
full outer join NCDX ncdx on cte.ClntId = ncdx.FINALNCDX
where cte.ClntId is not null 


Group by cte.ClntId,CAM1,CAM2,CAM3,CAM4,FAM1,FAM2,FAM3,FAM4,CRAM1,CRAM2,CRAM3,CRAM4
,MAM1,MAM2,MAM3,MAM4,NCAM1,NCAM2,NCAM3,NCAM4


)
,

CTE2 as (

Select Distinct  ClientId
,CAM1,CAM2,CAM3,CAM4,FAM1,FAM2,FAM3,FAM4,CRAM1,CRAM2,CRAM3,CRAM4
,MAM1,MAM2,MAM3,MAM4,NCAM1,NCAM2,NCAM3,NCAM4,
ceiling((convert(Float,CAM1) + convert(Float,FAM1) + convert(Float,CRAM1) + convert(Float,MAM1) + convert(Float,NCAM1))) as 'TotalPeak1',
ceiling((convert(Float,CAM2) + convert(Float,FAM2) + convert(Float,CRAM2) + convert(Float,MAM2) + convert(Float,NCAM2))) as 'TotalPeak2',
ceiling((convert(Float,CAM3) + convert(Float,FAM3) + convert(Float,CRAM3) + convert(Float,MAM3) + convert(Float,NCAM3))) as 'TotalPeak3',
ceiling((convert(Float,CAM4) + convert(Float,FAM4) + convert(Float,CRAM4) + convert(Float,MAM4) + convert(Float,NCAM4))) as 'TotalPeak4'

 from CTE c1 inner join CTE1 c2 on c1.ClntId = c2.ClientId 

)

Select ClientId
,CAM1,CAM2,CAM3,CAM4,FAM1,FAM2,FAM3,FAM4,CRAM1,CRAM2,CRAM3,CRAM4
,MAM1,MAM2,MAM3,MAM4,NCAM1,NCAM2,NCAM3,NCAM4,
ceiling((convert(Float,CAM1) + convert(Float,FAM1) + convert(Float,CRAM1) + convert(Float,MAM1) + convert(Float,NCAM1))) as 'TotalPeak1',
ceiling((convert(Float,CAM2) + convert(Float,FAM2) + convert(Float,CRAM2) + convert(Float,MAM2) + convert(Float,NCAM2))) as 'TotalPeak2',
ceiling((convert(Float,CAM3) + convert(Float,FAM3) + convert(Float,CRAM3) + convert(Float,MAM3) + convert(Float,NCAM3))) as 'TotalPeak3',
ceiling((convert(Float,CAM4) + convert(Float,FAM4) + convert(Float,CRAM4) + convert(Float,MAM4) + convert(Float,NCAM4))) as 'TotalPeak4',

Case when TotalPeak1 > TotalPeak2 then TotalPeak1
when TotalPeak2 > TotalPeak3 then TotalPeak2
when TotalPeak3 > TotalPeak4 then TotalPeak3
Else TotalPeak4
End as 'MAX'

 from CTE2
 where ClientId = '080184'

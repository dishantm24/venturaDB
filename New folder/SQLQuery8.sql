--Select * from CASH1 ca left join CUR1 cu on ca.ClntId = cu.ClntId

--Delete the unwanted Records 
--select * from CASH1 
exec DeleteMG13Peak_Sp;

--Main Code
With CTE as (
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

select cte.ClntId as ClientId
,ISNULL(CAM1,0) AS CAM1,ISNULL(CAM2,0) AS CAM2,ISNULL(CAM3,0) AS CAM3,ISNULL(CAM4,0) AS CAM4,
ISNULL(FAM1,0) AS FAM1,ISNULL(FAM2,0) AS FAM2,ISNULL(FAM3,0) AS FAM3,ISNULL(FAM4,0) AS FAM4,
ISNULL(CRAM1,0) AS CRAM1,ISNULL(CRAM2,0) AS CRAM2,ISNULL(CRAM3,0) AS CRAM3,ISNULL(CRAM4,0) AS CRAM4,
ISNULL(MAM1,0) AS MAM1,ISNULL(MAM2,0) AS MAM2,ISNULL(MAM3,0) AS MAM3,ISNULL(MAM4,0) AS MAM4,
ISNULL(NCAM1,0) AS NCAM1,ISNULL(NCAM2,0) AS NCAM2,ISNULL(NCAM3,0) AS NCAM3,ISNULL(NCAM4,0) AS NCAM4
from CTE cte
full outer join (select distinct ClntId as Cid1,TtlMrgnAmt as CAM1  from  CASH1) as  cash1 on cte.ClntId  = (cash1.Cid1)
full outer join (select distinct ClntId as Cid2 , TtlMrgnAmt as CAM2  from  CASH2) as  cash2 on cte.ClntId  = (cash2.Cid2)
full outer join (select distinct ClntId as Cid3, TtlMrgnAmt as CAM3 from  CASH3) as  cash3 on cte.ClntId  = (cash3.Cid3)
full outer join (select distinct ClntId as Cid4, TtlMrgnAmt as CAM4 from  CASH4) as  cash4 on cte.ClntId  = (cash4.Cid4)
full outer join (select distinct ClntId as Fid1,IntraDayMrgnCall as FAM1  from FNO1) as fno1 on cte.ClntId = fno1.Fid1
full outer join (select distinct ClntId as Fid2,IntraDayMrgnCall as FAM2  from FNO2) as fno2 on cte.ClntId = fno2.Fid2
full outer join (select distinct ClntId as Fid3,IntraDayMrgnCall as FAM3  from FNO3) as fno3 on cte.ClntId = fno3.Fid3
full outer join (select distinct ClntId as Fid4,IntraDayMrgnCall as FAM4  from FNO4) as fno4 on cte.ClntId = fno4.Fid4
full outer join (Select distinct column5 as Mid1,column9 as MAM1 from MCX1 ) as mcx1 on cte.ClntId = mcx1.Mid1
full outer join (Select distinct column5 as Mid2,column9 as MAM2 from MCX2 ) as mcx2 on cte.ClntId = mcx2.Mid2
full outer join (Select distinct column5 as Mid3,column9 as MAM3 from MCX3 ) as mcx3 on cte.ClntId = mcx3.Mid3
full outer join (Select distinct column5 as Mid4,column9 as MAM4 from MCX4 ) as mcx4 on cte.ClntId = mcx4.Mid4
full outer join (select distinct ClntId as Cuid1,IntraDayMrgnCall as CRAM1 from CUR1) as cur1 on cte.ClntId = cur1.Cuid1
full outer join (select distinct ClntId as Cuid2,IntraDayMrgnCall as CRAM2 from CUR2) as cur2 on cte.ClntId = cur2.Cuid2
full outer join (select distinct ClntId as Cuid3,IntraDayMrgnCall as CRAM3 from CUR3) as cur3 on cte.ClntId = cur3.Cuid3
full outer join (select distinct ClntId as Cuid4,IntraDayMrgnCall as CRAM4 from CUR4) as cur4 on cte.ClntId = cur4.Cuid4
full outer join (Select distinct Client_Code as Ncid1 ,(convert(FLOAT,Initial_Margin) + convert (FLOAT,ELM_Margin )) 
as NCAM1 from NCDX1) as ncdx1 on cte.ClntId = ncdx1.Ncid1
full outer join (Select distinct Client_Code as Ncid2 ,(convert(FLOAT,Initial_Margin) + convert (FLOAT,ELM_Margin )) 
as NCAM2 from NCDX2) as ncdx2 on cte.ClntId = ncdx2.Ncid2
full outer join (Select distinct Client_Code as Ncid3 ,(convert(FLOAT,Initial_Margin) + convert (FLOAT,ELM_Margin )) 
as NCAM3 from NCDX3) as ncdx3 on cte.ClntId = ncdx3.Ncid3
full outer join (Select distinct Client_Code as Ncid4 ,(convert(FLOAT,Initial_Margin) + convert (FLOAT,ELM_Margin )) 
as NCAM4 from NCDX4) as ncdx4 on cte.ClntId = ncdx4.Ncid4
--Group by cte.ClntId,CAM1,CAM2,CAM3,CAM4,FAM1,FAM2,FAM3,FAM4,CRAM1,CRAM2,CRAM3,CRAM4
--,MAM1,MAM2,MAM3,MAM4,NCAM1,NCAM2,NCAM3,NCAM4

)
,

CTE2 as (

Select   ClientId
,CAM1,CAM2,CAM3,CAM4,FAM1,FAM2,FAM3,FAM4,CRAM1,CRAM2,CRAM3,CRAM4
,MAM1,MAM2,MAM3,MAM4,NCAM1,NCAM2,NCAM3,NCAM4,
(convert(Float,CAM1) + convert(Float,FAM1) + convert(Float,CRAM1) + convert(Float,MAM1) + convert(Float,NCAM1)) as 'TotalPeak1',
(convert(Float,CAM2) + convert(Float,FAM2) + convert(Float,CRAM2) + convert(Float,MAM2) + convert(Float,NCAM2)) as 'TotalPeak2',
(convert(Float,CAM3) + convert(Float,FAM3) + convert(Float,CRAM3) + convert(Float,MAM3) + convert(Float,NCAM3)) as 'TotalPeak3',
(convert(Float,CAM4) + convert(Float,FAM4) + convert(Float,CRAM4) + convert(Float,MAM4) + convert(Float,NCAM4)) as 'TotalPeak4'

 from CTE c1 inner join CTE1 c2 on c1.ClntId = c2.ClientId 

)
,
 CTE3 as 
 (
Select  ClientId,MAX(TotalPeak) as 'MAXTOTALPeak' 
from(
Select ClientId,TotalPeak1 as TotalPeak from CTE2
union
Select ClientId,TotalPeak2 as TotalPeak from CTE2
union
Select ClientId,TotalPeak3 as TotalPeak from CTE2
union
Select ClientId,TotalPeak4 as TotalPeak from CTE2 ) cc
Group by ClientId
 )

 select c2.ClientId,CAM1,CAM2,CAM3,CAM4,FAM1,FAM2,FAM3,FAM4,CRAM1,CRAM2,CRAM3,CRAM4
,MAM1,MAM2,MAM3,MAM4,NCAM1,NCAM2,NCAM3,NCAM4,TotalPeak1,TotalPeak2,TotalPeak3,TotalPeak4,MAXTOTALPeak from CTE3 c1 inner join CTE2 c2 on c1.ClientId = c2.ClientId
 


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

with 

CASH as (
select ca1.ClntId as Cid1 ,ca2.ClntId as Cid2 , ca3.ClntId as Cid3,ca4.ClntId as Cid4 
,ca1.TtlMrgnAmt as CAM1 ,ca2.TtlMrgnAmt as CAM2 ,ca3.TtlMrgnAmt as CAM3,ca4.TtlMrgnAmt as CAM4

from CASH4 ca4
left  join CASH3 ca3 on ca4.ClntId = ca3.ClntId
left join CASH2 ca2 on ca4.ClntId = ca2.ClntId
left join CASH1 ca1 ON ca4.ClntId = ca1.ClntId 
group by ca1.ClntId  ,ca2.ClntId  , ca3.ClntId ,ca4.ClntId 
,ca1.TtlMrgnAmt  ,ca2.TtlMrgnAmt  ,ca3.TtlMrgnAmt ,ca4.TtlMrgnAmt 

),

FNO as (

Select fn1.ClntId as fid1,fn2.ClntId as fid2,fn3.ClntId as fid3,fn4.ClntId as fid4
,fn1.IntraDayMrgnCall as FAM1,fn2.IntraDayMrgnCall as FAM2,fn3.IntraDayMrgnCall as FAM3,fn4.IntraDayMrgnCall as FAM4
from FNO4 fn4
left join FNO3 fn3 on fn4.ClntId =fn3.ClntId
left join FNO2 fn2 on fn4.ClntId = fn2.ClntId
left join FNO1 fn1 on fn4.ClntId = fn1.ClntId
group by fn1.ClntId,fn2.ClntId ,fn3.ClntId ,fn4.ClntId 
,fn1.IntraDayMrgnCall ,fn2.IntraDayMrgnCall ,fn3.IntraDayMrgnCall ,fn4.IntraDayMrgnCall 

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
left join MCX3 mc3 on mc4.column5 = mc3.column5
left join MCX2 mc2 on mc4.column5 = mc2.column5
left join MCX1 mc1 on mc4.column5 = mc1.column5
group by mc1.column5, mc2.column5, mc3.column5, mc4.column5,mc1.column9
,mc2.column9,mc3.column9,mc4.column9
),

CUR as (

select cu1.ClntId as cuid1,cu2.ClntId as cuid2,cu3.ClntId as cuid3,cu4.ClntId as cuid4
, cu1.IntraDayMrgnCall as CRAM1,cu2.IntraDayMrgnCall as CRAM2, cu3.IntraDayMrgnCall as CRAM3 ,cu4.IntraDayMrgnCall as 'CRAM4'
from CUR1 cu1
full outer join CUR2 cu2 on cu1.ClntId = cu2.ClntId
full outer join CUR3 cu3 on cu2.ClntId = cu3.ClntId
full outer join CUR4 cu4 on cu3.ClntId = cu4.ClntId


),

NCDX as 
(

select nc1.Client_Code as ncid1,nc2.Client_Code as ncid2 , nc3.Client_Code as ncid3,nc4.Client_Code as ncid4
,(convert(FLOAT,nc1.Initial_Margin) + convert (FLOAT, nc1.ELM_Margin )) as NCAM1
,(convert(FLOAT,nc2.Initial_Margin) + convert (FLOAT, nc2.ELM_Margin )) as NCAM2
,(convert(FLOAT,nc3.Initial_Margin) + convert (FLOAT, nc3.ELM_Margin )) as NCAM3
,(convert(FLOAT,nc4.Initial_Margin) + convert (FLOAT, nc4.ELM_Margin )) as NCAM4

--,(nc2.Initial_Margin + nc2.ELM_Margin) as NCAM2
--,(nc3.Initial_Margin + nc3.ELM_Margin) as NCAM3
--,(nc4.Initial_Margin + nc4.ELM_Margin) as NCAM4
from 
NCDX1 nc1
full outer join NCDX2 nc2 on nc1.Client_Code = nc2.Client_Code
full outer join NCDX3 nc3 on nc2.Client_Code = nc3.Client_Code
full outer join NCDX4 nc4 on nc3.Client_Code = nc4.Client_Code
)

,

COMD as (
select cm1.ClntId as cmid1,cm2.ClntId as cmid2,cm3.ClntId as cmid3,cm2.ClntId as cmid4
from COM1 cm1 
full outer join COM2 cm2 on cm1.ClntId = cm2.ClntId
full outer join COM3 cm3 on cm2.ClntId = cm3.ClntId
full outer join COM4 cm4 on cm3.ClntId = cm4.ClntId
)

--select   * from CASH cash
--full outer  join FNO fno on cash.Cid4 = fno.fid4
--full outer join MCX mcx on cash.Cid4 = mcx.mid4

--full outer join CUR cur on cash.Cid4 = cur.cuid1 OR cash.Cid4 = cur.cuid2
--OR  cash.Cid4 = cur.cuid3 OR  cash.Cid4 = cur.cuid4
--AND (cur.cuid1 is Not Null OR cur.cuid2 is Not null OR cur.cuid3 is not NULL or cur.cuid4 is not NULL)

--full outer join NCDX ncdx on cash.Cid4 = ncdx.ncid1 OR cash.Cid4 = ncdx.ncid2
--OR cash.Cid4 = ncdx.ncid3  OR cash.Cid4 = ncdx.ncid4

--full outer join COMD comd on cash.Cid4 = comd.cmid1 Or cash.Cid4 = comd.cmid2 Or 
--cash.Cid4 = comd.cmid3 Or cash.Cid4 = comd.cmid4 

--Order by cash.Cid4 desc 


select   Distinct * from CASH cash
full outer  join FNO fno on cash.Cid4 = fno.fid4
full outer join MCX mcx on fno.fid4 = mcx.mid4
full outer    join CUR cur on mcx.mid4 = cur.cuid1 OR  
mcx.mid4 = cur.cuid2 OR
mcx.mid4 = cur.cuid3 OR 
mcx.mid4 = cur.cuid4
AND (cur.cuid1 is Not Null OR cur.cuid2 is Not null OR cur.cuid3 is not NULL or cur.cuid4 is not NULL)
full outer join NCDX ncdx on mcx.mid4 = ncdx.ncid1 OR mcx.mid4 = ncdx.ncid2
OR mcx.mid4 = ncdx.ncid3  OR mcx.mid4 = ncdx.ncid4
AND(ncdx.ncid1 is not null OR 
ncdx.ncid2 is not null or ncdx.ncid3 is not null or ncdx.ncid4 is not null )



--with 
--CUR as (

--select 

--cu1.ClntId as cuid1,cu2.ClntId as cuid2,cu3.ClntId as cuid3,cu4.ClntId as cuid4
--, cu1.IntraDayMrgnCall as CRAM1,cu2.IntraDayMrgnCall as CRAM2, cu3.IntraDayMrgnCall as CRAM3 ,cu4.IntraDayMrgnCall as 'CRAM4'
--from CUR1 cu1
--full outer join CUR2 cu2 on cu1.ClntId = cu2.ClntId
--full outer join CUR3 cu3 on cu2.ClntId = cu3.ClntId
--full outer join CUR4 cu4 on cu3.ClntId = cu4.ClntId


--) 


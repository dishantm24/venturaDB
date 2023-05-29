
DECLARE @max1 as INT ,@max2 as INT,@max3 as INT ,@max4 as INT;
SET @max1  = (Select count(*) from CUR1)--268
SET @max2  = (Select count(*)  from CUR2)--271
SET @max3  = (Select count(*) from CUR3)--271
SET @max4  = (Select count(*)  from CUR4)--269

IF  @max1  > @max2 and @max1> @max3 and @max1>@max4
select 

cu1.ClntId as cuid1,cu2.ClntId as cuid2,cu3.ClntId as cuid3,cu4.ClntId as cuid4
, cu1.IntraDayMrgnCall as CRAM1,cu2.IntraDayMrgnCall as CRAM2, cu3.IntraDayMrgnCall
as CRAM3 ,cu4.IntraDayMrgnCall as 'CRAM4'
from CUR1 cu1
full outer join CUR2 cu2 on cu1.ClntId = cu2.ClntId
full outer join CUR3 cu3 on cu2.ClntId = cu3.ClntId
full outer join CUR4 cu4 on cu3.ClntId = cu4.ClntId

IF @max2 > @max1 and @max2> @max3 and @max2 > @max4

select 

cu1.ClntId as cuid1,cu2.ClntId as cuid2,cu3.ClntId as cuid3,cu4.ClntId as cuid4
, cu1.IntraDayMrgnCall as CRAM1,cu2.IntraDayMrgnCall as CRAM2, cu3.IntraDayMrgnCall
as CRAM3 ,cu4.IntraDayMrgnCall as 'CRAM4'
from CUR2 cu2
full outer join CUR1 cu1 on cu2.ClntId = cu1.ClntId
full outer join CUR3 cu3 on cu1.ClntId = cu3.ClntId
full outer join CUR4 cu4 on cu3.ClntId = cu4.ClntId

IF  
@max3 > @max1 and @max3> @max2 and @max3 > @max4


select 

cu1.ClntId as cuid1,cu2.ClntId as cuid2,cu3.ClntId as cuid3,cu4.ClntId as cuid4
, cu1.IntraDayMrgnCall as CRAM1,cu2.IntraDayMrgnCall as CRAM2, cu3.IntraDayMrgnCall
as CRAM3 ,cu4.IntraDayMrgnCall as 'CRAM4'
from CUR3 cu3
full outer join CUR2 cu2 on cu2.ClntId = cu3.ClntId
full outer join CUR3 cu1 on cu3.ClntId = cu1.ClntId
full outer join CUR4 cu4 on cu1.ClntId = cu4.ClntId

ELSE 
select 

cu1.ClntId as cuid1,cu2.ClntId as cuid2,cu3.ClntId as cuid3,cu4.ClntId as cuid4
, cu1.IntraDayMrgnCall as CRAM1,cu2.IntraDayMrgnCall as CRAM2, cu3.IntraDayMrgnCall
as CRAM3 ,cu4.IntraDayMrgnCall as 'CRAM4'
from CUR4 cu4
full outer join CUR1 cu1 on cu4.ClntId = cu1.ClntId
full outer join CUR2 cu2 on cu1.ClntId = cu2.ClntId
full outer join CUR3 cu3 on cu2.ClntId = cu3.ClntId

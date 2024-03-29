--select Rtrim(s.category1) As Cat_1, s.ISINNo, s.scripcode, rtrim(s.name)+s.series
--as SymbolSeries, s.series, Rtrim(s.category) as Cat ,
--(case when (s.category in ('C','D','E') or s.category like 'C_%_%' ) 
--then 999 else c.buymgn*100 end) as catM,
--(case when S.GSMFlag in (11,12,13,14,15,16,20,21,22,33) then S.GSMFlag  else '' end) 
--as ASM_FLAG  ---ASM Flag
--from scripmaster s inner join Scripcategory c on s.category=c.category
-- where series not in ('BE','BZ','BT','IT','SM','SG','ST','SZ') and
--exch = 'N' and  exchtype = 'C'  and scripcode in (...)


--FNO :  tokeninfo
--Cat_1 :  marginreport
--ISINNo :  marginreport
--scripcode :   marginreport
--SymbolSeries :  marginreport +   [NSEM]
--series:   [NSEM]
--base : CATM + marginreport
--buymgn : category margin 
--GSMFlag  : f23 from securitydata
--TOTTRDQTY--from bhavreport
--CLOSE--bhavreport
---var,elm,adii: varreport
--fnomar--fnovalues 
--maximumvalues- from FNOmar, Maxvalues
--I_M -- imvalues 
--

--T-4V  0305  T-3V  0405, T-2V  0505,T-1V  0805,TV 0905***  : Total from BHav files 
--T-2Rate  0505	T-1Rate  0805	Trate  0905 : closing rate from Bhva files 





DROP TABLE	IF EXISTS #temp1;

DROP TABLE	IF EXISTS #final;

DELETe  from NSEM where Symbol = 'Symbol';

deletE FROM SPAN WHERE Symbol = 'Symbol';

delete from bhav1 where SYMBOL = 'SYMBOL';
deletE FROM bhav2 WHERE SYMBOL = 'SYMBOL';
deletE FROM bhav3 WHERE SYMBOL = 'SYMBOL';
deletE FROM bhav4 WHERE SYMBOL = 'SYMBOL';

exec mdisin;



with 
varvalues as (
select  FNOIND, m1.[ scripcode],
case 
when tf.FNOIND  ='IND' then ceiling((vr.[VAR] + (vr.ELM*3) + vr.ADDI) + 15  )--removed +10 and replaced with +15
when tf.FNOIND  ='FNO' then ceiling((vr.[VAR] + (vr.ELM*3) + vr.ADDI) + 15  )--removed +10 and replaced with +15
when tf.FNOIND is null  AND( m1.[ Category] in ('A','B','Q')
OR m1.[ Category] like 'A%'  
OR m1.[ Category] like 'B%' 
OR m1.[ Category] like 'Q%') 
then ceiling ( (vr.[VAR] + (vr.ELM*5)+ vr.ADDI) + 15 )----removed +10 and replaced with +15
when tf.FNOIND is null  and( m1.[ Category] in ('C','D','E')
OR m1.[ Category] like 'C%') 
then ceiling ( (vr.[VAR] + (vr.ELM) + vr.ADDI) + 15 )----removed +10 and replaced with +15
else (vr.[VAR] +vr.ELM+vr.ADDI)
end as 'var+el+adii'
from marginreport m1 
left   join tokeninfo tf on m1.[ scripcode] = tf.TOKEN 
inner  join [dbo].[NSEM] ns on m1.[ scripcode] = ns.Token
inner join VARreport vr on m1.ISINNO = vr.ISINNO
where ns.series not in ('BE','BO','BZ','BT','IT','SM','SG','ST','SZ') 
 --AND m1.ISINNO = 'INE256H01015'
group by FNOIND,m1.[ scripcode],[VAR],ELM,ADDI, m1.[ Category]
),

fnovalues as ( select   m2.[ scripcode],
--,SP.Symbol,
--(CONVERT (float,sp.[SPANMgn] )/100
--(convert(float,sp.[SPANMgn] )
--+ convert(float,sp.[AddExpMgn] ) + convert(float,sp.[ExpMgn] )) /100

--+ CONVERT (float,sp.[ExpMgn] ) + CONVERT (float,sp.[AddExpMgn] ) AS 'FNO'
--convert(float ,sp.[SPANMgn] ) + 
--convert(float,[TotalMgn]) as 'FNOMAR'
(convert(float ,sp.[SPANMgn] ) + convert(float ,sp.AddExpMgn )+ convert(float ,sp.ExpMgn )) /100 as 'FNOMAR'

--(sp.[SPANMgn] +sp.[ExpMgn]+sp.[AddExpMgn])  as  'FNOMAR'
from marginreport m2
left   join tokeninfo tf on m2.[ scripcode] = tf.TOKEN 
inner  join [dbo].[NSEM] ns on m2.[ scripcode] = ns.Token
left join span sp on m2.[ Scrip_Name] = sp.Symbol and ns.Series = 'EQ'
where ns.series not in ('BE','BZ','BO','BT','IT','SM','SG','ST','SZ')
group by m2.[ scripcode],TotalMgn,[SPANMgn],AddExpMgn,ExpMgn
--,sp.[AddExpMgn],sp.[SPANMgn],sp.[ExpMgn]
),

maxvalue as (
select   m3.[ scripcode],FNOIND,
case when 
FNOIND = 'IND' then 25 when 
FNOIND = 'FNO' then 30 
when FNOIND is NULL AND m3.[ Category] in ('A','B','Q') OR m3.[ Category] like 'A%'   OR m3.[ Category] like 'B%'   OR m3.[ Category] like 'Q%' then 38 
when tf.FNOIND is null and m3.[ Category] ='C' then 50
when tf.FNOIND is null and  m3.[ Category] = 'C10' then 60
when tf.FNOIND is null and  m3.[ Category] = 'C20' then 70
when tf.FNOIND is null and  m3.[ Category] = 'C25' then 75
when tf.FNOIND is null and  m3.[ Category] = 'C30' then 80 
when tf.FNOIND is null and  m3.[ Category] = 'C49' then 99
when tf.FNOIND IS NULL and m3.[ Category] ='D'  then 100
when tf.FNOIND IS NULL and m3.[ Category] ='E'  then 100
end as 'maxvalues'	   
from marginreport m3 
left   join tokeninfo tf on m3.[ scripcode] = tf.TOKEN 
inner  join [dbo].[NSEM] ns on m3.[ scripcode] = ns.Token
where ns.series not in ('BE','BZ','BT','BO','IT','SM','SG','ST','SZ')
--and ISINNO = 'INE985W01018'
group by m3.[ scripcode],FNOIND,m3.[ Category]

),

imvalue as (select  m4.[ scripcode],
Case
when m4.[ Category] = 'A' OR m4.[ Category] like 'A%' then (vr.[VAR] + vr.ELM)--removed +5  
when m4.[ Category] = 'B' OR m4.[ Category] like 'B%' then (vr.[VAR] + vr.ELM)--removed +5  
when m4.[ Category] = 'Q' OR m4.[ Category] like 'Q%' then (vr.[VAR] + vr.ELM)--removed +5  
when m4.[ Category] = 'C' OR m4.[ Category] like 'C%' then (vr.[VAR] + vr.ELM + vr.ADDI)--removed +5 
when m4.[ Category] = 'D'  then (vr.[VAR] + vr.ELM + vr.ADDI)--removed +5 
when m4.[ Category] = 'E'  then (vr.[VAR] + vr.ELM + vr.ADDI)--removed +5 
else (vr.[VAR] + vr.ELM + vr.ADDI)
end as 'I_M'
from marginreport m4
inner  join [dbo].[NSEM] ns on m4.[ scripcode] = ns.Token
inner join VARreport vr on m4.ISINNO = vr.ISINNO
where ns.series not in ('BE','BZ','BT','BO','IT','SM','SG','ST','SZ') 
group by m4.[ scripcode],m4.[ Category],[VAR],ELM,ADDI

 ),
maxcatnew as (
select   m5.[ scripcode],FNOIND,
case when 
FNOIND = 'IND' then 20  when FNOIND= 'FNO' then 25
else 0
end as 'maxcat'
from marginreport m5 
left   join tokeninfo tf on m5.[ scripcode] = tf.TOKEN 
inner  join [dbo].[NSEM] ns on m5.[ scripcode] = ns.Token
where ns.series not in ('BE','BZ','BT','BO','IT','SM','SG','ST','SZ')
group by m5.[ scripcode],FNOIND
) 
select   ROW_NUMBER() over (Partition by m.ISINNO order by tf.FNOIND) as 'rownn',
tf.FNOIND as 'FNOIND',Rtrim(m.[ Category1]) as 'CAT_1',
m.ISINNO,m.[ scripcode] as 'scripcode',
Rtrim([ Scrip_Name])+ ns.Series as 'Symbol Series',
ns.Series,
Rtrim(m.[ Category]) as 'CAT',
(Case when (m.[ Category] in ('C','D','E') or m.[ Category] like 'C_%_%' ) then 999 else ca.Margin end) as 'BASE',
case when ns.Series in ('GS','GB') and  b1.TOTTRDQTY is null then   0
else b1.TOTTRDQTY
end as 'T-4V',
case when ns.Series in ('GS','GB') and  b2.TOTTRDQTY is null then   0
else b2.TOTTRDQTY
end as 'T-3V',
case when ns.Series in ('GS','GB') and  b3.TOTTRDQTY is null then   0
else b3.TOTTRDQTY
end as 'T-2V',
case when ns.Series in ('GS','GB') and  b4.TOTTRDQTY is null then   0
else b4.TOTTRDQTY
end as 'T-1V',
case when ns.Series in ('GS','GB') and  b5.TOTTRDQTY is null then   0
else b5.TOTTRDQTY
end as 'T',
convert(float,ISNULL(b3.[CLOSE],0)) as 'T-2Rate', convert(float,ISNULL(b4.[CLOSE],0) )as 'T-1Rate'
,convert(float,ISNULL(b5.[CLOSE],0)) as 'TRate',
--case when b3.[CLOSE] is null then 0 
--else b3.[CLOSE]  end as 'T-2Rate',
--case when b4.[CLOSE] is null then 0 
--else b4.[CLOSE] end as 'T-1Rate',
--case when b5.[CLOSE] is null then 0 
--else b5.[CLOSE]  end as 'TRate',
--b4.[CLOSE] as 'T-1Rate',
--b5.[CLOSE] as 'TRate',
--round ((abs((b5.[CLOSE]-b4.[CLOSE])/b5.[CLOSE]))* 100 ,3 ) as '1Day', --ABS((P1-O1)/P1)*100
--round ((abs((b5.[CLOSE]-b3.[CLOSE])/b5.[CLOSE]))* 100 , 3 ) as '2Day', --ABS((P1-N1)/P1)*100
--case 
--when  b1.TOTTRDQTY <> 0 OR  b1.TOTTRDQTY = 0    then   (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
--when  b2.TOTTRDQTY <> 0 OR  b2.TOTTRDQTY = 0  then (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
--when  b3.TOTTRDQTY <> 0 OR  b3.TOTTRDQTY = 0   then  (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
--when  b4.TOTTRDQTY <> 0 OR  b4.TOTTRDQTY = 0  then  (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
--when  b5.TOTTRDQTY <> 0 OR  b5.TOTTRDQTY = 0   then  (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5
--else  (b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)

--end as 'AVERAGES '

--(b1.TOTTRDQTY+b2.TOTTRDQTY+b3.TOTTRDQTY+b4.TOTTRDQTY+b5.TOTTRDQTY)/5 as 'AVERAGES'
vr.[VAR] as 'VAR',
vr.ELM as 'ELM',
vr.ADDI as 'ADDI',
v.[var+el+adii],---=ROUNDUP(U1+IF(A1="IND",3*V1,IF(A1="FNO",3*V1+0,5*V1+0))+W1,0)+5,
convert(real ,sp.[SPANMgn] ) / 100 as [SPANMgn] ,
convert(real ,sp.[ExpMgn] ) /100 as [ExpMgn],
convert(real ,sp.[AddExpMgn] ) / 100 as [AddExpMgn],
--sp.[ExpMgn],
--sp.[AddExpMgn]  ,
round((f.FNOMAR * 100),2) as 'FNOMAR',--=(Y1+Z1+AA1)*100
case when v.[var+el+adii] > mx.maxvalues then v.[var+el+adii]
when mx.maxvalues> f.FNOMAR then mx.maxvalues
when tf.FNOIND is NULL AND( m.[ Category] in ('A','B','Q')
OR m.[ Category] like 'A%'  
OR m.[ Category] like 'B%' 
 OR m.[ Category] like 'Q%') then   38
 when tf.FNOIND is null and m.[ Category] ='C' then 50
when tf.FNOIND is null and  m.[ Category] = 'C10' then 60
when tf.FNOIND is null and  m.[ Category] = 'C20' then 70
when tf.FNOIND is null and  m.[ Category] = 'C25' then 75
when tf.FNOIND is null and  m.[ Category] = 'C30' then 80 
when tf.FNOIND is null and  m.[ Category] = 'C49' then 99
when tf.FNOIND IS NULL and m.[ Category] ='D'  then 100
when tf.FNOIND IS NULL and m.[ Category] ='E'  then 100
else (f.FNOMAR)
end as 'MAXIUMVALUE',--=ROUNDUP(MAX(X1,IF(A1="IND",25,IF(A1="FNO",30,38)),AB1),0)
bs.ScripCode as 'BSECode',
bs.ScripId as 'scripNameBSE',
im.I_M,--for a,b,q ( var+elm+5) , for C,D,E(var + elm+Addi+5)
case when sd.F23 in (11,12,13,14,15,16,20,21,22,33) then sd.F23 else ''end as 'ASM FLAG'
into  #temp1
from varvalues v inner join fnovalues f on v.[ scripcode] = f.[ scripcode]
inner join  marginreport m on v.[ scripcode]  = m.[ scripcode]
inner join maxvalue mx on m.[ scripcode] = mx.[ scripcode]
inner join imvalue im on m.[ scripcode] = im.[ scripcode]
inner join maxcatnew mxc on m.[ scripcode] = mxc.[ scripcode]
left     join tokeninfo tf on m.[ scripcode] = tf.TOKEN 
inner  join [dbo].[NSEM] ns on m.[ scripcode] = ns.Token
left  join  [catM] ca on m.[ Category] = ca.Category
inner join securitydata sd on m.[ scripcode] = sd.NEATCM
left join [dbo].[bhav1] b1 on m.ISINNO = b1.ISIN  and b1.SERIES not in ('BO','BL')
left join [dbo].[bhav2] b2 on m.ISINNO = b2.ISIN  and b2.SERIES not in ('BO','BL')
left join [dbo].[bhav3] b3 on m.ISINNO = b3.ISIN   and b3.SERIES not in ('BO','BL')
left join [dbo].[bhav4] b4 on m.ISINNO = b4.ISIN   and b4.SERIES not in ('BO','BL')
left join mdisin1 b5 on m.ISINNO = b5.ISIN and b5.SERIES not in ('BO','BL')
--left join [dbo].[bhav5] b5 on m.ISINNO = b5.ISIN   and b5.SERIES not in ('BO','BL')
--left  join   [dbo].[bhav6] b5 on ns.ISIN = b5.ISINNO and b5.SERIES not in ('BO','BL')  
inner join VARreport vr on m.ISINNO = vr.ISINNO
left join SPAN sp on m.[ Scrip_Name] = sp.Symbol and ns.Series = 'EQ'
left  join   BSEM bs on m.ISINNO = bs.ISIN 
where ns.series not in ('BE','BO','BZ','BL','BT','IT','SM','SG','ST','SZ') and 
vr.series not in ('BE','BO','BL','BZ','BT','IT','SM','SG','ST','SZ') 
--and m.ISINNO = 'INE216A08027'
group by tf.FNOIND,m.[ Category1],m.[ scripcode],m.ISINNO,m.[ Scrip_Name],ns.Series,b1.TOTTRDQTY,m.[ Category]
,b2.TOTTRDQTY,b3.TOTTRDQTY,
b4.TOTTRDQTY,b5.TOTTRDQTY,b3.[CLOSE],b4.[CLOSE],b5.[CLOSE],vr.[VAR],vr.ELM,vr.ADDI,sp.[SPANMgn] ,
sp.[ExpMgn],ca.Margin,
sp.[AddExpMgn],bs.ScripCode,bs.ScripId,v.[var+el+adii],f.FNOMAR,mx.maxvalues,im.I_M,sd.F23
order by  tf.FNOIND desc ;



 with Avgs as (

Select distinct   m.scripcode,
case 
when  b1.TOTTRDQTY <> 0 OR  b1.TOTTRDQTY = 0 then ([T-4V] + [T-3V] + [T-2V] + [T-1V] + T)/5
when  b2.TOTTRDQTY <> 0 OR  b2.TOTTRDQTY = 0 then ([T-4V] + [T-3V] + [T-2V] + [T-1V] + T)/5
when  b3.TOTTRDQTY <> 0 OR  b3.TOTTRDQTY = 0 then ([T-4V] + [T-3V] + [T-2V] + [T-1V] + T)/5
when  b4.TOTTRDQTY <> 0 OR  b4.TOTTRDQTY = 0 then ([T-4V] + [T-3V] + [T-2V] + [T-1V] + T)/5
when  b5.TOTTRDQTY <> 0 OR  b5.TOTTRDQTY = 0 then ([T-4V] + [T-3V] + [T-2V] + [T-1V] + T)/5
else ([T-4V] + [T-3V] + [T-2V] + [T-1V] + T)/5
end as 'AVEGRAGES'
from #temp1 m 
inner  join [dbo].[NSEM] ns on m.scripcode = ns.Token
left join [dbo].[bhav1] b1 on m.ISINNO = b1.ISIN  and b1.SERIES not in ('BO','BL')
left join [dbo].[bhav2] b2 on m.ISINNO = b2.ISIN  and b2.SERIES not in ('BO','BL')
left join [dbo].[bhav3] b3 on m.ISINNO = b3.ISIN   and b3.SERIES not in ('BO','BL')
left join [dbo].[bhav4] b4 on m.ISINNO = b4.ISIN   and b4.SERIES not in ('BO','BL')
left join [dbo].mdisin1 b5 on m.ISINNO = b5.ISIN   and b5.SERIES not in ('BO','BL')
where ns.series not in ('BE','BO','BZ','BL','BT','IT','SM','SG','ST','SZ')
group by m.scripcode,[T-4V],[T-3V],[T-2V],[T-1V],T,b1.TOTTRDQTY,b2.TOTTRDQTY
,b3.TOTTRDQTY,b4.TOTTRDQTY,b5.TOTTRDQTY
),
--ISNULL(@Product1 / NULLIF(@Product2,0),0)
dayvalues as (
Select distinct m.scripcode,
round ((abs(ISNULL((TRate-[T-1Rate])/NULLIF(TRate,0),0)))* 100 ,3 ) as '1Day', --ABS((P1-O1)/P1)*100
round ((abs(ISNULL((TRate-[T-2Rate])/NULLIF(TRate,0),0)))* 100 , 3 ) as '2Day' --ABS((P1-N1)/P1)*100

from #temp1 m 
inner  join [dbo].[NSEM] ns on m.scripcode = ns.Token
left join [dbo].[bhav3] b3 on m.ISINNO = b3.ISIN   and b3.SERIES not in ('BO','BL')
left join [dbo].[bhav4] b4 on m.ISINNO = b4.ISIN   and b4.SERIES not in ('BO','BL')
left join [dbo].mdisin1 b5 on  m.ISINNO = b5.ISIN   and b5.SERIES not in ('BO','BL')
where ns.series not in ('BE','BO','BZ','BL','BT','IT','SM','SG','ST','SZ')
group by m.scripcode,TRate,[T-1Rate],[T-2Rate]
),

 CTE as (

select distinct t.scripcode ,
case when FNOIND = 'IND' and ceiling(MAXIUMVALUE) between 15 and 99 and t.BASE <> 999 then catn.Q
 --when FNOIND = 'IND' and ceiling(MAXIUMVALUE) between 15 and 99 and m.Base = 'A' then m.Category
 --when FNOIND = 'IND' and ceiling(MAXIUMVALUE) between 15 and 99 and m.Base = 'B' then m.Category

--when FNOIND = 'IND' and ceiling(MAXIUMVALUE) between 15 and 99 and b.Base = 'B%' then b.Category
--when FNOIND = 'IND' and ceiling(MAXIUMVALUE) between 15 and 99 and (q.Base = 'Q%' or q.Base = 'Q')  then q.Category
--when FNOIND = 'IND' and ceiling(MAXIUMVALUE) between 15 and 99 and a.Base = 'A' then a.Category
when FNOIND = 'FNO' and ceiling(MAXIUMVALUE) between 25 and 99 and t.BASE <> 999 then catn.A
when FNOIND Is null  and ceiling(MAXIUMVALUE) between 33 and 99 and t.BASE <> 999 then catn.B
when FNOIND IS NULL and ceiling(MAXIUMVALUE) between  50 and 99 and  
(t.CAT not like 'A%' OR t.CAT not like 'B%' OR t.CAT not like 'Q%') and t.BASE = 999 then CAT
when FNOIND IS NULL and ceiling(MAXIUMVALUE) between  100 and 115 and  
(t.CAT not like 'A%' OR t.CAT not like 'B%' OR t.CAT not like 'Q%') and t.BASE = 999 then CAT
when FNOIND IS NULL and ceiling(MAXIUMVALUE) = 100  and  
(t.CAT not like 'A%' OR t.CAT not like 'B%' OR t.CAT not like 'Q%') and t.BASE = 999 then CAT
--when FNOIND is null  and (t.CAT not in ('A','B','Q') OR t.CAT not like 'A%'
--OR t.CAT not like 'B%' OR t.CAT not like 'Q%' and c.Base = 'C'
--and ceiling(MAXIUMVALUE) between  50 and 99) then  catn.C
--when FNOIND is null  and (t.CAT not in ('A','B','Q') OR t.CAT not like 'A%'
--OR t.CAT not like 'B%' OR t.CAT not like 'Q%' and d.Base = 'D'
--and ceiling(MAXIUMVALUE) between  100 and 115) then  catn.D
--when FNOIND is null  and (t.CAT not in ('A','B','Q') OR t.CAT not like 'A%'
--OR t.CAT not like 'B%' OR t.CAT not like 'Q%' and e.Base ='E'
--and ceiling(MAXIUMVALUE) = 100 ) then catn.E
else CAT
end as 'NEWCAT'
from #temp1 t 
--left join catc c on t.MAXIUMVALUE = c.Margin
--left join catd d on t.MAXIUMVALUE = d.Margin
--left join cate e on t.MAXIUMVALUE = e.Margin
left join catmarnew catn on t.MAXIUMVALUE = catn.margin
--left join cate a on t.MAXIUMVALUE = a.Margin
--left join cate b on t.MAXIUMVALUE = b.Margin
--left join cate q on t.MAXIUMVALUE = q.Margin
--LEFT join CATM m on t.MAXIUMVALUE = m.Margin
group by t.scripcode,FNOIND,MAXIUMVALUE,t.CAT,catn.Q,catn.A,catn.B,catn.C,catn.D,catn.E,t.BASE
--,a.Category,b.Category,q.Category,a.Base,b.Base,q.Base
--,m.Base,m.Category
),

CTE1 as (

select t.scripcode , 
case when t.FNOIND ='IND' then 20 
else 25 
end as 'mxc'
from #temp1 t 
 ),

CTE2 as (

Select t1.scripcode,
case when c1.mxc > I_M then c1.mxc
when I_M > c1.mxc then I_M
else 25 
end as 'MAXCAT'
from #temp1 t1 inner join CTE1 c1 on t1.scripcode = c1.scripcode
 ),

CTE3 as (

Select    t.scripcode,
case when FNOIND = 'IND' and CEILING(MAXCAT) between 15 and 99  then catn.Q
when ceiling(c2.MAXCAT)>=100 then catn.D

--when FNOIND = 'FNO' and ceiling(MAXCAT) between 25 and 99 and t.BASE <> 999 then catn.A
--when FNOIND Is null  and ceiling(MAXCAT) between 33 and 99 and t.BASE <> 999 then catn.B
--when FNOIND IS NULL and ceiling(MAXCAT) between  50 and 99 and  
--(t.CAT_1 not like 'A%' OR t.CAT_1 not like 'B%' OR t.CAT_1 not like 'Q%') and t.BASE = 999 then catn.C
--when FNOIND IS NULL and ceiling(MAXCAT) between  100 and 115 and  
--(t.CAT_1 not like 'A%' OR t.CAT_1 not like 'B%' OR t.CAT_1 not like 'Q%') and t.BASE = 999 then catn.D
--when FNOIND IS NULL and ceiling(MAXCAT) = 100  and  
--(t.CAT_1 not like 'A%' OR t.CAT_1 not like 'B%' OR t.CAT_1 not like 'Q%') and t.BASE = 999 then catn.E
--when FNOIND is null  and (t.CAT not in ('A','B','Q') OR t.CAT not like 'A%'
--OR t.CAT not like 'B%' OR t.CAT not like 'Q%' and c.Base = 'C'
--and ceiling(MAXIUMVALUE) between  50 and 99) then  catn.C
--when FNOIND is null  and (t.CAT not in ('A','B','Q') OR t.CAT not like 'A%'
--OR t.CAT not like 'B%' OR t.CAT not like 'Q%' and d.Base = 'D'
--and ceiling(MAXIUMVALUE) between  100 and 115) then  catn.D
--when FNOIND is null  and (t.CAT not in ('A','B','Q') OR t.CAT not like 'A%'
--OR t.CAT not like 'B%' OR t.CAT not like 'Q%' and e.Base ='E'
--and ceiling(MAXIUMVALUE) = 100 ) then catn.E
else  catn.A
end as 'CAT1NEW'
from #temp1 t inner join CTE2 c2 on t.scripcode = c2.scripcode
--left join catc c on c2.MAXCAT = c.Margin
--left join catd d on c2.MAXCAT = d.Margin
--left join cate e on c2.MAXCAT = e.Margin
left join catmarnew catn on ceiling(c2.MAXCAT) = catn.margin
--left join cate a on c2.MAXCAT = a.Margin
--left join cate b on c2.MAXCAT = b.Margin
--left join cate q on c2.MAXCAT = q.Margin 

group by t.scripcode,FNOIND,MAXCAT,catn.A,catn.Q,catn.D
)



select  distinct ROW_NUMBER() over (Partition by t.ISINNO order by FNOIND) as 'rownn',
isnull(FNOIND,' ')as FNOIND
,CAT_1,ISINNO,t.scripcode,[Symbol Series],Series,CAT,BASE,[T-4V],[T-3V],[T-2V],[T-1V],[T]
,[T-2Rate],[T-1Rate],[TRate],[1Day],[2Day],AVEGRAGES
,[VAR],ELM,ADDI,[var+el+adii],
ISNULL ([SPANMgn],0) as [SPANMgn%]
,ISNULL ([ExpMgn],0) as [ExpMgn%]
,ISNULL ([AddExpMgn],0) as [AddExpMgn%]
,isnull (FNOMAR,0) as FNOMAR,
Case when MAXIUMVALUE > 100 then 100 
else ceiling(MAXIUMVALUE)
end as 'MAXIUMVALUE'
,c.NEWCAT
,t.BSECode
,t.scripNameBSE
,I_M,
Case when c2.MAXCAT > 100 then 100 
else ceiling(c2.MAXCAT)
end as 'MAXCAT'
,c3.CAT1NEW
,[ASM FLAG]
into #final
from 
#temp1 t inner join CTE2 c2 on t.scripcode = c2.scripcode
inner join CTE c on t.scripcode = c.scripcode
inner join CTE3 c3 on t.scripcode = c3.scripcode
inner join Avgs a on t.scripcode =a.scripcode 
inner join dayvalues d on t.scripcode = d.scripcode
where rownn   = 1 
--and ISINNO = 'IN0020220102'
--and [SPANMgn%] <> 0 
group by FNOIND,CAT_1,ISINNO,t.scripcode,[Symbol Series],Series,CAT,BASE,[T-4V],[T-3V],[T-2V],[T-1V],[T]
,[T-2Rate],[T-1Rate],[TRate],d.[1Day],d.[2Day],AVEGRAGES,[VAR],ELM,ADDI,[var+el+adii],ISINNO,
[SPANMgn]
,[ExpMgn],[AddExpMgn],FNOMAR,MAXIUMVALUE,
c.NEWCAT,
t.BSECode,t.scripNameBSE
,I_M,
c2.MAXCAT,
c3.CAT1NEW,
[ASM FLAG]


order by FNOIND desc


select *  from #final where rownn =1 
--and BASE = 999 and MAXCAT between 50 and 99 
--and FNOIND = 'IND'
--and CAT1NEW is null 
--and MAXCAT =100
--and ISINNO ='INE264T01014'
--and ISINNO = 'INE043D01016'
--and BASE <>999 and MAXCAT = '100'
--and BASE = 999 and CAT1NEW like 'Q%'
--AND MAXIUMVALUE ='30'
--and NEWCAT like 'C%'

order by FNOIND desc  



----select [VAR],ELM,ADDI,[var+el+adii],MAXIMUMVALUE,* from #final where CAT = 'D'  or CAT like 'C%'

--select  f.FNOIND,f.FNOMAR,f.[var+el+adii],f.CAT,f.MAXIMUMVALUE ,[FNO Mar],m.[VAR+XEML+Addi],m.Max ,f.ISINNO,f.ISINNO from #final f inner join mainsct m on 
--f.ISINNO = m.ISINNO
--where    f.MAXIMUMVALUE <> m.[Max]


--select if(c2.MAXCAT>100,c2.MAXCAT,c2.MAXCAT) from #final where  ISINNO ='INE253B01015'
--and f.scripcode = 1624

--select * from mainsct
--=ROUNDUP(MAX(X1,IF(A1="IND",25,IF(A1="FNO",30,38)),AB1),0)

--x1 = var+adii+elm
--a1 = FNOIND
--ab1 = fnomar v
 
--max(14,25,30)
--=ROUNDUP(U1+IF(A1="IND",3*V1,IF(A1="FNO",3*V1+0,5*V1+0))+W1,0)+5
--=ROUNDUP(U1+IF(A1="IND",3*V1,IF(A1="FNO",3*V1+0,5*V1+0))+W1,0)+5

--u1 = var,a1 = ind/fno

--= Roundup(VAR+ (if Index scrip then 3 else 
--		If FNO scrip then 3 else
--		rest if category is not (C_%_%,D,E) then 5 ) * ELM
--		+ Addi
--		+ Cousion %
--		If C_%_%,D or E then
--		rouundup (VAR+ELM+Addi + + Cousion,50),0

--And same time If Index then Min 25,
--		If FNO then Min 30,
--		Rest Bxx will be Min 38
--		C_%_%,D,E min 50

--select top 1 *  from spanreport
--select top 1 * from marginreport

--select top 1 * from VARreport
----select * from securitydata

----select * from[dbo].[CATM] 

----alter table [bhav1]
----add TOTALTRDQTY INT
----select * from [dbo].[bhav1] where ISIN = 'INE001A01036'

----select [ Category1],* from marginreport

 
---- select *  from [dbo].[NSEM]

-- select  ISIN I ,  * from [dbo].[BSEM] order by ISIN
 
-- where ISIN <> 'NULL'



--select top 1  * from marginreport order  by 1 

--select top 100 *  from tokeninfo



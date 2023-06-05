--CD\D:\MG13Peakdocsandscripts\MG13_Peak\MG13all 

CD /D D:\MG13Peakdocsandscripts\MG13_Peak\MG13all
rename MCX_PeakMargin56360_*_02.csv MCX1.rpt
rename MCX_PeakMargin56360_*_04.csv MCX2.rpt
rename MCX_PeakMargin56360_*_05.csv MCX3.rpt
rename MCX_PeakMargin56360_*_06.csv MCX4.rpt

rename NCCL_MARGIN_REP_01266_*_01.csv NCDX1.rpt
rename NCCL_MARGIN_REP_01266_*_02.csv NCDX2.rpt
rename NCCL_MARGIN_REP_01266_*_03.csv NCDX3.rpt
rename NCCL_MARGIN_REP_01266_*_04.csv NCDX4.rpt

rename NCL_BFX_Intraday_MGTM_07604_*_01.csv CUR1.rpt
rename NCL_BFX_Intraday_MGTM_07604_*_02.csv CUR2.rpt
rename NCL_BFX_Intraday_MGTM_07604_*_03.csv CUR3.rpt
rename NCL_BFX_Intraday_MGTM_07604_*_04.csv CUR4.rpt


rename NCL_CM_Intraday_MGTM_07604_*_01.csv CASH1.rpt
rename NCL_CM_Intraday_MGTM_07604_*_02.csv CASH2.rpt
rename NCL_CM_Intraday_MGTM_07604_*_03.csv CASH3.rpt
rename NCL_CM_Intraday_MGTM_07604_*_04.csv CASH4.rpt

rename NCL_COM_Intraday_MGTM_07604_*_01.csv COMD1.rpt
rename NCL_COM_Intraday_MGTM_07604_*_02.csv COMD2.rpt
rename NCL_COM_Intraday_MGTM_07604_*_03.csv COMD3.rpt
rename NCL_COM_Intraday_MGTM_07604_*_04.csv COMD4.rpt

rename NCL_FO_Intraday_MGTM_07604_*_01.csv FNO1.rpt
rename NCL_FO_Intraday_MGTM_07604_*_02.csv FNO2.rpt
rename NCL_FO_Intraday_MGTM_07604_*_03.csv FNO3.rpt
rename NCL_FO_Intraday_MGTM_07604_*_04.csv FNO4.rpt


for %f in (CASH1.rpt) do UNIX2DOS %f

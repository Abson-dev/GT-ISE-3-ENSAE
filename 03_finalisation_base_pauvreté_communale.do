********************************************************************************
* 								Initial
********************************************************************************

*********************
*       BENIN		*
*********************
clear
cd "C:/Users/Administrator/Desktop/GT2025/GT-ISE-3-ENSAE/00_Data/01_OUTPUTS/00_EHCVM/BEN"

use "communal_statpoverty_ben2021", clear

keep COUNTRY GID_0 NAME_1 GID_1 NAME_2 GID_2 NAME_3 GID_3 TYPE_3 mean_p0 sd_p0 cv_p0 

order COUNTRY GID_0 NAME_1 GID_1 NAME_2 GID_2 NAME_3 GID_3 TYPE_3 mean_p0 sd_p0 cv_p0
save "communal_statpoverty_ben2021", replace
export delimited using "communal_statpoverty_ben2021.csv", replace

*********************
*    BURKINA FASO   *
*********************
clear
cd "C:/Users/Administrator/Desktop/GT2025/GT-ISE-3-ENSAE/00_Data/01_OUTPUTS/00_EHCVM/BFA"

use "communal_statpoverty_bfa2021", clear

keep ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE ADM3_FR ADM3_PCODE mean_p0 sd_p0 cv_p0 AREA_SQKM

order ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE ADM3_FR ADM3_PCODE mean_p0 sd_p0 cv_p0 AREA_SQKM

save "communal_statpoverty_bfa2021", replace
********************************************************************************

*********************
*    COTE D'IVOIRE  *
*********************
clear
cd "C:/Users/Administrator/Desktop/GT2025/GT-ISE-3-ENSAE/00_Data/01_OUTPUTS/00_EHCVM/CIV"

use "communal_statpoverty_civ2021", clear

keep ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE ADM3_FR ADM3_PCODE mean_p0 sd_p0 cv_p0 AREA_SQKM

order ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE ADM3_FR ADM3_PCODE mean_p0 sd_p0 cv_p0 AREA_SQKM

save "communal_statpoverty_civ2021", replace
********************************************************************************

*********************
*    NIGER   		*
*********************
clear
cd "C:/Users/Administrator/Desktop/GT2025/GT-ISE-3-ENSAE/00_Data/01_OUTPUTS/00_EHCVM/NER"

use "communal_statpoverty_ner2021", clear

keep ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE ADM3_FR ADM3_PCODE mean_p0 sd_p0 cv_p0 AREA_SQKM

order ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE ADM3_FR ADM3_PCODE mean_p0 sd_p0 cv_p0 AREA_SQKM

save "communal_statpoverty_ner2021", replace
********************************************************************************


*********************
*       TOGO   		*
*********************
clear
cd "C:/Users/Administrator/Desktop/GT2025/GT-ISE-3-ENSAE/00_Data/01_OUTPUTS/00_EHCVM/TGO"

use "communal_statpoverty_tgo2021", clear

keep ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE   mean_p0 sd_p0 cv_p0 AREA_SQKM

order ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE   mean_p0 sd_p0 cv_p0 AREA_SQKM

save "communal_statpoverty_tgo2021", replace
********************************************************************************
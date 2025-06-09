


********************************************************************************
* 								Initial
********************************************************************************
local ehcvm_output_dir "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\01_OUTPUTS\00_EHCVM"
local shapefile_input_dir "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\03_SHAPEFILES"

********************************************************************************
*********************
*       BENIN		*
*********************
clear
cd "`ehcvm_output_dir'/BEN"
use "ben_taux_pauvreté_commune", clear
merge 1:1  NAME_3 NAME_2  using "`shapefile_input_dir'/BEN/ben_gadm", keep(1 2 3) //... pour s'assurer de retenir les communes dans lesquels se retrouvent les menages du fichier welfare. c'est une mesure de prudence non au cas ou une des bases aurait subit des dommages en pertes de ligne d'observation selon l'unité statistique considéré dans celle ci
drop _merge

//use "communal_statpoverty_ben2021", clear

keep COUNTRY GID_0 NAME_1 GID_1 NAME_2 GID_2  mean_p0 fgt0_var stderr  echant_menages_commune totpoids_commune region_hhsize Averag_household_size2013 csp_cm agriculture femmeCM_2013 NAME_3 GID_3   //meanp0_se

order COUNTRY GID_0 NAME_1 GID_1 NAME_2 GID_2  mean_p0 fgt0_var stderr echant_menages_commune  totpoids_commune region_hhsize Averag_household_size2013 csp_cm agriculture femmeCM_2013 NAME_3 GID_3   //meanp0_se
save "communal_statpoverty_ben2021", replace
//export delimited using "communal_statpoverty_ben2021.csv", replace

*********************
*    BURKINA FASO   *
*********************
clear
cd "`ehcvm_output_dir'/BFA"

use "bfa_taux_pauvreté_commune", clear
merge 1:1 ADM3_FR ADM2_FR  using "`shapefile_input_dir'/BFA/bfa_adminboundaries_tabulardata", keep(1 2 3)

keep ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE ADM3_FR ADM3_PCODE mean_p0 fgt0_var  stderr echant_menages_commune totpoids_commune region_hhsize csp_cm  agriculture AREA_SQKM  //meanp0_se

order ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE ADM3_FR ADM3_PCODE mean_p0 fgt0_var  stderr echant_menages_commune totpoids_commune region_hhsize csp_cm  agriculture AREA_SQKM  //meanp0_se

save "communal_statpoverty_bfa2021", replace
********************************************************************************

*********************
*    COTE D'IVOIRE  *
*********************
clear
cd "`ehcvm_output_dir'/CIV"

use "civ_taux_pauvreté_commune", clear
merge 1:1 ADM3_FR ADM2_FR  using "`shapefile_input_dir'/CIV/civ_adminboundaries_tabulardata", keep(1 2 3)


keep ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE ADM3_FR ADM3_PCODE mean_p0 fgt0_var stderr AREA_SQKM totpoids_commune

order ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE ADM3_FR ADM3_PCODE mean_p0 fgt0_var stderr AREA_SQKM totpoids_commune

save "communal_statpoverty_civ2021", replace
********************************************************************************

*********************
*    NIGER   		*
*********************
clear
cd "`ehcvm_output_dir'/NER"

use "ner_taux_pauvreté_commune", clear
merge 1:1 ADM3_FR ADM2_FR  using "`shapefile_input_dir'/NER/ner_admgz_ignn_20230720", keep(1 2 3)

keep ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE ADM3_FR ADM3_PCODE mean_p0 fgt0_var stderr AREA_SQKM totpoids_commune

order ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE ADM3_FR ADM3_PCODE mean_p0 fgt0_var stderr AREA_SQKM totpoids_commune

save "communal_statpoverty_ner2021", replace
********************************************************************************


*********************
*        TOGO   	*
*********************
clear
cd "`ehcvm_output_dir'/TGO"

use "tgo_taux_pauvreté_commune", clear
merge 1:1 ADM1_FR ADM2_FR  using "`shapefile_input_dir'/TGO/tgo_adminboundaries_tabulardata", keep(1 2 3)

keep ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE mean_p0 fgt0_var stderr AREA_SQKM totpoids_commune

order ADM0_FR ADM0_PCODE ADM1_FR ADM1_PCODE ADM2_FR ADM2_PCODE mean_p0 fgt0_var stderr AREA_SQKM totpoids_commune

save "communal_statpoverty_tgo2021", replace
*******************************************************************************
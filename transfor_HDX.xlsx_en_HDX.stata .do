clear all
	// 1. Définition les chemins de base et le répertoire de sortie
				
local root_dir "C:/Users/Administrator/Desktop/GT2025/GT-ISE-3-ENSAE/00_Data/00_INPUTS/03_SHAPEFILES"  
local output_dir "C:/Users/Administrator/Desktop/GT2025/GT-ISE-3-ENSAE/00_Data/01_OUTPUTS/00_EHCVM"  
		****************************************************************


********************************************************************************
*                         Base Benin
********************************************************************************

import excel "`root_dir'/BEN/ben_gadm.xlsx", sheet("gadm41_ben_3") cellrange(A1:P547) firstrow

save "`root_dir'/BEN/ben_gadm.dta",replace



 *******************************************************************************
 *									Base du Niger
 *******************************************************************************
 clear
 import excel "`root_dir'/NER/ner_admgz_ignn_20230720.xlsx", sheet("ADM3") cellrange(A1:M267) firstrow

 save "`root_dir'/NER/ner_admgz_ignn_20230720.dta",replace
 

  *******************************************************************************
 *									Base du Senegal
 *******************************************************************************
clear
 import excel  "`root_dir'/SEN/GADM Senegal 2024.xlsx", cellrange(A1:N434) firstrow 
 
  save "`root_dir'/SEN/sen_admgz_anat_20240520.dta" , replace

  ***********************************************************************************
  *               					 Cote d'ivoire
  ***********************************************************************************
 clear
 import excel "`root_dir'/CIV/civ_adminboundaries_tabulardata.xlsx", sheet("ADM3") firstrow
  
 save "`root_dir'/CIV/civ_adminboundaries_tabulardata.dta", replace

 *************************************************************************************
 * 										Togo
 *************************************************************************************
 clear
import excel "`root_dir'/TGO/tgo_adminboundaries_tabulardata.xlsx", sheet("ADM2") firstrow
  
save "`root_dir'/TGO/tgo_adminboundaries_tabulardata.dta", replace
**********************************************************************************
*                            Base du Mali
**********************************************************************************
clear
/*
import excel "`root_dir'/MLI/mli_adminboundaries_tabulardata.xlsx", sheet("Admin3") cellrange(A1:R702) firstrow

save "`root_dir'/MLI/mli_adminboundaries_tabulardata.dta", replace
*/

import excel "`root_dir'/MLI/MLI_gadm.xlsx", sheet("gadm41_mli_4") cellrange(A1:N705) firstrow

save "`root_dir'/MLI/MLI_gadm.dta", replace

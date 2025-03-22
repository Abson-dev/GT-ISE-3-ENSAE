



***************************************************************************
				// 1. Définition les chemins de base et le répertoire de sortie
clear all			
local root_dir "C:/Users/Administrator/Desktop/GT2025/GT-ISE-3-ENSAE/00_Data" 
 
local input_dir "`root_dir'/00_INPUTS"
local output_dir "`root_dir'/01_OUTPUTS"

local ehcvm_input_dir "`input_dir'/00_EHCVM"
local ehcvm_output_dir "`output_dir'/00_EHCVM"

********************************************************************************
*                     Benin
********************************************************************************
cd "`ehcvm_input_dir'/BEN/BEN_2021_EHCVM-2_v01_M_STATA14"
use "ehcvm_individu_ben2021", clear
merge m:1 vague grappe hhid menage  using "ehcvm_welfare_ben2021", keep(1 2 3) // pour s'assurer de retenir les communes dans lesquels se retrouvent les menages du fichier welfare. c'est une mesure de prudence non au cas ou une des bases aurait subit des dommages en pertes de ligne d'observation selon l'unité statistique considéré dans celle ci
drop _merge
/*
decode departement, gen(departement_)
decode commune, gen(commune_)
collapse (last) departement=departement_ commune=commune_ , by(arrondissement)
save "`ehcvm_output_dir'/BEN/ben_decoupadmin_welfare.dta", replace
*/
save "`ehcvm_output_dir'/BEN/ben_welfare_individu.dta", replace

********************************************************************************


********************************************************************************
*                     Burkina faso
********************************************************************************
cd "`ehcvm_input_dir'/BFA/BFA_2021_EHCVM-2_v01_M_Stata"
use "ehcvm_individu_bfa2021", clear
merge m:1 vague grappe hhid menage  using "ehcvm_welfare_2b_bfa2021", keep(1 2 3) // pour s'assurer de retenir les communes dans lesquels se retrouvent les menages du fichier welfare. c'est une mesure de prudence non au cas ou une des bases aurait subit des dommages en pertes de ligne d'observation selon l'unité statistique considéré dans celle ci
drop _merge

/*
decode region, gen(region_)
decode province, gen(province_)
collapse (last) region=region_ province=province_, by(commune)
save "`ehcvm_output_dir'/BFA/bfa_decoupadmin_welfare.dta", replace
*/
save "`ehcvm_output_dir'/BFA/bfa_welfare_individu.dta", replace

********************************************************************************


********************************************************************************
*                     Cote d'ivoire
********************************************************************************
cd "`ehcvm_input_dir'/CIV/CIV_2021_EHCVM-2_v01_M_STATA14"
use "ehcvm_individu_civ2021", clear
merge m:1 vague grappe hhid menage  using "ehcvm_welfare_civ2021", keep(1 2 3) // pour s'assurer de retenir les communes dans lesquels se retrouvent les menages du fichier welfare. c'est une mesure de prudence non au cas ou une des bases aurait subit des dommages en pertes de ligne d'observation selon l'unité statistique considéré dans celle ci
drop _merge

/*
decode region, gen(region_)
decode departement, gen(departement_)
collapse (last) region=region_ departement=departement_, by(sp_commune)
save "`ehcvm_output_dir'/CIV/civ_decoupadmin_welfare.dta", replace
*/
save "`ehcvm_output_dir'/CIV/civ_welfare_individu.dta", replace
********************************************************************************



********************************************************************************
*                     niger
********************************************************************************
cd "`ehcvm_input_dir'/NER/NER_2021_EHCVM-2_v01_M_STATA14"
use "ehcvm_individu_ner2021", clear
merge m:1 vague grappe hhid menage  using "ehcvm_welfare_ner2021", keep(1 2 3) 
drop _merge

/*
decode region, gen(region_)
decode departement, gen(departement_)
collapse (last) region=region_ departement=departement_, by(commune)
save "`ehcvm_output_dir'/NER/ner_decoupadmin_welfare.dta", replace
*/
save "`ehcvm_output_dir'/NER/ner_welfare_individu.dta", replace

********************************************************************************



********************************************************************************
*                     Togo
********************************************************************************
cd "`ehcvm_input_dir'/TGO/TGO_2021_EHCVM-2_v01_M_STATA14"
use "ehcvm_individu_tgo2021", clear
merge m:1 vague grappe hhid menage  using "ehcvm_welfare_tgo2021", keep(1 2 3)
drop _merge

/*
decode region, gen(region_)
collapse (last) region=region_, by(prefecture)
save "`ehcvm_output_dir'/TGO/tgo_decoupadmin_welfare.dta", replace
*/
save "`ehcvm_output_dir'/TGO/tgo_welfare_individu.dta", replace

********************************************************************************


********************************************************************************
*                     mali
********************************************************************************




********************************************************************************




********************************************************************************
*                     GNB
********************************************************************************




********************************************************************************








********************************************************************************
*                     Senegal
********************************************************************************
cd "`ehcvm_input_dir'/SEN/SEN_2021_EHCVM-2_v01_M_STATA14"
use "ehcvm_individu_sen2021", clear
merge m:1 vague grappe hhid menage  using "ehcvm_welfare_sen2021", keep(1 2 3) // pour s'assurer de retenir les communes dans lesquels se retrouvent les menages du fichier welfare. c'est une mesure de prudence non au cas ou une des bases aurait subit des dommages en pertes de ligne d'observation selon l'unité statistique considéré dans celle ci
drop _merge
/*
decode region, gen(region_)
decode departement, gen(departement_)
collapse (last) region=region_ departement=departement_, by(commune)
*/

save "`ehcvm_output_dir'/SEN/sen_welfare_individu.dta", replace
********************************************************************************
*/





















/*
//pointer sur les dossiers contenants les bases ehcvm
cd "`ehcvm_input_dir'"
local folders : dir . dirs "*"

foreach folder of local folders {
****************************************************************
			// 1. récupérer les 03 premieres lettres du nom du dossier

			local ref= lower(substr("`folder'", 1, 3))

****************************************************************
			// 2. Boucle sur les fichiers Excel dans le dossier HDX
	
			// Accédons au sous-dossier correspondant
            cd "`ehcvm_input_dir'/`folder'"
			local dossier : dir . dirs "*"
			foreach doss of local dossier {
				// Extraction les trois premiers caractères du nom du fichier Excel
				local code_doss= lower(substr("`doss'", 1, 3))
				
				if strpos("`code_doss'","`ref'"){
				       cd "`ehcvm_input_dir'/`folder'/`doss'"
					   local data_files : dir . files "*.dta"
					   //local chaine1 "ehcvm_welfare"
					   local chaine2 "ehcvm_individu"
					   foreach ind of local data_files {
							if strpos("`ind'","`chaine2'"){
							// 3. appeler la base sur stata 
							use "`ind'", clear
							foreach welf of local data_files {
							if strpos("`welf'","`chaine1'"){
								merge m:1 vague grappe hhid menage  using "`welf'", keep(1 2 3) // pour s'assurer de retenir les communes dans lesquels se retrouvent les menages du fichier welfare. c'est une mesure de prudence non au cas ou une des bases aurait subit des dommages en pertes de ligne d'observation selon l'unité statistique considéré dans celle ci.
								if strpos("`ref'","sen"){
								decode region, gen(region_)
								decode departement, gen(departement_)
								
								collapse (last) regin=region_ departement=departement_, by(commune)
								}
							  }
							save "`ehcvm_output_dir'/`folder'/`ref'_decoupadmin_welfare.dta", replace 
							}
					   }
					   
						}
					}
				}
*/
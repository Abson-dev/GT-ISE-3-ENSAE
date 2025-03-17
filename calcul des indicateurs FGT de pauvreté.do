***************************************************************************
				// 1. Définition les chemins de base et le répertoire de sortie
clear all			
local root_dir "C:/Users/Administrator/Desktop/GT2025/GT-ISE-3-ENSAE/00_Data" 
 
local input_dir "`root_dir'/00_INPUTS"
local output_dir "`root_dir'/01_OUTPUTS"

local ehcvm_input_dir "`input_dir'/00_EHCVM"
local ehcvm_output_dir "`output_dir'/00_EHCVM"

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
					   local welf_files : dir . files "*.dta"
					   local chaine "ehcvm_welfare"
					   foreach name of local welf_files {
							if strpos("`name'","`chaine'"){
							// 3. Calcul de l'indicateur FGT P0=incidence de la pauvreté
				
							use "`name'", clear
							capture drop dif p0
							gen dif=zref-pcexp
							gen p0=100*(dif>0)
							save "`ehcvm_output_dir'/`folder'/`name'_copie.dta", replace 
							}
					   }
					   
						}
					}
				}
							
					   
	

				
						





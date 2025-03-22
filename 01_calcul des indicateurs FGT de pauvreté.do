***************************************************************************
				// 1. Définition les chemins de base et le répertoire de sortie
clear all			
local root_dir "C:/Users/Administrator/Desktop/GT2025/GT-ISE-3-ENSAE/00_Data" 
 
local input_dir "`root_dir'/00_INPUTS"
local output_dir "`root_dir'/01_OUTPUTS"

local ehcvm_input_dir "`input_dir'/00_EHCVM"
local ehcvm_output_dir "`output_dir'/00_EHCVM"

//pointer sur les dossiers contenants les bases ehcvm
cd "`ehcvm_output_dir'"
local folders : dir . dirs "*"

foreach folder of local folders {
****************************************************************
			// 1. récupérer les 03 premieres lettres du nom du dossier

			local ref= lower(substr("`folder'", 1, 3))

****************************************************************
			// 2. Boucle sur les fichiers Excel dans le dossier HDX
	
			// Accédons au sous-dossier correspondant
            cd "`ehcvm_output_dir'/`folder'"
		    local files : dir . files "*.dta"
			 foreach name of local files {
					if strpos("`name'","welfare") & strpos("`name'","individu") {
					// 3. Calcul de l'indicateur FGT P0=incidence de la pauvreté
					use "`name'", clear
					capture drop dif p0
					gen dif=zref-pcexp
					
					gen p0=(dif>0)
*********************************************************************************
					// 4. calculer la moyenne au niveau des communes
					
					if strpos("`ref'","ben"){
								decode departement, gen(departement_)
								decode commune, gen(commune_)
								gen hhweight_round=round(hhweight)
								
								preserve
								collapse (last) departement=departement_ commune=commune_ (mean) mean_p0=p0 (sd) sd_p0=p0 [fw=hhweight_round], by(arrondissement)
								gen cv_p0=sd_p0/mean_p0
								save "`ehcvm_output_dir'/`folder'/`ref'_taux_pauvreté_commune", replace 
								restore
								//collapse  mean_p0=p0 (sd) sd_p0=p0 [fw=hhweight_round], by(milieu)
								//save "`ehcvm_output_dir'/`folder'/`ref'_taux_pauvreté_milieu_residence", replace 

								}
********************************************************************************
					if strpos("`ref'","bfa"){
							decode region, gen(region_)
							decode province, gen(province_)
							gen hhweight_round=round(hhweight)
							  
							preserve
							collapse (last) region=region_  province=province_ (mean) mean_p0=p0 (sd) sd_p0=p0 [fw=hhweight_round], by(commune)
							gen cv_p0=sd_p0/mean_p0
							save "`ehcvm_output_dir'/`folder'/`ref'_taux_pauvreté_commune", replace 
							restore
							/*
							preserve
							collapse  (mean) mean_p0=p0 (sd) sd_p0=p0 [fw=hhweight_round], by(milieu)
							save "`ehcvm_output_dir'/`folder'/`ref'_taux_pauvreté_milieu_residence", replace 
							restore
							*/
							}
********************************************************************************
					if strpos("`ref'","civ"){
							decode region, gen(region_)
							decode departement, gen(departement_)
							gen hhweight_round=round(hhweight)
							  
							preserve
							collapse (last) region=region_  departement=departement_ (mean) mean_p0=p0 (sd) sd_p0=p0 [fw=hhweight_round], by(sp_commune)
							gen cv_p0=sd_p0/mean_p0
							save "`ehcvm_output_dir'/`folder'/`ref'_taux_pauvreté_commune", replace 
							restore
							/*
							preserve
							collapse  (mean) mean_p0=p0  [pw=hhweight_round], by(milieu)
							save "`ehcvm_output_dir'/`folder'/`ref'_taux_pauvreté_milieu_residence", replace 
							restore
							*/
							}
********************************************************************************

					if strpos("`ref'","ner"){
						decode region, gen(region_)
						decode departement, gen(departement_)
						gen hhweight_round=round(hhweight)
						  
						preserve
						collapse (last) region=region_  departement=departement_ (mean) mean_p0=p0 (sd) sd_p0=p0 [fw=hhweight_round], by(commune)
						gen cv_p0=sd_p0/mean_p0
						save "`ehcvm_output_dir'/`folder'/`ref'_taux_pauvreté_commune", replace 
						restore
						/*
						preserve
						collapse  (mean) mean_p0=p0  [pw=hhweight_round], by(milieu)
						save "`ehcvm_output_dir'/`folder'/`ref'_taux_pauvreté_milieu_residence", replace 
						restore
						*/
						}
********************************************************************************

					if strpos("`ref'","tgo"){
									decode region, gen(region_)
									gen hhweight_round=round(hhweight)
									  
									preserve
									collapse (last) region=region_  (mean) mean_p0=p0 (sd) sd_p0=p0 [fw=hhweight_round], by(prefecture)
									gen cv_p0=sd_p0/mean_p0
									save "`ehcvm_output_dir'/`folder'/`ref'_taux_pauvreté_commune", replace 
									restore
									/*
									preserve
									collapse  (mean) mean_p0=p0  [pw=hhweight_round], by(milieu)
									save "`ehcvm_output_dir'/`folder'/`ref'_taux_pauvreté_milieu_residence", replace 
									restore
									*/
										}
				
					
********************************************************************************
					
					if strpos("`ref'","sen"){
						decode region, gen(region_)
						decode departement, gen(departement_)
						gen hhweight_round=round(hhweight)
						
						collapse (last) region=region_ departement=departement_  (mean) mean_p0=p0  (sd) sd_p0=p0 [fw=hhweight_round], by(commune)
						gen cv_p0=sd_p0/mean_p0
						save "`ehcvm_output_dir'/`folder'/`ref'_taux_pauvreté_commune", replace 

						/*			
						collapse  (mean) mean_p0=p0 (sd) sd_p0=p0 [fw=hhweight_round*hhsize], by(milieu)
						save "`ehcvm_output_dir'/`folder'/`ref'_taux_pauvreté_milieu_residence", replace 
						*/
						}
					
					}
			   }
			   
		}


		
				





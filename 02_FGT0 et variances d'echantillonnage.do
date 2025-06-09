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
			// 2. Boucle sur les fichiers stata
	
			// Accédons au sous-dossier correspondant
            cd "`ehcvm_output_dir'/`folder'"
		    local files : dir . files "*.dta"
			 foreach name of local files {
					if strpos("`name'","communal_statpoverty_")>0 {
					// 3. Calcul de l'indicateur FGT P0=incidence de la pauvreté
					use "`name'", clear
					//capture drop dif p0
					cap gen dif=zref-pcexp

					cap gen p0=(dif>0)
					cap gen hhsize_weight=hhsize*hhweight 
*********************************************************************************

				// Exemple : définir la variable correspondant aux communes selon le pays
					if "`ref'" == "ben" {
						local commune_var "GID_3"
						local region_var "GID_1"
						local ind_id "numind"
						cap local supplement_var region_hhsize femmeCM_2013 Averag_household_size2013 csp_cm agriculture NAME_2 GID_2 NAME_3 NAME_1 GID_1
					}
					else if "`ref'" == "bfa" {
						local commune_var "ADM3_PCODE"
						local region_var "ADM1_PCODE"
						local ind_id "pid"
						cap local supplement_var region_hhsize csp_cm  agriculture prop_mur_provisoire AREA_SQK ADM2_FR ADM2_PCODE ADM3_FR ADM1_FR ADM1_PCODE
						replace p0=p0/100
					}
					else if "`ref'" == "civ" {
						local commune_var "ADM3_PCODE"
						local region_var "ADM1_PCODE"
						local ind_id "numind"
						cap local supplement_var AREA_SQK ADM2_FR ADM2_PCODE ADM1_PCODE ADM1_FR ADM3_FR 
					}
					else if "`ref'" == "ner" {
						local commune_var "ADM3_PCODE"
						local region_var "ADM1_PCODE"
						local ind_id "numind"
						cap local supplement_var AREA_SQK ADM2_FR ADM2_PCODE ADM1_PCODE ADM1_FR ADM3_FR
					}
					else if "`ref'" == "tgo" {
						local commune_var "ADM2_PCODE"
						local region_var "ADM1_PCODE"
						local ind_id "numind"
						cap local supplement_var AREA_SQK ADM1_FR ADM1_PCODE  ADM2_FR
					}

***************************************************************************************************************
					*  representativité des communes dans l'echantillon et la population *
					**********************************************************************
					
	*--->>>   decompte du menage dans l'echantillon et estimation dans la population
				/// Créer une variable marqueur : 1 seule fois par ménage
					gen tag_menage = 1
					bysort `commune_var' vague hhid grappe menage : replace tag_menage =. if _n > 1

					/// Compter le nombre de ménages par commune
					gen echant_menages_commune =. //crée une nouvelle variable vide qu'on va remplir.
					bysort `commune_var': replace echant_menages_commune = sum(tag_menage) if tag_menage==1  //cumule les 1 du tag_menage par commune, donc compte les menages de sorte qu'À la fin du tri de chaque commune, la dernière ligne contient le nombre total de ménages de cette commune dans l'echantillon.
					
					//bysort GID_3 hhid: replace echant_menages_commune = echant_menages_commune[_N] //remplace les lignes de la commune (donc donne a tout les individus) la dernière valeur (donc le total) pour chaque commune.
					
					//gen popmenages_commune=.
					bysort `commune_var'  : egen popmenages_commune = total(hhweight) if tag_menage==1 //la dernière ligne contient le nombre total de ménages de cette commune dans la population.
					 

				///
*......*1) En important les tailles moyennes des menages du recensement de 2013 au benin, il n'y avait pas l'info sur cotonou. Par abus, Je me sert alors de l'ehcvm pour estimer cette valeur au niveau de ce departement dans la feuille (02_calcul des indicateurs FGT de pauvreté)
***********************************************************************************************************
				    cap replace Averag_household_size2013=region_hhsize if NAME_2=="Cotonou"

					save "`ehcvm_output_dir'/`folder'/`ref'_stat_poverty_data", replace

					preserve
					keep if tag_menage==1 
					collapse (lastnm)  echant_menages_commune (sum) totpoids_commune=tag_menage (last)  `supplement_var'  [pw=hhsize_weight], by(`commune_var')
					save "`ehcvm_output_dir'/`folder'/`ref'_pop_estimate",replace
					restore
					

						*(on revient a la base en memoire initiale)
						
****************************************************************************************
					cap replace Averag_household_size2013=region_hhsize if NAME_2=="Cotonou"

					save "`ehcvm_output_dir'/`folder'/`ref'_stat_poverty_data", replace

					keep if tag_menage==1
					keep `region_var' `commune_var' milieu p0 hhsize_weight

					* Créer groupe pour stratification
					egen groupe_croise = group(`region_var' milieu)

					* Déclaration du plan
					svyset [pw=hhsize_weight], strata(groupe_croise)

					* Créer id numérique pour commune
					encode `commune_var', gen(commune_id)

					* Calcul de la moyenne par commune_id
					svy: mean p0, over(commune_id)

					* Extraire résultats
					matrix b = e(b)
					matrix V = e(V)
					levelsof commune_id, local(ids)

					* Obtenir correspondance commune_id -> nom
					preserve
					keep commune_id `commune_var'
					duplicates drop
					gen commune_name = `commune_var'
					tempfile labels
					save `labels', replace
					restore

					* Création du dataset résultat
					clear
					set obs `=wordcount("`ids'")'
					gen commune_id = .
					gen commune = ""
					gen mean = .
					gen stderr = .
					gen ci_lb = .
					gen ci_ub = .

					local i = 1
					foreach id in `ids' {
						replace commune_id = `id' in `i'
						replace mean = b[1,`i'] in `i'
						replace stderr = sqrt(V[`i',`i']) in `i'
						replace ci_lb = mean[`i'] - invnormal(0.975)*stderr[`i'] in `i'
						replace ci_ub = mean[`i'] + invnormal(0.975)*stderr[`i'] in `i'
						local ++i
					}

					* Rétablir les noms de communes
					merge 1:1 commune_id using `labels', nogenerate
					rename mean mean_p0
					gen fgt0_var=stderr^2
					
					merge 1:1  `commune_var' using "`ehcvm_output_dir'/`folder'/`ref'_pop_estimate", keep(1 2 3)
					drop _merge
					* Sauvegarde
					save "`ehcvm_output_dir'/`folder'/`ref'_taux_pauvreté_commune", replace

				
					
**********************************************************************************
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
********************************************************************************
					
					}
			   }
			   
		}


		
				





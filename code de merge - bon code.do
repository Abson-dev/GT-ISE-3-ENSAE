		***************************************************************************
				// 1. Définition les chemins de base et le répertoire de sortie
				
local root_dir "C:/Users/Administrator/Desktop/GT2025/GT-ISE-3-ENSAE/00_Data/00_INPUTS"  
local output_dir "C:/Users/Administrator/Desktop/GT2025/GT-ISE-3-ENSAE/00_Data/01_OUTPUTS/00_EHCVM"  
		****************************************************************
	cd "`root_dir'/03_SHAPEFILES"
    local folders : dir . dirs "*"

    foreach folder of local folders {	
****************************************************************
			// 2. Boucle sur les fichiers Excel dans le dossier HDX
	
			// Accédons au sous-dossier correspondant
            cd "`root_dir'/03_SHAPEFILES/`folder'"
			local hdx_files : dir . files "*.dta"

			foreach hdx_file of local hdx_files {
				// Extraction les trois premiers caractères du nom du fichier Excel
				local ref_code_excel = lower(substr("`hdx_file'", 1, 3))
				
				// Importation la feuille spécifique du fichier Excel dans Stata avec la première ligne comme en-tête
			   
				use "`hdx_file'",  clear
				tempfile hdx_data
				save `hdx_data', replace

				// Harmoniser les variables clés dans la base Excel importée
			 
				gen commune_clean = lower(ADM3_FR)   // pour cle de commune
				gen departement_clean = lower(ADM2_FR) // pour cle de departement
				gen region_clean = lower(ADM1_FR)  //  pour cle de region
				
				local var_list_clean  commune_clean departement_clean region_clean
										
				foreach var of local var_list_clean {
				
						// Remplacons tous les tirets(de 6 et de 8), parenthèses, et autres caractères spéciaux
						replace `var' = regexr(`var', "-", " ")
						replace `var' = regexr(`var', "_", " ")
						
						// Supprimons les accents dans les variables _clean
						replace `var' = ustrregexra(`var', "[éèêë]", "e")
						replace `var' = ustrregexra(`var', "[àâä]", "a")
						replace `var' = ustrregexra(`var', "[îï]", "i")
						replace `var' = ustrregexra(`var', "[ôö]", "o")
						replace `var'= ustrregexra(`var', "[ùûü]", "u")
						replace `var' = ustrregexra(`var', "[ç]", "c")
						
						// Remplacons les chiffres en fin de chaîne par des numéros romains
						replace `var' = subinstr(`var', " 1", "i", .)
						replace `var' = subinstr(`var', " 2", "ii", .)
						replace `var' = subinstr(`var', " 3", "iii", .)
						replace `var' = subinstr(`var', " 4", "iv", .)
						replace `var' = subinstr(`var', " 5", "v", .)
						
						// supprimons les espaces et apostrophes entre caracteres pour chaque variable
						replace `var' =subinstr(`var', "'", "", .)
						replace `var'=subinstr(`var', " ", "", .)
						
				}
				
				
				
				save `hdx_data', replace  // Sauvegarder la version harmonisée
				
					****************************************************************************
						// 3. Parcourons les sous-dossiers de "00_EHCVM" à la recherche de ehcvm_individu
						
				cd "`root_dir'/00_EHCVM"
				local subfolders : dir . dirs "*"

				foreach subfolder of local subfolders {
					// Extraction les trois premiers caractères du sous-dossier
					local ref_code_folder = lower(substr("`subfolder'", 1, 3))

					// Vérifions la correspondance des codes
					if "`ref_code_excel'" == "`ref_code_folder'" {
						// Accédons au sous-dossier correspondant
						cd "`root_dir'/00_EHCVM/`subfolder'"
						local inner_folders : dir . dirs "*"

						foreach inner_folder of local inner_folders {
							local ref_code_inner = lower(substr("`inner_folder'", 1, 3))

							if "`ref_code_excel'" == "`ref_code_inner'" {
								// Parcourons les fichiers Stata dans le sous-sous-dossier trouvé
								cd "`root_dir'/00_EHCVM/`subfolder'/`inner_folder'"
								local stata_files : dir . files "*.dta"

								foreach stata_file of local stata_files {
									if strpos("`stata_file'", "ehcvm_individu") {
										// Importons la base "individu"
										use "`root_dir'/00_EHCVM/`subfolder'/`inner_folder'/`stata_file'", clear
										tempfile individu_data
										save `individu_data', replace
										
										** Recherchons  les variables contenant "commune, departement, region" et renommer
										
										foreach var of varlist _all {
											if strpos("`var'", "commune") > 0 {
												rename `var' commune
											}
										}
										
										foreach var of varlist _all {
											if strpos("`var'", "departement") > 0 {
												rename `var' departement
											}
										}
										
										foreach var of varlist _all {
											if strpos("`var'", "region") > 0 {
												rename `var' region
											}
										}

									
										* definissons une liste de variable contenant les cles
										local var_list commune  departement  region
										
										* creons a partir des cles, les variables qui seront traitées
										foreach var of local var_list {
										
											** Vérifions si la variable est numérique. Nous la dedoublerons efficacement en fonction de cela.
												capture confirm numeric variable `var'
												
												if !_rc {
												
											** Si la variable est numérique, applique decode
													decode `var', gen(`var'_text)  // Crée `var_text` avec les labels textuels
													
												} 
												else {
												
											** Si la variable est déjà sous format string, la conserve telle quelle
													clonevar `var'_text=`var'  // Crée `var_text` par clonage de var
													
												}
												
										}
										
										

										* transformons en minuscules pour éviter les problèmes de casse
										gen commune_clean = lower(commune_text)
										gen departement_clean = lower(departement_text)
										gen region_clean = lower(region_text)

										// Nettoyons la variable commune_text pour supprimer les termes inutiles

										replace commune_clean = subinstr(commune_clean, "arrondissement", "", .)
										replace commune_clean = subinstr(commune_clean, "bloc", "", .)
										replace commune_clean = subinstr(commune_clean, "district", "", .)
										replace commune_clean = subinstr(commune_clean, "zone", "", .)

										local var_list_clean  commune_clean departement_clean region_clean
										
										foreach var of local var_list_clean {
										
												// Remplacons tous les tirets(6 et 8)
												replace `var' = regexr(`var', "-", " ")
												replace `var' = regexr(`var', "_", " ")
												
												// Supprimons les accents dans les variables _clean
												replace `var' = ustrregexra(`var', "[éèêë]", "e")
												replace `var' = ustrregexra(`var', "[àâä]", "a")
												replace `var' = ustrregexra(`var', "[îï]", "i")
												replace `var' = ustrregexra(`var', "[ôö]", "o")
												replace `var'= ustrregexra(`var', "[ùûü]", "u")
												replace `var' = ustrregexra(`var', "[ç]", "c")
												
												// Remplacons les chiffres en fin de chaîne par des numéros romains
												replace `var' = subinstr(`var', " 1", "i", .)
												replace `var' = subinstr(`var', " 2", "ii", .)
												replace `var' = subinstr(`var', " 3", "iii", .)
												replace `var' = subinstr(`var', " 4", "iv", .)
												replace `var' = subinstr(`var', " 5", "v", .)
												
												
												
												* Extraction les noms de commune, département et région sans les informations entre parenthèses
												* Identifions la position de la parenthèse ouvrante
												gen pos_paren`var' = strpos(`var', "(")
												
												* Gardons uniquement le texte avant la parenthèse ouvrante, si elle existe
												replace `var' = substr(`var', 1, pos_paren`var' - 1) if pos_paren`var' > 0
												
												* Supprimons les espaces et  apostrophes en trop
												replace `var' =subinstr(`var', "'", "", .)
										
												replace `var' =subinstr(`var', " ", "", .)
												
												* Supprimons la variable temporaire utilisée pour la position de la parenthèse
												drop pos_paren`var'
												
										}
										
										
										

							************************************************************************************************
							
							****Traitement inehrent aux pays*****
										if "`ref_code_excel'" == "ner" {
											replace departement_clean = "magaria" if commune_clean=="dantchiao"
											replace region_clean="zinder" if commune_clean=="dantchiao"
											
											replace departement_clean = "malbaza" if commune_clean=="doguerawa"
											replace region_clean="tahoua" if commune_clean=="doguerawa"
											
											replace departement_clean = "dogondoutchi" if commune_clean=="dogondoutchi"
											replace region_clean="dosso" if commune_clean=="dogondoutchi"
									
											replace departement_clean = "ouallam" if commune_clean=="tondikiwindi"
											replace region_clean="tillaberi" if commune_clean=="tondikiwindi"
											
											replace departement_clean = "mayahi" if commune_clean=="guidanamoumoune"
											replace region_clean="madari" if commune_clean=="guidanamoumoune"
					
											replace departement_clean = "dakoro" if commune_clean=="sabonmachi"
											replace region_clean="madari" if commune_clean=="saesaboua"

											replace departement_clean = "mirriah" if commune_clean=="dogo"
											replace region_clean="zinder" if commune_clean=="dogo"
											
											replace departement_clean = "tessaoua" if commune_clean=="hawandawaki"
											replace region_clean="madari" if commune_clean=="hawandawaki"
											
											replace departement_clean = "madarounfa" if commune_clean=="sarkinyamma"
											replace region_clean="madari" if commune_clean=="sarkinyamma"

											replace departement_clean = "dungass" if commune_clean=="dogodogo"
											replace region_clean="zinder" if commune_clean=="dogodogo"
										
										}
										************************************************
										
										if "`ref_code_excel'" == "civ" {
											replace commune_clean = "arrah" if commune_clean=="arrha"
											replace departement_clean = "arrah" if departement_clean=="arrha"

											
											replace commune_clean = "niakaramandougou" if commune_clean=="niakaramadougou"		
											replace departement_clean="niakaramandougou" if departement_clean=="niakaramadougou"
											
											replace commune_clean = "bedigaozon" if commune_clean=="bedygoazon"
									
											replace commune_clean = "bilimono" if commune_clean=="bilimoro"
											
											replace commune_clean = "dibriassirikro" if commune_clean=="dibriasrikro"
											
											replace commune_clean = "gnanmangui" if commune_clean=="gnamangui"
											
											replace commune_clean = "goudouko" if commune_clean=="godouko"
											
											replace commune_clean = "grandzatry" if commune_clean=="grandzattry"
											
											replace commune_clean = "kokoumbo" if commune_clean=="kokumbo"
											
											
											replace commune_clean = "kouassidatekro" if commune_clean=="kouassidattekro"
											
											replace commune_clean = "guezon" if commune_clean=="guezonduekoue" | commune_clean=="guezonfacobly"
											
											replace commune_clean = "kouassianiaguini" if commune_clean=="kouassiniaguni"											
											
											replace commune_clean = "lolobo" if commune_clean=="lolobodebeoumi"
											
											replace commune_clean = "marandallah" if commune_clean=="marhandallah"
											
											replace commune_clean = "nafana" if commune_clean=="nafanaprikro"
											
											replace commune_clean = "nzecrezessou" if commune_clean=="nzekressessou"											
											replace departement_clean="gbeleban" if departement_clean=="gbelegban"

											replace commune_clean="santa"   if commune_clean=="santadeouaninou"
											replace commune_clean="sediogo" if commune_clean=="sediego"
											}
										
										
										
			************************************************************************************************************************************													
										save `individu_data', replace  // Sauvegarder la version harmonisée de ehcvm_individu
										
										// 5. MERGE AVEC LES AUTRES BASES ehcvm_menage et ehcvm_welfare DU DOSSIER INPUT
											
									*************************************************************************************************	
										
										// 6. MERGE DE LA BASE HARMONISEE EHCVM AVEC LA BASE HDX NETTOYEE
										
										use `individu_data', clear
										merge m:1 commune_clean departement_clean  using `hdx_data', keep(1 2 3) 
										
								   ****************************************************************************************************

										// 7. SAUVEGARDER LA BASE FINALE OBTENUE
										save "`output_dir'/`folder'/ehcvm_individu_`ref_code_excel'2021_hdx.dta", replace
									}
								}
							}
						}
					}
				}
			}
		}

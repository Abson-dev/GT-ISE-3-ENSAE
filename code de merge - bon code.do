		***************************************************************************
				// 1. Définition les chemins de base et le répertoire de sortie
clear all			
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
				local pays_HDX "bfa ner civ"
				local pays_GADM "sen"
				local varlist_comm "ADM3_FR admin3Name_fr"
				local varlist_dep "ADM2_FR admin2Name_fr"
				
				
				if strpos("`pays_HDX'","`ref_code_excel'"){
				
					foreach var in `varlist_comm'{
						capture confirm variable `var'
						if _rc==0{
							gen commune_clean = lower(`var')   // pour cle de commune
							}
						}
						
						
						foreach var in `varlist_dep'{
						capture confirm variable `var'
						if _rc==0{
							gen departement_clean = lower(`var') // pour cle de departement
							}
						}
				}
				
				if strpos("sen","`ref_code_excel'"){
					gen commune_clean = lower(NAME_4)   // pour cle de commune
					gen departement_clean = lower(NAME_2) // pour cle de departement
				}
				
				if strpos("ben","`ref_code_excel'"){
					gen commune_clean = lower(NAME_3)   // pour cle de commune d'arrondissement
					gen departement_clean = lower(NAME_2) // pour cle de departement
				}
				
				if strpos("tgo","`ref_code_excel'"){
					gen commune_clean = lower(ADM2_FR)   // pour cle de prefecture
					gen departement_clean = lower(ADM1_FR) // pour cle du niveau superieur
				}
				
				if strpos("mli","`ref_code_excel'"){
					gen commune_clean = lower(NAME_4)   // pour cle de COMMUNE
					gen departement_clean = lower(NAME_2) // pour cle de PREFECTURE/CERCLE
				}
				//nettoyons la variable cle commune des termes susceptibles d'empecher la fusion
				replace commune_clean = subinstr(commune_clean, "arrondissement", "", .)
				replace commune_clean = subinstr(commune_clean, "arrondissemen", "", .)
				replace commune_clean = subinstr(commune_clean, "arrondisement", "", .)

				replace commune_clean = subinstr(commune_clean, "bloc", "", .)
				replace commune_clean = subinstr(commune_clean, "district", "", .)
				replace commune_clean = subinstr(commune_clean, "zone", "", .)

				
							
				local var_list_clean commune_clean departement_clean
				
				
										
				foreach var of local var_list_clean {
				
						// Remplacons tous les tirets(de 6 et de 8), parenthèses, et autres caractères spéciaux
						replace `var' = regexr(`var', "-", " ")
						replace `var' = regexr(`var', "_", " ")
						replace `var' = ustrregexra(`var', "[*&'?/!’;]", " ")
						
						// Supprimons les accents dans les variables _clean
						replace `var' = ustrregexra(`var', "[éèêëÉÈ]", "e")
						replace `var' = ustrregexra(`var', "[àâä]", "a")
						replace `var' = ustrregexra(`var', "[îïÏ]", "i")
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
						
						// Extraction les noms de commune, département et région sans les informations entre parenthèses
						* Identifions la position de la parenthèse ouvrante
						gen pos_paren`var' = strpos(`var', "(")
						
						* Gardons uniquement le texte avant la parenthèse ouvrante, si elle existe
						replace `var' = substr(`var', 1, pos_paren`var' - 1) if pos_paren`var' > 0
						
						* Supprimons les espaces et  apostrophes en trop
						replace `var' =subinstr(`var', "'", "", .)
				
						replace `var' =subinstr(`var', " ", "", .)
						
						// Supprimons la variable temporaire utilisée pour la position de la parenthèse
						drop pos_paren`var'

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
										
										** Recherchons  les variables clés et renommons les
										
										//////////////////////////////////
										
										if "`ref_code_excel'" == "ben" {
											foreach var of varlist _all {
												if strpos("`var'", "arrondissement") > 0 {
													clonevar comm=`var'
												}
											}
											
											foreach var of varlist _all {
												if strpos("`var'", "commune") > 0 {
													clonevar depart =`var'
												}
											}
										}
										
										/////////////////////////////////
										
										if "`ref_code_excel'" == "bfa" {
											foreach var of varlist _all {
												if strpos("`var'", "commune") > 0 {
													clonevar comm=`var'
												}
											}
										
											foreach var of varlist _all {
												if strpos("`var'", "province") > 0 {
													clonevar depart =`var'
												}
											}
										}
										
										/////////////////////////////////
										
										if "`ref_code_excel'" == "ner" {
											foreach var of varlist _all {
												if strpos("`var'", "commune") > 0 {
													clonevar comm=`var'
												}
											}
										
											foreach var of varlist _all {
												if strpos("`var'", "departement") > 0 {
													clonevar depart =`var'
												}
											}
											
											
										}
										
										/////////////////////////////
										
										if "`ref_code_excel'" == "mli" {
											foreach var of varlist _all {
												if strpos("`var'", "commune") > 0 {
													clonevar comm=`var'
												}
											}
										
											foreach var of varlist _all {
												if strpos("`var'", "prefecture") > 0 {
													clonevar depart =`var'
												}
											}
											
										}
										
										//////////////////////////////
										
										if "`ref_code_excel'" == "civ" {
											foreach var of varlist _all {
												if strpos("`var'", "commune") > 0 {
													clonevar comm=`var'
												}
											}
										
											foreach var of varlist _all {
												if strpos("`var'", "departement") > 0 {
													clonevar depart =`var'
												}
											}
											
											
										}
										
										/////////////////////////////
										
										if "`ref_code_excel'" == "sen" {
											foreach var of varlist _all {
												if strpos("`var'", "commune") > 0 {
													clonevar comm=`var'
												}
											}
										
											foreach var of varlist _all {
												if strpos("`var'", "departement") > 0 {
													clonevar depart =`var'
												}
											}
											
											
										}
										/////////////
										
										if "`ref_code_excel'" == "tgo" {
											foreach var of varlist _all {
												if strpos("`var'", "prefecture") > 0 {
													clonevar comm=`var'
												}
											}
										
											foreach var of varlist _all {
												if strpos("`var'", "region") > 0 {
													clonevar depart =`var'
												}
											}
											
											
										}
										
										
										
										

									
										* definissons une liste de variable contenant les cles
										local var_list comm  depart  //region_
										
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
										gen commune_clean = lower(comm_text)
										gen departement_clean = lower(depart_text)
										//gen region_clean = lower(region_text)

										// Nettoyons la variable commune_text pour supprimer les termes inutiles

										replace commune_clean = subinstr(commune_clean, "arrondissement", "", .)
										replace commune_clean = subinstr(commune_clean, "arrondissemen", "", .)
										replace commune_clean = subinstr(commune_clean, "arrondisement", "", .)

										replace commune_clean = subinstr(commune_clean, "bloc", "", .)
										replace commune_clean = subinstr(commune_clean, "district", "", .)
										replace commune_clean = subinstr(commune_clean, "zone", "", .)

										
										local var_list_clean  commune_clean departement_clean 
										
										foreach var of local var_list_clean {
										
												// Remplacons tous les tirets (6 et 8) et apostrophes
												replace `var' = regexr(`var', "-", " ")
												replace `var' = regexr(`var', "_", " ")
												replace `var' = ustrregexra(`var', "[*&'?/!’;]", " ")
												
												// Supprimons les accents dans les variables _clean
												replace `var' = ustrregexra(`var', "[éèêëÉÈ]", "e")
												replace `var' = ustrregexra(`var', "[àâä]", "a")
												replace `var' = ustrregexra(`var', "[îïÏ]", "i")
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
							
									   if "`ref_code_excel'" == "ben" {
									   					replace commune_clean = "13" if (commune_clean=="13eme" & departement_clean=="cotonou")
									   					replace commune_clean = "12" if (commune_clean=="12eme" & departement_clean=="cotonou")
									   					replace commune_clean = "11" if (commune_clean=="11eme" & departement_clean=="cotonou")
														replace commune_clean = "10" if (commune_clean=="10eme" & departement_clean=="cotonou")
														replace commune_clean = "9" if (commune_clean=="9eme" & departement_clean=="cotonou")
														replace commune_clean = "8" if (commune_clean=="8eme" & departement_clean=="cotonou")
														replace commune_clean = "7" if (commune_clean=="7eme" & departement_clean=="cotonou")
														replace commune_clean = "6" if (commune_clean=="6eme" & departement_clean=="cotonou")
														replace commune_clean = "5" if (commune_clean=="5eme" & departement_clean=="cotonou")
														replace commune_clean = "4" if (commune_clean=="4eme" & departement_clean=="cotonou")
														replace commune_clean = "3" if (commune_clean=="3eme" & departement_clean=="cotonou")
														replace commune_clean = "2" if (commune_clean=="2eme" & departement_clean=="cotonou")
														replace commune_clean = "1" if (commune_clean=="1er" & departement_clean=="cotonou")
														replace commune_clean = "calavi" if (commune_clean=="abomeycalavi" & departement_clean=="abomeycalavi")
														
														replace commune_clean = "i" if (commune_clean=="1er" & departement_clean=="parakou")
														replace commune_clean = "ii" if (commune_clean=="2eme" & departement_clean=="parakou")
														replace commune_clean = "iii" if (commune_clean=="3eme" & departement_clean=="parakou")
														
														replace commune_clean = "i" if (commune_clean=="1er" & departement_clean=="portonovo")
														replace commune_clean = "ii" if (commune_clean=="2eme" & departement_clean=="portonovo")
														replace commune_clean = "iii" if (commune_clean=="3eme" & departement_clean=="portonovo")
														replace commune_clean = "iv" if (commune_clean=="4eme" & departement_clean=="portonovo")
														replace commune_clean = "iv" if (commune_clean=="5eme" & departement_clean=="portonovo")
														replace commune_clean = "houngomey" if (commune_clean=="houngome")
														replace commune_clean = "kolokond" if (commune_clean=="koloconde")
														replace commune_clean = "patargo" if commune_clean=="partago"

														replace departement_clean = "klouekanme" if (departement_clean=="klouekanmey")
														replace departement_clean = "bohicon" if (commune_clean=="houngomey" & departement_clean=="zakpota")

														replace departement_clean = "lokossa" if (commune_clean=="adohoun")
														replace departement_clean = "djougourural" if inlist(commune_clean, "barei", "barienou", "bellefoungou", "bougou", "kolokond", "onklou", "patargo", "pelebina","serou")
														replace departement_clean = "dassazoume" if departement_clean=="dassa"
														replace departement_clean = "soava" if (departement_clean=="saova")
														
														replace commune_clean = "adjanhonme" if (commune_clean=="adjahonme")
														replace commune_clean = "aglangandan" if (commune_clean=="agblangandan")
														replace commune_clean = "agbopka" if (commune_clean=="agbokpa")
														replace commune_clean = "agou" if (commune_clean=="agoue")

														replace commune_clean = "ahouanonzou" if (commune_clean=="ahouannonzoun")
														replace commune_clean = "aklanpka" if (commune_clean=="aklampa")
														replace commune_clean = "allada" if (commune_clean=="alladacentre")
														replace commune_clean = "atocoligbe" if (commune_clean=="atokolibe")
														replace commune_clean = "atome" if (commune_clean=="atomey")
														replace commune_clean = "atogon" if (commune_clean=="attogon")
														replace commune_clean = "avloh" if (commune_clean=="avlo")
														replace commune_clean = "azohouekada" if (commune_clean=="azohouecada")
														replace commune_clean = "badazoui" if (commune_clean=="badazouin")
														replace commune_clean = "bouka" if (commune_clean=="bouca")
														replace commune_clean = "colliagbame" if (commune_clean=="colli")
														replace commune_clean = "koussi" if (commune_clean=="coussi")
														replace commune_clean = "soava" if (commune_clean=="saova")
														replace commune_clean = "dekpo" if (commune_clean=="dekpocentre")
														replace commune_clean = "dipoili" if (commune_clean=="dipoli")
														replace commune_clean = "djaloukou" if (commune_clean=="djalloukou" & departement_clean=="savalou")
														replace commune_clean = "djregbe" if (commune_clean=="djeregbe" & departement_clean=="semekpodji")

														replace departement_clean = "djougouurbain" if inlist(commune_clean, "djougoui", "djougouii", "djougouiii")
														replace commune_clean = "fotance" if commune_clean=="footance"
														replace commune_clean = "ganviei" if commune_clean=="ganvienbspi"
														replace commune_clean = "gbozounme" if commune_clean=="gbozoume"
														replace commune_clean = "gninagourou" if commune_clean=="guinagourou"
														replace commune_clean = "houenhounso" if commune_clean=="houinhounso"
														replace commune_clean = "kossoucoingou" if commune_clean=="koussoucoingou"
														replace commune_clean = "kemon" if commune_clean=="ikemon"
														
														replace commune_clean = "kouty" if commune_clean=="kouti"
														replace commune_clean = "kpomasse" if commune_clean=="kpomassecentre"
														replace commune_clean = "siwekpota" if (commune_clean=="kpota" & departement_clean=="agbangnizoun")
														replace commune_clean = "lissegan" if (commune_clean=="lissegazoun" & departement_clean=="allada")
														replace commune_clean = "natta" if commune_clean=="nata"
														replace commune_clean = "ofe" if commune_clean=="offe"
														replace commune_clean = "houedemeadja" if commune_clean=="ouedemeadja"
														replace commune_clean = "logozohoue" if commune_clean=="logozohe"
														replace commune_clean = "ii" if commune_clean=="ouidahii"
														replace commune_clean = "iii" if commune_clean=="ouidahiii"
														replace commune_clean = "iv" if commune_clean=="ouidahiv"
														replace commune_clean = "oungbegame" if commune_clean=="oumbegame"

														replace commune_clean = "natitingouiv" if commune_clean=="peporiyakou"
														replace commune_clean = "sazoue" if commune_clean=="sazue"
														replace commune_clean = "semekpodji" if commune_clean=="semepodji"
														replace commune_clean = "siwelego" if (commune_clean=="sinwe" & departement_clean=="agbangnizoun")
														replace commune_clean = "somprkou" if commune_clean=="somperoukou"
														replace commune_clean = "taiakou" if commune_clean=="taiacou"
														replace commune_clean = "tangbodjevie" if commune_clean=="tangbo"
														
														replace commune_clean = "tatonnoukon" if commune_clean=="tatonnonkon"
														replace commune_clean = "tchaorou" if (commune_clean=="tchaourou" & departement_clean=="tchaourou")
														replace commune_clean = "bossito" if (commune_clean=="toribossito" & departement_clean=="toribossito")
														replace commune_clean = "toucoutouna" if commune_clean=="toukountouna"
														replace commune_clean = "toumbouctou" if (commune_clean=="toumboutou" & departement_clean=="malanville")
														replace commune_clean = "torikada" if commune_clean=="toricada"
														replace commune_clean = "ouara" if commune_clean=="wara"
														replace commune_clean = "zounzounme" if commune_clean=="zounzonme"													
														replace commune_clean = "dekanme" if commune_clean=="dekanmey"													
														
									   }
											
											
							********************************************************************************************************
										if "`ref_code_excel'" == "bfa" {
														replace departement_clean = "kourittenga" if departement_clean=="kouritenga"
														replace departement_clean = "komandjari" if departement_clean=="komandjoari"
														replace commune_clean = "bitou" if commune_clean=="bittou"
														replace commune_clean = "ambsouya" if commune_clean=="absouya"
														replace commune_clean = "arbolle" if commune_clean=="arbole"

														//replace commune_clean = "bobodioulasso" if commune_clean==" bobodioulassodo"
														//replace commune_clean = "bobodioulasso" if commune_clean==" bobodioulassokonsa"
														
														replace commune_clean = "boken" if commune_clean=="bokin"
														replace commune_clean = "bomborokui" if commune_clean=="bomborokuy"
														replace commune_clean = "bondokui" if commune_clean=="bondokuy"
														replace commune_clean = "boudri" if commune_clean=="boudry"
														replace commune_clean = "dapeolgo" if commune_clean=="dapelogo"
														
														replace commune_clean = "dissihn" if commune_clean=="dissin"
														replace commune_clean = "gounguen" if commune_clean=="gounghin"
														replace commune_clean = "goursi" if commune_clean=="gourcy"
														replace commune_clean = "karangassovigue" if commune_clean=="karankassovigue"
														replace commune_clean = "kokologo" if commune_clean=="kokoloko"
														replace commune_clean = "latoden" if commune_clean=="latodin"
														replace commune_clean = "megue" if commune_clean=="meguet"
														replace commune_clean = "ouri" if commune_clean=="oury"
														replace commune_clean = "sabse" if commune_clean=="sabce"
														replace commune_clean = "samogogouan" if commune_clean=="samorogouan"
														replace commune_clean = "sangha" if commune_clean=="sanga"
														replace commune_clean = "soa" if commune_clean=="soaw"
														replace commune_clean = "tanguendassouri" if commune_clean=="tanghindassouri"
														replace commune_clean = "zeguedeguen" if commune_clean=="zeguedeguin"
														
														replace commune_clean = "kassou" if commune_clean=="cassou"
														replace commune_clean = "gbondjigui" if commune_clean=="bondigui"
														replace departement_clean = "boulgou" if commune_clean=="tenkodogo"
														replace commune_clean="bobodioulasso" if commune_clean=="bobodioulassodo" | commune_clean=="bobodioulassokonsa"
														replace commune_clean = "ouagadougou" if inlist(commune, "Arrondissement 1", "Arrondissement 2", "Arrondissement 3", "Arrondissement 4", "Arrondissement 5", "Arrondissement 6")
														replace commune_clean = "ouagadougou" if inlist(commune,"Arrondissement 7", "Arrondissement 8","Arrondissement 9", "Arrondissement 10", "Arrondissement 11", "Arrondissement 12")
														replace commune_clean = "bobodioulasso" if inlist(commune,"Arrondissement N 1", "Arrondissement N 2","Arrondissement N 3", "Arrondissement N 4", "Arrondissement N 5", "Arrondissement N 6", "Arrondissement N 7")
														replace commune_clean = "bobodioulasso" if inlist(commune_clean,"bobodioulassodo", "bobodioulassokonsa")

														
													}
													
			 			    ******************************************************************************************************				
										
										if "`ref_code_excel'" == "ner" {
											replace departement_clean = "magaria" if commune_clean=="dantchiao"
											//replace region_clean="zinder" if commune_clean=="dantchiao"
											
											replace departement_clean = "malbaza" if commune_clean=="doguerawa"
											//replace region_clean="tahoua" if commune_clean=="doguerawa"
											
											replace departement_clean = "dogondoutchi" if commune_clean=="dogondoutchi"
											//replace region_clean="dosso" if commune_clean=="dogondoutchi"
									
											replace departement_clean = "ouallam" if commune_clean=="tondikiwindi"
											//replace region_clean="tillaberi" if commune_clean=="tondikiwindi"
											
											replace departement_clean = "mayahi" if commune_clean=="guidanamoumoune"
											//replace region_clean="madari" if commune_clean=="guidanamoumoune"
					
											replace departement_clean = "dakoro" if commune_clean=="sabonmachi"
											//replace region_clean="madari" if commune_clean=="saesaboua"

											replace departement_clean = "mirriah" if commune_clean=="dogo"
											//replace region_clean="zinder" if commune_clean=="dogo"
											
											replace departement_clean = "tessaoua" if commune_clean=="hawandawaki"
											//replace region_clean="madari" if commune_clean=="hawandawaki"
											
											replace departement_clean = "madarounfa" if commune_clean=="sarkinyamma"
											//replace region_clean="madari" if commune_clean=="sarkinyamma"

											replace departement_clean = "dungass" if commune_clean=="dogodogo"
											//replace region_clean="zinder" if commune_clean=="dogodogo"
										
										}
										
							*****************************************************************************************************
										
										if "`ref_code_excel'" == "mli" {
											replace departement_clean = "bamako" if departement_clean=="districtdebamako"	
											replace commune_clean = "anderamboukane" if inlist(commune_clean,"anderanboukane","anderaboukane")
											replace commune_clean="menaka" if commune_clean=="communedemenaka"
											replace departement_clean="gourmarharous" if departement_clean=="gourmarha"
											replace commune_clean="tenenkou" if commune_clean=="tenenkoucentral"
											replace commune_clean="anderamboukane" if commune_clean=="anouzagrene"
											replace commune_clean="souboundou" if commune_clean=="soboundou"
											replace commune_clean="sitakily" if commune_clean=="sitakilly"
											replace departement_clean="sikasso" if commune_clean=="sikasso"
											replace commune_clean="seremoussaani" if commune_clean=="seremoussaanisamo"
											replace commune_clean="sebecoro1" if commune_clean=="sebecoroi"
											replace commune_clean="rharous" if commune_clean=="rharouss"
											replace commune_clean="niorocommune" if commune_clean=="nioro"
											replace commune_clean="niamananar" if commune_clean=="niamanadenara"
											replace commune_clean="ouattagouna" if commune_clean=="ouattagoun" 
											replace commune_clean="anderamboukane" if inlist(commune,"Anouzagrene kal talataye","Anouzagrene kal talaytette")
											replace commune_clean="baguineda" if commune_clean=="baguinedacamp" 
											replace commune_clean="banicane" if commune_clean=="banikane" 
											replace commune_clean="baraoueli" if commune_clean=="baroueli" 
											replace commune_clean="bayeken" if commune_clean=="baye" 
											replace commune_clean="ansongo" if commune_clean=="commune" & departement_clean=="ansongo"
											replace commune_clean="derrary" if commune_clean=="derary" & departement_clean=="djenne"
											replace commune_clean="dougoutene2" if commune_clean=="dougouteneii" & departement_clean=="koro"
											replace commune_clean="fakaladje" if commune_clean=="fakala" 
											replace commune_clean="fakolakol" if commune_clean=="fakola" 
											replace commune_clean="fakolokou" if commune_clean=="fakolo" 
											replace commune_clean="farabakat" if commune_clean=="faraba" 
											replace commune_clean="farakoseg" if commune_clean=="farakodesegou" 
											replace commune_clean="gadougou2" if commune_clean=="gadougouii" 
											replace commune_clean="rharous" if inlist(commune_clean,"gourmararousse","gourmaras")
											replace departement_clean="dire" if commune_clean=="haibongo" 
											
											replace commune_clean="tinessako" if inlist(commune_clean,"intadjedite" ,"intedjedite")
											replace departement_clean="kayescommune" if commune_clean=="kayes" 
											replace departement_clean="kitanord" if commune_clean=="kita"
											replace departement_clean="koulatom" if commune_clean=="kouladetominian"
											replace departement_clean="koulogonhabe" if commune_clean=="koulogonh"
											replace departement_clean="kourounikoto" if commune_clean=="kourouninkoto"
											replace departement_clean="marekaffo" if commune_clean=="marekafo"
											replace departement_clean="ngabacorodroit" if commune_clean=="ngabacoro"
											
											replace departement_clean="souboundou" if commune_clean=="niafunke"
											}
							******************************************************************************************************
										
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
											replace commune_clean="bobidiarabana" if commune_clean=="bobi"| commune_clean=="diarabana"
											replace departement_clean="soubre" if commune_clean=="gnanmangui"
											replace commune_clean="kadeko" if commune_clean=="gagore"

										}
										
								***************************************************************************************************
											
										if "`ref_code_excel'" == "sen" {
											replace departement_clean = "medinayorofoula" if departement_clean=="medinayorofoulah"
											
											replace departement_clean = "birkilane" if departement_clean=="birkelane"
											
											replace departement_clean = "malemehodar" if departement_clean=="malemhoddar"
											
											replace departement_clean = "niorodurip" if departement_clean=="nioro"
											
											replace departement_clean = "ranerouferlo" if departement_clean=="ranerou"
											
											replace commune_clean = "bambandiayene" if commune_clean=="bambathialene"
											replace commune_clean = "bambilor" if commune_clean=="bambylor"
											replace commune_clean = "bemetbidjini" if commune_clean=="benetbijini"
											replace commune_clean = "boulelgoumack" if commune_clean=="boulel"
											replace commune_clean = "bouroucou" if commune_clean=="bourouco"
											replace commune_clean = "gueuletapeecolobanefass" if commune_clean=="colobanefassgueuletapee"
											replace commune_clean = "dabiaobedji" if commune_clean=="dabia"
											replace commune_clean = "dakately" if commune_clean=="dakateli"
											replace commune_clean = "darhoukhoudoss" if commune_clean=="daroukhoudoss"
											replace commune_clean = "darouminameii" if commune_clean=="darouminamii"
											replace commune_clean = "diarrere" if commune_clean=="diarere"
											replace commune_clean = "dimboly" if commune_clean=="dimboli"
											replace commune_clean = "dindefello" if commune_clean=="dindifelo"
											replace commune_clean = "diembering" if commune_clean=="djembering"
											replace commune_clean = "djinaky" if commune_clean=="djinaki"
											replace commune_clean = "fongolimbi" if commune_clean=="fongolembi"
											replace commune_clean = "gainthekaye" if commune_clean=="gaintekaye"
											replace commune_clean = "keurmomarsarr" if commune_clean=="k.momarsarr"
											replace commune_clean = "keursambakane" if commune_clean=="k.sambakane"
											replace commune_clean = "keursaloumdiane" if commune_clean=="keurs.diane"
											replace commune_clean = "kouthiabaouolof" if commune_clean=="kouthiabawolof"
											replace commune_clean = "makacoulibantang" if commune_clean=="makacoulibatang"
											replace commune_clean = "mbelacadio" if commune_clean=="mbelacadiao"
											replace commune_clean = "medinaelhadj" if commune_clean=="medinaelhadji"
											replace commune_clean = "montroland" if commune_clean=="montrolland"
											replace commune_clean = "houdalaye" if commune_clean=="oudalaye"
											
											replace commune_clean = "prokhane" if commune_clean=="porokhane"
											replace commune_clean = "sarecolysale" if commune_clean=="sarecolysalle"
											replace commune_clean = "simbandibalante" if commune_clean=="simbadibalante"
											replace commune_clean = "sinthioumaleme" if commune_clean=="sinthioumalem"
											
										}
										
					**************************************************************************************************************
					
										if "`ref_code_excel'" == "tgo" {
											replace departement_clean = "maritime" if commune_clean=="golfe2"
											replace commune_clean = "golfe" if commune_clean=="golfe2"
											replace commune_clean = "plainedumo" if commune_clean=="sousprefecturedemo"
											replace commune_clean = "agoenyive" if (inlist(commune_clean, "i", "ii", "iii","iv", "v") & departement_clean=="grandlome")
											replace departement_clean = "maritime" if commune_clean=="agoenyive"
									   }
											
			*************************************************************************************************************************************************************												
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

clear all




******************************************************************
*							Benin
******************************************************************
local dir1 "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\01_OUTPUTS\00_EHCVM\BEN"
local dir2 "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\01_GEOSPATIAL DATA\BEN"


local files: dir "`dir2'" files "*.csv"  // Liste des fichiers Excel

use "`dir1'/communal_statpoverty_ben2021", clear
save "`dir1'/total_vardatabae_ben2021", replace
foreach file in `files' {
    import delimited "`dir2'/`file'", varnames(1) case(upper) clear  // Importer fichier Excel
    tempfile temp  // Créer un fichier temporaire
    save `temp'  // Sauvegarder temporairement
    
    use "`dir1'/total_vardatabae_ben2021", clear // Charger la base FGT0 direct estimate en mémoire
    merge 1:1 GID_3 using `temp'
    drop  _merge 
    
    save "`dir1'/total_vardatabae_ben2021", replace  // Sauvegarder la base mise à jour
}

rename (WALKING_ONLY_TRAVEL_TIME_TO_HEAL V3 V4 V5 V6 V8 V9 V10 V11 MOTORIZED_TRAVEL_TIME_TO_HEALTHC PRIMARY_SCHOOL_AGE_GIRL_BEN_2020 SECONDARY_SCHOOL_AGE_GIRL_BEN_20) (WALKING_ONLY_TRAVEL_TIME_min WALKING_ONLY_TRAVEL_TIME_max WALKING_ONLY_TRAVEL_TIME_mean WALKING_ONLY_TRAVEL_TIME_median WALKING_ONLY_TRAVEL_TIME_sd MOTORIZED_TRAVEL_TIME_max MOTORIZED_TRAVEL_TIME_mean MOTORIZED_TRAVEL_TIME_median MOTORIZED_TRAVEL_TIME_sd MOTORIZED_TRAVEL_TIME_min PRIMARY_SCHOOL_AGE_GIRL SECONDARY_SCHOOL_AGE_GIRL)
 // (PRIMARY_SCHOOL_AGE_GIRL_BEN_2020 SECONDARY_SCHOOL_AGE_GIRL_BEN_20) (PRIMARY_SCHOOL_AGE_GIRL SECONDARY_SCHOOL_AGE_GIRL)
save "`dir1'/total_vardatabae_ben2021", replace  // Sauvegarder la base mise à jour










******************************************************************
*							Burkina Faso
******************************************************************
clear all
local dir1 "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\01_OUTPUTS\00_EHCVM\BFA"
local dir2 "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\01_GEOSPATIAL DATA\BFA"


local files: dir "`dir2'" files "*.csv"  // Liste des fichiers Excel

use "`dir1'/communal_statpoverty_bfa2021", clear
save "`dir1'/total_vardatabae_bfa2021", replace
foreach file in `files' {
    import delimited "`dir2'/`file'", varnames(1) case(upper) clear  // Importer fichier Excel
  
    capture confirm variable ADM3_PCODE
if !_rc {
    // Si ADM3_PCODE existe, effectuer la fusion sur cette variable
    merge 1:1 ADM3_PCODE using "`dir1'/total_vardatabae_bfa2021"
}
else {
    capture confirm variable ADM2_PCODE
    if !_rc {
        // Si ADM3_PCODE n'existe pas mais ADM2_PCODE existe, fusionner sur ADM2_PCODE
        merge 1:m ADM2_PCODE using "`dir1'/total_vardatabae_bfa2021"
		}
	}
	
    drop  _merge 
    
    save "`dir1'/total_vardatabae_bfa2021", replace  // Sauvegarder la base mise à jour
}

rename (WALKING_ONLY_TRAVEL_TIME_TO_HEAL V3 V4 V5 V6 V8 V9 V10 V11 MOTORIZED_TRAVEL_TIME_TO_HEALTHC PRIMARY_SCHOOL_AGE_GIRL_BFA_2020 SECONDARY_SCHOOL_AGE_GIRL_BFA_20) (WALKING_ONLY_TRAVEL_TIME_min WALKING_ONLY_TRAVEL_TIME_max WALKING_ONLY_TRAVEL_TIME_mean WALKING_ONLY_TRAVEL_TIME_median WALKING_ONLY_TRAVEL_TIME_sd MOTORIZED_TRAVEL_TIME_max MOTORIZED_TRAVEL_TIME_mean MOTORIZED_TRAVEL_TIME_median MOTORIZED_TRAVEL_TIME_sd MOTORIZED_TRAVEL_TIME_min PRIMARY_SCHOOL_AGE_GIRL SECONDARY_SCHOOL_AGE_GIRL)
   
save "`dir1'/total_vardatabae_bfa2021", replace  // Sauvegarder la base mise à jour






******************************************************************
*							Cote d'ivoire
******************************************************************
clear all
local dir1 "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\01_OUTPUTS\00_EHCVM\CIV"
local dir2 "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\01_GEOSPATIAL DATA\CIV"


local files: dir "`dir2'" files "*.csv"  // Liste des fichiers Excel

use "`dir1'/communal_statpoverty_civ2021", clear
save "`dir1'/total_vardatabae_civ2021", replace
foreach file in `files' {
    import delimited "`dir2'/`file'", varnames(1) case(upper) clear  // Importer fichier Excel
  
    capture confirm variable ADM3_PCODE
if !_rc {
    // Si ADM3_PCODE existe, effectuer la fusion sur cette variable
    merge 1:1 ADM3_PCODE using "`dir1'/total_vardatabae_civ2021"
}
else {
    capture confirm variable ADM2_PCODE
    if !_rc {
        // Si ADM3_PCODE n'existe pas mais ADM2_PCODE existe, fusionner sur ADM2_PCODE
        merge 1:m ADM2_PCODE using "`dir1'/total_vardatabae_civ2021"
		}
	}
	
    drop  _merge 
    
    save "`dir1'/total_vardatabae_civ2021", replace  // Sauvegarder la base mise à jour
}

rename (WALKING_ONLY_TRAVEL_TIME_TO_HEAL V3 V4 V5 V6 V8 V9 V10 V11 MOTORIZED_TRAVEL_TIME_TO_HEALTHC PRIMARY_SCHOOL_AGE_GIRL_CIV_2020 SECONDARY_SCHOOL_AGE_GIRL_CIV_20) (WALKING_ONLY_TRAVEL_TIME_min WALKING_ONLY_TRAVEL_TIME_max WALKING_ONLY_TRAVEL_TIME_mean WALKING_ONLY_TRAVEL_TIME_median WALKING_ONLY_TRAVEL_TIME_sd MOTORIZED_TRAVEL_TIME_max MOTORIZED_TRAVEL_TIME_mean MOTORIZED_TRAVEL_TIME_median MOTORIZED_TRAVEL_TIME_sd MOTORIZED_TRAVEL_TIME_min PRIMARY_SCHOOL_AGE_GIRL SECONDARY_SCHOOL_AGE_GIRL)
   
save "`dir1'/total_vardatabae_civ2021", replace  // Sauvegarder la base mise à jour











******************************************************************
*							Niger
******************************************************************
clear all
local dir1 "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\01_OUTPUTS\00_EHCVM\NER"
local dir2 "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\01_GEOSPATIAL DATA\NER"


local files: dir "`dir2'" files "*.csv"  // Liste des fichiers Excel

use "`dir1'/communal_statpoverty_ner2021", clear
save "`dir1'/total_vardatabae_ner2021", replace
foreach file in `files' {
    import delimited "`dir2'/`file'", varnames(1) case(upper) clear  // Importer fichier Excel
  
    capture confirm variable ADM3_PCODE
if !_rc {
    // Si ADM3_PCODE existe, effectuer la fusion sur cette variable
    merge 1:1 ADM3_PCODE using "`dir1'/total_vardatabae_ner2021"
}
else {
    capture confirm variable ADM2_PCODE
    if !_rc {
        // Si ADM3_PCODE n'existe pas mais ADM2_PCODE existe, fusionner sur ADM2_PCODE
        merge 1:m ADM2_PCODE using "`dir1'/total_vardatabae_ner2021"
		}
	}
	
    drop  _merge 
    
    save "`dir1'/total_vardatabae_ner2021", replace  // Sauvegarder la base mise à jour
}

rename (WALKING_ONLY_TRAVEL_TIME_TO_HEAL V3 V4 V5 V6 V8 V9 V10 V11 MOTORIZED_TRAVEL_TIME_TO_HEALTHC PRIMARY_SCHOOL_AGE_GIRL_NER_2020 SECONDARY_SCHOOL_AGE_GIRL_NER_20) (WALKING_ONLY_TRAVEL_TIME_min WALKING_ONLY_TRAVEL_TIME_max WALKING_ONLY_TRAVEL_TIME_mean WALKING_ONLY_TRAVEL_TIME_median WALKING_ONLY_TRAVEL_TIME_sd MOTORIZED_TRAVEL_TIME_max MOTORIZED_TRAVEL_TIME_mean MOTORIZED_TRAVEL_TIME_median MOTORIZED_TRAVEL_TIME_sd MOTORIZED_TRAVEL_TIME_min PRIMARY_SCHOOL_AGE_GIRL SECONDARY_SCHOOL_AGE_GIRL)
   
save "`dir1'/total_vardatabae_ner2021", replace  // Sauvegarder la base mise à jour
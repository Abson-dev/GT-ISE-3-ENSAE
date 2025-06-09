
*................RECUPERATION DE LA TAILLE MOYENNE DES MENAGES PAR COMMUNE en 2013..........................................

/*********************/
/* 1. FICHIER 1 (NAME_2) */
/*********************/

import excel "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\01_Data_preparation\BEN\ben_gadm.xlsx", firstrow clear
clonevar commune_orig=NAME_2 

replace commune_orig="ADJA-OUERE" if NAME_2=="Adja-Ouèrè"
replace commune_orig="AKPRO-MISSERETE" if NAME_2=="Akpro-Missérété"
replace commune_orig="BEMBEREKE" if NAME_2=="Bembèrèkè"

replace commune_orig="COM: COME" if NAME_2=="Comè"

replace commune_orig="COM: KEROU" if NAME_2=="Kérou"
replace commune_orig="COM: N'DALI" if NAME_2=="N'Dali"
replace commune_orig="OUESSE" if NAME_2=="Ouèssè"
replace commune_orig="PERERE"  if NAME_2=="Pèrèrè"
replace commune_orig="SAKETE" if NAME_2=="Sakété"
replace commune_orig="COM: ZE" if NAME_2=="Zè"
replace commune_orig="COM:,AGUEGUES" if NAME_2=="Aguégués"

* Nettoyage avancé :
gen commune_clean = lower(ustrnormalize(commune_orig, "nfd")) 
replace commune_clean = regexr(commune_clean, "[^a-z]", "") // Supprime tous les caractères non alphabétiques

replace commune_clean = regexr(commune_clean, "com", "") // Enlève les "com" résiduels

* Cas spéciaux manuels :
replace commune_clean = "djakotomey" if regexm(commune_clean, "djakotome")
replace commune_clean = "klouekanme" if regexm(commune_clean, "klouekanme")

encode GID_3, generate(id1)
save data1_clean, replace

/*********************/
/* 2. FICHIER 2 (COM:...) */
/*********************/

import excel "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\ben.xlsx", firstrow clear
rename Département_Name commune_orig

* Nettoyage similaire :
gen commune_clean = lower(ustrnormalize(commune_orig, "nfd"))
replace commune_clean = regexr(commune_clean, "[^a-z]", "")
replace commune_clean = regexr(commune_clean, "com", "") 

* Corrections spécifiques :
replace commune_clean = "djougou" if inlist(commune_clean, "djougourural", "djougouurbain")
replace commune_clean = "semekpodji" if commune_clean == "seme-kpodji"
encode commune_clean, generate(id2)
save data2_clean, replace

/*********************/
/* 3. MERGE FLou + VÉRIF */
/*********************/


use data1_clean, clear
reclink commune_clean using data2_clean, ///
    idmaster(id1) idusing(id2) ///
    gen(matchscore) ///
    minscore(0.70) 

drop  id2 matchscore Ucommune_clean  commune_orig _merge
save "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\03_SHAPEFILES\BEN\ben_gadm", replace

use"C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\03_SHAPEFILES\BEN\ben_gadm", clear

save data1_clean, replace




*....................RECUPERATION DU POURCENTAGE DE CHEF DE MENAGE FEMME.................



/*********************/
/* 2. FICHIER 2 (COM:...) */
/*********************/

import excel "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\benfemmeCM2013.xlsx", firstrow clear

rename Departement_Name commune_orig

* Nettoyage similaire :
gen commune_clean = lower(ustrnormalize(commune_orig, "nfd"))
replace commune_clean = regexr(commune_clean, "[^a-z]", "")
replace commune_clean = regexr(commune_clean, "com", "") 

* Corrections spécifiques :
replace commune_clean = "djougou" if inlist(commune_clean, "djougourural", "djougouurbain")
replace commune_clean = "semekpodji" if commune_clean == "seme-kpodji"
encode commune_clean, generate(id2)
save data2_clean, replace

/*********************/
/* 3. MERGE FLou + VÉRIF */
/*********************/

use data1_clean, clear
reclink commune_clean using data2_clean, ///
    idmaster(id1) idusing(id2) ///
    gen(matchscore) ///
    minscore(0.70) 

drop id1 id2 matchscore Ucommune_clean commune_clean commune_orig _merge
save "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\03_SHAPEFILES\BEN\ben_gadm", replace

use"C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\03_SHAPEFILES\BEN\ben_gadm", clear

clear all
global  chemin  "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\00_EHCVM\BFA\BFA_2021_EHCVM-2_v01_M_Stata"

*...............................................................................
*..................              BURKINA FASO            .......................
*...............................................................................
*(DEBUT)
use "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\00_EHCVM\BFA\BFA_2021_EHCVM-2_v01_M_Stata\ehcvm_welfare_2b_bfa2021", clear

capture drop hhsize_weighted  
capture drop weight_squared
capture drop region_hhsize

*.........................................
gen hhsize_weighted = hhsize * hhweight
gen weight_squared = hhweight
*.........................................

collapse  (sum)  hhsize_weighted weight_squared, by(region)

gen region_hhsize = hhsize_weighted / weight_squared
* Save the summary dataset
tempfile region_means
save `region_means'

* Restore original data
use "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\00_EHCVM\BFA\BFA_2021_EHCVM-2_v01_M_Stata\ehcvm_welfare_2b_bfa2021", clear

* Merge back the group-level weighted means
merge m:1  region using `region_means'
drop _merge

save "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\00_EHCVM\BFA\BFA_2021_EHCVM-2_v01_M_Stata\ehcvm_welfare_2b_bfa2021", replace
*(FIN)

*................Proportion de chef de menage travaillant pour compte pre....................
*(DEBUT)
// ici, nous creons la variable binaire csp_cm qui nous permet de capter les chef de menage travaillant pour compte propre car nous estimons que cette variable sera pertinente dans le cadre des PED pour expliquer la pauvreté monetaire

capture drop csp_cm 

gen csp_cm=(hcsp==9)

*..................Propotion de Chef de Menage agriculteur...................

//ici, nous creons la variable binaire agriculture qui nous permet de capter les chef de menage travaillantdans le secteur agricole car nous estimons que cette variable caracteriste de facon pertinente les economies des PED pour expliquer la pauvreté monetaire
capture drop agriculture 

gen agriculture=(hbranch==1)

*........................................




collapse (mean) csp_cm agriculture [pw=hhweight], by(region)


* Save the summary dataset
tempfile region_means
save `region_means'

* Restore original data
use "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\00_EHCVM\BFA\BFA_2021_EHCVM-2_v01_M_Stata\ehcvm_welfare_2b_bfa2021", clear

* Merge back the group-level weighted means
merge m:1 region using `region_means'
drop _merge



save "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\00_EHCVM\BFA\BFA_2021_EHCVM-2_v01_M_Stata\ehcvm_welfare_2b_bfa2021", replace

*(FIN)


//NOTE: Ce dofile dans etre compilé en 2eme dans l'analyse sur le benin

*(DEBUT)
*...............................................................................
use "$chemin\ehcvm_menage_bfa2021", clear
merge 1:1 hhid grappe menage using "$chemin\ehcvm_welfare_2b_bfa2021"

capture drop prop_mur_provisoire

collapse (mean) prop_mur_provisoire=mur [pw=hhweight], by(region)

* Save the summary dataset
tempfile region_means
save `region_means'

* Restore original data
use "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\00_EHCVM\BFA\BFA_2021_EHCVM-2_v01_M_Stata\ehcvm_welfare_2b_bfa2021", clear

* Merge back the group-level weighted means
merge m:1 region using `region_means'
drop _merge


save "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\00_EHCVM\BFA\BFA_2021_EHCVM-2_v01_M_Stata\ehcvm_welfare_2b_bfa2021", replace

*(FIN)
*...............................................................................

*(DEBUT)










///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
*(DEBUT)
//construction de la base excel de conflit

import excel "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\01_Data_preparation\BFA\donnees conflits\burkina-faso_hrp_political_violence_events_and_fatalities_by_month-year_as-of-03apr2025.xlsx", sheet("Data") firstrow clear


destring Year, replace


keep if Year>=2014 & Year<=2021
 
collapse (sum) political_fatalities=Fatalities, by( Admin1Pcode Admin2Pcode)


rename  Admin1Pcode ADM1_PCODE
rename Admin2Pcode ADM2_PCODE

tempfile political_fatality
save `political_fatality'

//2eme fichier: conflits civils

import excel "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\01_Data_preparation\BFA\donnees conflits\burkina-faso_hrp_civilian_targeting_events_and_fatalities_by_month-year_as-of-03apr2025.xlsx", sheet("Data") firstrow clear


destring Year, replace


keep if Year>=2014 & Year<=2021
 
collapse (sum) civilian_fatalities=Fatalities, by( Admin1Pcode Admin2Pcode)


rename  Admin1Pcode ADM1_PCODE
rename Admin2Pcode ADM2_PCODE

//maintenant merger les 02 fichiers
merge 1:1 ADM1_PCODE ADM2_PCODE using `political_fatality'
drop _merge

export delimited using "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\01_GEOSPATIAL DATA\BFA\bfa_conflicts.csv", replace


*(FIN)
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////


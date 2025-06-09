clear all

***********************BENIN********************


use "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\00_EHCVM\BEN\BEN_2021_EHCVM-2_v01_M_STATA14\ehcvm_welfare_ben2021", clear

capture drop hhsize_weighted  
capture drop weight_squared
capture drop region_hhsize

*.........................................
gen hhsize_weighted = hhsize * hhweight
gen weight_squared = hhweight
*.........................................

collapse  (sum)  hhsize_weighted weight_squared, by(departement)

gen region_hhsize = hhsize_weighted / weight_squared
* Save the summary dataset
tempfile region_means
save `region_means'

* Restore original data
use "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\00_EHCVM\BEN\BEN_2021_EHCVM-2_v01_M_STATA14\ehcvm_welfare_ben2021", clear

* Merge back the group-level weighted means
merge m:1  departement using `region_means'
drop _merge

*................Proportion de chef de menage travaillant pour compte pre....................
// ici, nous creons la variable binaire csp_cm qui nous permet de capter les chef de menage travaillant pour compte propre car nous estimons que cette variable sera pertinente dans le cadre des PED pour expliquer la pauvreté monetaire

capture drop csp_cm 

gen csp_cm=(hcsp==9)

*..................Propotion de Chef de Menage agriculteur...................

//ici, nous creons la variable binaire agriculture qui nous permet de capter les chef de menage travaillantdans le secteur agricole car nous estimons que cette variable caracteriste de facon pertinente les economies des PED pour expliquer la pauvreté monetaire
capture drop agriculture 

gen agriculture=(hbranch==1)

*........................................




collapse (mean) csp_cm agriculture [pw=hhweight], by(departement)


* Save the summary dataset
tempfile region_means
save `region_means'

* Restore original data
use "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\00_EHCVM\BEN\BEN_2021_EHCVM-2_v01_M_STATA14\ehcvm_welfare_ben2021", clear

* Merge back the group-level weighted means
merge m:1 departement using `region_means'
drop _merge



save "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\00_INPUTS\00_EHCVM\BEN\BEN_2021_EHCVM-2_v01_M_STATA14\ehcvm_welfare_ben2021", replace


/*

replace proportion_csp_cm=proportion_csp_cm/weight_squared
replace proportion_agri=proportion_agri/weight_squared

NOTE: Ce dofile dans etre compilé en 2eme dans l'analyse sur le benin

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso\00.Data"
global data_input       	"$main\00_Inputs\EHCVM data\BFA_2021_EHCVM-P_v02_M_Stata"
global data_output       	"$main\01_Outputs"


*===============================================================================
//level 3 
*===============================================================================

use "$data_output\survey_ehcvm_bfa_2021.dta",clear
rename ADM3_CODE adm3_pcode
rename ADM2_CODE adm2_pcode
rename ADM1_CODE adm1_pcode
rename milieu urban
rename pcexp welfare
rename zref pl_abs
rename hhweight WTA_S_HHSIZE
//rename province province
rename grappe clust //to check


egen strata = group(region urban)
svyset clust [pw=WTA_S_HHSIZE], strata(strata)

//gen pl_abs2 = pl_abs
//*def_temp*def_spa
gen fgt0 = (welfare < pl_abs) if !missing(welfare)

//tab fgt0 [aw = WTA_S_HHSIZE*hhsize]

/*
//FGT :  indices de Foster-Greer-Thorbecke (FGT) 
définis en 1984
L'incidence de la pauvreté (fgt0) mesure la proportion de la population qui vit en état de 
pauvreté, celle pour laquelle la consommation est inférieure à la ligne (seuil) de 
pauvreté par personne par an.  

La profondeur de la pauvreté (écart de pauvreté)  (fgt1) mesure la distance moyenne entre 
le revenu des ménages et la ligne de pauvreté, en donnant une distance zéro aux 
ménages qui sont au-dessus de la ligne de pauvreté.  

La sévérité de pauvreté (fgt2)


	forval a=0/2{
	    gen fgt`a' = (welfare<pl_abs)*(1-welfare/(pl_abs))^`a'
	}
*/


gen popw = WTA_S_HHSIZE*hhsize

gen fgt0se = fgt0

//gen Sample_size = 1
gen N=1 //Need the number of observation by district...for smoother variance function
gen N_hhsize = hhsize
//Number of EA by admin3
bysort adm3_pcode clust: gen num_ea = 1 if _n==1

collapse  (sum)  N popw WTA_S_HHSIZE num_ea N_hhsize (mean) fgt0 (semean) fgt0se [aw = popw], by(adm3_pcode)  
gen dir_fgt0 = fgt0
gen dir_fgt0_var = fgt0se ^2
gen dir_fgt0_cv = fgt0se/fgt0
gen zero = dir_fgt0 //original variable with direct estimates

replace dir_fgt0_var = . if dir_fgt0_var==0
replace dir_fgt0 = . if missing(dir_fgt0_var)

gen adm0_pcode = substr(adm3_pcode, 1, 2)
gen adm1_pcode = substr(adm3_pcode, 1, 4) 
gen adm2_pcode = substr(adm3_pcode, 1, 6) 

order adm1_pcode  adm2_pcode adm3_pcode

save "$data_output\direct_survey_ehcvm_bfa_2021_admin3.dta", replace
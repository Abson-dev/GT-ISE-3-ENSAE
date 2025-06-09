clear all
set matsize 8000
set seed 648743
//clear all
*===============================================================================
//Specify team paths 
*===============================================================================
* Configuration initiale
//"C:\Users\AHema\Downloads\version du 26-04_Hema\version du 26-04_Hema\total_vardatabae_bfa2021.dta"
global dir1 "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\05_Reports\BFA"
global data_output_fig "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\05_Reports\BFA"
global data_out_table "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\05_Reports\BFA"

* Chargement des données
use "C:\Users\Administrator\Desktop\GT2025\GT-ISE-3-ENSAE\00_Data\01_OUTPUTS\00_EHCVM\BFA\total_vardatabae_bfa2021.dta", clear
tabulate ADM1_PCODE,generate(Region_)

/*
la bonne compilation de ce dofile necessite des fonction externe construites sous mata et appelé a l'aide de la ligne de commande ci-dessous qui dois etre adapté pour mener vers le fichier lsae_povmap.mata , ou en utilisant la commande  <<mata: mata mlib index>> apres avoir deja compilé au moins 1 fois lsae_povmap.mata 
//include "C:\Users\Administrator\Desktop\GT2025\amelioration dofile GT\version du 26-04_Hema\version du 26-04_Hema2\version du 26-04_Hema_BFA_final\lsae_povmap.mata"
*/

// Charge la librairie (chemin absolu ou dans adopath)
mata: mata mlib index


gen dir_fgt0_var=fgt0_var
gen dir_fgt0=mean_p0

drop DEGRURAL_MEDIAN

*===============================================================================
//FH Estimation
*===============================================================================
/*
foreach x of varlist *_min* *_MIN* *_max* *_MAX*  POPULATION_BFA_2020  POPULATION_DENSITY_BFA_2020  *_median* *_MEDIAN*   INHABITANTS_* CDI_*  *_sd *_STDDEV   VOLUME_BATIS_M3 ROAD_KM SECONDARY_SCHOOL_AGE_GIRL PRIMARY_SCHOOL_AGE_GIRL DEPENDENCY_RATIO YOUNG ELDERLY WORKING POLITICAL_FATALITIES CIVILIAN_FATALITIES{
	gen `x'2 = `x' * `x'
	}
*/

/*
foreach x of varlist *_TRAVEL_TIME_* PF_PARASITE_RATE_* PF_MORTALITY_RATE_* SCALE_* OFFSET_*  POPULATION_BFA_2020  POPULATION_DENSITY_BFA_2020   *_SCHOOL_AGE_GIRL* UI_* NDVI_* SAVI_* OSAVI_* NDSI_* SR_* NBAI_* NDMI_* VARI_* BRBA_* MNDWI_* EVI_* ARVI_* CDI_*  {
	gen `x'2 = `x' * `x'
}


valeurs sure local vars *_min* *_MIN* *_max* *_MAX*  POPULATION_BFA_2020  POPULATION_DENSITY_BFA_2020  *_median* *_MEDIAN*   INHABITANTS_* CDI_*  *_sd *_STDDEV   VOLUME_BATIS_M3 ROAD_KM SECONDARY_SCHOOL_AGE_GIRL PRIMARY_SCHOOL_AGE_GIRL DEPENDENCY_RATIO YOUNG ELDERLY WORKING POLITICAL_FATALITIES CIVILIAN_FATALITIES Region_1-Region_12 //  *MEAN* *_mean*
------------->>local vars *_min* *_MIN* *_max* *_MAX*  POPULATION_BFA_2020  POPULATION_DENSITY_BFA_2020  *_median* *_MEDIAN*   INHABITANTS_* CDI_*  *_sd *_STDDEV   VOLUME_BATIS_M3 ROAD_KM  PRIMARY_SCHOOL_AGE_GIRL DEPENDENCY_RATIO Region_2-Region_13 

local vars *_TRAVEL_TIME_* PF_PARASITE_RATE_* PF_MORTALITY_RATE_* SCALE_* OFFSET_*  POPULATION_BFA_2020  POPULATION_DENSITY_BFA_2020   *_SCHOOL_AGE_GIRL* UI_* NDVI_* SAVI_* OSAVI_* NDSI_* SR_* NBAI_* NDMI_* VARI_* BRBA_* MNDWI_* EVI_* ARVI_* CDI_* //region*
*/

local vars *_min* *_MIN* *_max* *_MAX*  POPULATION_BFA_2020  POPULATION_DENSITY_BFA_2020  *_median* *_MEDIAN*   INHABITANTS_* CDI_*  *_sd *_STDDEV   VOLUME_BATIS_M3 ROAD_KM  DEPENDENCY_RATIO   SECONDARY_SCHOOL_AGE_GIRL PRIMARY_SCHOOL_AGE_GIRL YOUNG ELDERLY WORKING POLITICAL_FATALITIES  Region_1-Region_13 

//Region_2-Region_13

unab hhvars: `vars'


*===============================================================================
//Create smoothed variance function
*===============================================================================
//replace dir_fgt0_var = 0.0001 if dir_fgt0_var ==. & (fgt0 == 0 | fgt0 == 1)
gen log_s2 = log(dir_fgt0_var)
//gen logN = log(N)
//gen logN2 = logN^2
gen logpop  = log(totpoids_commune/POPULATION_BFA_2020)
//pop
cap drop logpop2
gen logpop2 = logpop^2

cap drop share
gen share = log(1/totpoids_commune)

reg log_s2  share  csp_cm  echant_menages_commune
local phi2 = e(rmse)^2
cap drop xb_fh
predict xb_fh, xb

cap drop residual
predict residual,res

sum xb_fh if residual!=.,d

cap drop exp_xb_fh
gen exp_xb_fh = exp(xb_fh)
sum dir_fgt0_var
local sumvar = r(sum)
sum exp_xb_fh
local sump = r(sum)

//Below comes from: https://presidencia.gva.es/documents/166658342/168130165/Ejemplar+45-01.pdf/fb04aeb3-9ea6-441f-a15c-bc65e857d689?t=1557824876209#page=107
gen smoothed_var = exp_xb_fh*(`sumvar'/`sump')
//replace dir_fgt0=ln(dir_fgt0) 
//replace dir_fgt0_var=smoothed_var/(dir_fgt0^2)
//Modified to only replace for the locations with 0 variance
replace dir_fgt0_var = smoothed_var if (!missing(dir_fgt0_var)) 
 
replace dir_fgt0 =. if missing(dir_fgt0_var)

fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(fh)

 
//Removal of non-significant variables
	//Removal of non-significant variables
	local hhvars : list clean hhvars
	dis as error "Sim : `sim' first removal"
	//Removal of non-significant variables
	forval z= 0.2(-0.05)1e-5{
		local regreso 
		while ("`regreso'"!="it's done"){
			quietly:fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(fh)
			mata: bb=st_matrix("e(b)")
			mata: se=sqrt(diagonal(st_matrix("e(V)")))
			local _myhhvars : colnames(e(b))
			
			mata: st_local("regreso", invtokens(mysel2(bb, se, `z')))
	
			if ("`regreso'"!="it's done") local hhvars `regreso'
		}		
	}

	
	
	
	//Global with non-significant variables removed
	global postsign `hhvars'
	
	//Final model without non-significant variables 
	quietly:fhsae dir_fgt0 ${postsign}, revar(dir_fgt0_var) method(fh)
	
	//Check VIF
	reg dir_fgt0 $postsign, r
	
	estat vif
	
	gen touse = e(sample)
	gen weight = 1
	mata: ds = _f_stepvif("$postsign","weight",40,"touse") 
	
	global postvif `vifvar'	
	
		//Check VIF
	reg dir_fgt0 $postvif, r
	
	estat vif
	
	
	
	
	
	local hhvars $postvif
	
	//One final removal of non-significant covariates

	forval z= 0.2(-0.05)1e-3{
		local regreso 
		while ("`regreso'"!="it's done"){
			quietly:fhsae dir_fgt0 `hhvars', revar(dir_fgt0_var) method(fh) precision(1e-10)
			mata: bb=st_matrix("e(b)")
			mata: se=sqrt(diagonal(st_matrix("e(V)")))
			local _myhhvars : colnames(e(b))
			mata: st_local("regreso", invtokens(mysel2(bb, se, `z')))	
			if ("`regreso'"!="it's done") local hhvars `regreso'
		}	
	}	
	
	
	global last `hhvars'
	
//*********************************************************************************************//

cap drop fh_fgt0
cap drop fh_fgt0_cv
cap drop fh_fgt0_se
cap drop direct_cv
cap drop fh_fgt0_gamma
cap drop se
cap drop fh_fgt0 fh_fgt0_se fh_fgt0_cv direct_cv  fh_fgt0_gamma
	//Obtain SAE-FH-estimates	
	fhsae dir_fgt0 $last, revar(dir_fgt0_var) method(reml) fh(fh_fgt0) ///
	fhse(fh_fgt0_se) fhcv(fh_fgt0_cv)  dse(se) dcv(direct_cv)  gamma(fh_fgt0_gamma) out noneg precision(1e-13)
	outreg2 using "$data_out_table/Resultats.xls", replace ctitle(coeff)

********************************************************************************
*						test de validation
********************************************************************************
// normaliity of FH aera effect and designed based error

sum fh_fgt0_cv
sum direct_cv
br if fh_fgt0_cv>direct_cv

		
	/*
	gen fh_fgt0_real = 1*(fh_fgt0>1) + fh_fgt0*(fh_fgt0<=1)
	
	gen fh_fgt0_se_real = 0*(fh_fgt0>=1 | fh_fgt0 == 0) + fh_fgt0_se*(fh_fgt0<1 & fh_fgt0 > 0)
	
	replace fh_fgt0_se = fh_fgt0_se_real
	replace fh_fgt0 = fh_fgt0_real
	drop fh_fgt0_real
	drop fh_fgt0_se_real
	*/

//Check normal errors
cap drop lin_fgt0
predict lin_fgt0, xb

cap drop u_d
gen u_d = dir_fgt0 - lin_fgt0
lab var u_d "FH area effects"

* Tester la normalité
swilk u_d
histogram u_d, normal graphregion(color(white)) title("BURKINA FASO")
graph export "$data_output_fig\Fig1_ud_left_ML.png", as(png) replace
qnorm u_d, graphregion(color(white)) title("BURKINA FASO")
graph export "$data_output_fig\Fig1_ud_right_ML.png", as(png) replace
	
gen e_d = dir_fgt0 - fh_fgt0
lab var e_d "FH errors"
	
histogram e_d, normal graphregion(color(white)) title("BURKINA FASO")
graph export "$data_output_fig\Fig1_ed_left_ML.png", as(png) replace
qnorm e_d, graphregion(color(white)) title("BURKINA FASO")
graph export "$data_output_fig\Fig1_ed_right_ML.png", as(png) replace

********************************************************************************
*								(HOMOSCEDASTICITE)
* Après régression OLS (approximation)
regress dir_fgt0 $last
estat hettest 
********************************************************************************	
*						Estimatation des taux de pauvretés
********************************************************************************
// Direct_estimate et FH_estimate  de la pauvreté au niveau national ( sans redressement).

mean fh_fgt0 dir_fgt0 [pw=totpoids_commune]
* Créer un nouveau fichier Excel
putexcel set "$data_out_table/bfa_incidence_pauvrete_national.xlsx", replace

* Écrire les en-têtes
putexcel C1:D1="[95% conf. interval]", merge
putexcel A2 = "Variable" B2 = "Moyenne" C2 = "born. Sup" D2 = "born. Sup"

* Extraire la matrice résultat
matrix r = r(table)

* Écrire les résultats pour fh_fgt0 (colonne 1)
putexcel A3 = "FH_FGT0" ///
         B3 = r[1,1] ///
         C3 = r[5,1] ///
         D3 = r[6,1]

* Écrire les résultats pour dir_fgt0 (colonne 2)
putexcel A4 = "DIR_FGT0" ///
         B4 = r[1,2] ///
         C4 = r[5,2] ///
         D4 = r[6,2]

		 
// Direct_estimate et FH_estimate  de la pauvreté au niveau region.
preserve
collapse (mean) dir_fgt0 fh_fgt0 (semean) se=dir_fgt0 fh_fgt0_se=fh_fgt0 [aw=totpoids_commune], by(ADM1_FR)
rename ADM1_FR Region
gen dir_sup_ic = dir_fgt0+invnormal(0.975)*se
gen dir_inf_ic = dir_fgt0+invnormal(0.025)*se
gen fh_sup_ic = fh_fgt0+invnormal(0.975)*fh_fgt0_se
gen fh_inf_ic = fh_fgt0+invnormal(0.025)*fh_fgt0_se
gen dir_cv=se/dir_fgt0
gen fh_cv=fh_fgt0_se/fh_fgt0

keep Region dir_fgt0 fh_fgt0 dir_cv fh_cv dir_inf_ic dir_sup_ic fh_inf_ic fh_sup_ic
order Region dir_fgt0 fh_fgt0 dir_cv fh_cv dir_inf_ic dir_sup_ic fh_inf_ic fh_sup_ic
test fh_fgt0 = dir_fgt0
export excel using "$data_out_table/bfa_incidence_pauvrete_region", firstrow(variables) replace
restore


// Direct_estimate et FH_estimate  de la pauvreté au niveau commune.
rename ADM3_FR Commune
gen dir_sup_ic = dir_fgt0+invnormal(0.975)*se
gen dir_inf_ic = dir_fgt0+invnormal(0.025)*se

gen fh_sup_ic = fh_fgt0+invnormal(0.975)*fh_fgt0_se
gen fh_inf_ic = fh_fgt0+invnormal(0.025)*fh_fgt0_se

gen dir_cv=se/dir_fgt0
gen fh_cv=fh_fgt0_se/fh_fgt0

preserve
keep ADM3_PCODE Commune dir_fgt0 fh_fgt0 dir_cv fh_cv dir_inf_ic dir_sup_ic fh_inf_ic fh_sup_ic 
order ADM3_PCODE Commune dir_fgt0 fh_fgt0 dir_cv fh_cv dir_inf_ic dir_sup_ic fh_inf_ic fh_sup_ic
export excel using "$data_out_table/bfa_incidence_pauvrete_commune", firstrow(variables) replace
restore



***********************************************************************************************
// Evolution de l'erreur de prediction de fay-herriot  par rapport a celles de l'estimation directe

twoway (scatter fh_fgt0_se se) (line se se), `graphs' xlab(0(.05).2) ylab(0(.05).2) ytitle(Fay Herriot (rmse)) xtitle(Direct estimate (SE)) title("BURKINA FASO") legend(off)

graph export "$data_output_fig\Fig2_left_admin3_ML.png", as(png) replace  //_FH, _REML, _ML,_CHANDRA


// Alignement des predictions de fay-herriot avec celles du estimation directe
twoway (scatter fh_fgt0 dir_fgt0 ) (line fh_fgt0 fh_fgt0), `graphs' ytitle(Fay Herriot) xtitle(Direct estimate) title("BURKINA FASO") legend(off)

graph export "$data_output_fig\Fig2_right_admin3_ML.png", as(png) replace  //_FH, _REML, _ML,_CHANDRA


// Interval de confiance 
graph dot (asis) fh_fgt0 dir_sup_ic dir_inf_ic in 1/20, over(ADM3_PCODE) marker(2, mcolor(red) msymbol(diamond)) marker(3, mcolor(red) msymbol(diamond)) graphregion(color(white)) legend(order(1 "Poverty headcount from Fay Herriot" 2 "Direct estimate CI (95%)") cols(1))  ///
        title("BURKINA FASO Estimated poverty rate in communes") ///
        subtitle("(Direct vs Fay Herriot estimates)") ///
        note("Source: EHCVM 2021 Survey")
	
graph export "$data_output_fig\SAE_CI_communes_ML.png", as(png) replace //_FH, _REML, _ML,_CHANDRA

****************************************************************************************************************
test fh_fgt0 = dir_fgt0

/*




*******************************************************************************************************************************************************
//NOTE: ce dofile est un peu compliqué. deja ne pas ajouter de "clear all" dans le dofile car il supprimera tout ce qui est en memoire y compris la	  * fonction mata enregistrer et ceci a chaque nouveau lancement. Ensuite , il faudra compiler le dofile 2 fois: la premiere fois, s'affichera un message * d'erreur qui indique que la fonctuon myselect2() est introuvable. relancer une nouvelle fois et ca marchera.										  *
*******************************************************************************************************************************************************

//Peux t-on faire une analyse factorielle sur stata


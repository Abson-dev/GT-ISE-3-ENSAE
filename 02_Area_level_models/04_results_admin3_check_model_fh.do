set more off
clear all



global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso\00.Data"
global data_input       	"$main\00_Inputs\EHCVM data\BFA_2021_EHCVM-P_v02_M_Stata"
global data_output       	"$main\01_Outputs"
global figs        "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso\02.Area_level_models\04.graphics"

graph set window fontface "Arial Narrow"
local graphs graphregion(color(white)) xsize(9) ysize(9)

*===============================================================================
// Direct estimates at admin level 3
*===============================================================================
use "$data_output\direct_survey_ehcvm_bfa_2021_admin3.dta", clear 
gen u_ci = fgt0+invnormal(0.975)*sqrt(dir_fgt0_var)
gen l_ci = fgt0+invnormal(0.025)*sqrt(dir_fgt0_var)

gen u_ci90 = fgt0+invnormal(0.95)*sqrt(dir_fgt0_var)
gen l_ci90 = fgt0+invnormal(0.05)*sqrt(dir_fgt0_var)

keep adm3_pcode fgt0 l_ci* u_ci* //adm2_pcode
list
rename fgt0 direct_fgt0

tempfile direct
save direct,replace

*===============================================================================
//Fay Herriot Estimates  at admin level 3
*===============================================================================
use "$data_output\FH_sae_poverty_ML.dta", clear //_FH, _REML, _ML,_CHANDRA

keep if (fgt0 !=. & fgt0 != 0 & fgt0 != 1)
merge m:1 adm3_pcode using direct
	drop if _m==2
	drop _m

//See the improvement in precision
gen se=sqrt( dir_fgt0_var)
twoway (scatter fh_fgt0_se se ) (line se se), `graphs' xlab(0(.05).2) ylab(0(.05).2) ytitle(Fay Herriot (rmse)) xtitle(Direct estimate (SE)) legend(off)

graph export "$figs\Fig2_right_admin3_ML.png", as(png) replace //_FH, _REML, _ML,_CHANDRA

twoway (scatter fh_fgt0 dir_fgt0 ) (line fh_fgt0 fh_fgt0), `graphs' ytitle(Fay Herriot) xtitle(Direct estimate) legend(off)

graph export "$figs\Fig2_left_admin3_ML.png", as(png) replace  //_FH, _REML, _ML,_CHANDRA
	


//
graph dot (asis) fh_fgt0 u_ci l_ci in 1/20, over(adm3_pcode) marker(2, mcolor(red) msymbol(diamond)) marker(3, mcolor(red) msymbol(diamond)) graphregion(color(white)) legend(order(1 "Poverty headcount from Fay Herriot" 2 "Direct estimate CI (95%)") cols(1))  ///
        title("Estimated poverty rate in BFA communes") ///
        subtitle("(Direct vs Fay Herriot estimates)") ///
        note("Source: EHCVM 2021 Survey")
	
graph export "$figs\SAE_CI_communes_ML.png", as(png) replace //_FH, _REML, _ML,_CHANDRA

*===============================================================================
// Prep data for Tableau
*===============================================================================
xtile q10 = fh_fgt0, nq(10)
gen range_Q10 = ""
local last = 0
	forval q=1/10{
		sum fh_fgt0 if q10==`q'
		local min = round(`=100*`r(min)'',0.1)
		local min = trim("`: dis %10.1f `min''")
		local max = round(`=100*`r(max)'',0.1)
		local max = trim("`: dis %10.1f `max''")

		replace range_Q10 = "`min' - `max'" if  q10==`q'
	}	



replace range_Q10 = "NULL" if range_Q10 ==""

*===============================================================================
// Indicate significantly more or less poor than admin 3
*===============================================================================
gen u_ci_fh = min(1,fh_fgt0+invnormal(0.975)*fh_fgt0_se)
gen l_ci_fh = max(0,fh_fgt0+invnormal(0.025)*fh_fgt0_se)

gen sig_diff = "Significantly more poor than the region average" if l_ci_fh>u_ci
replace sig_diff = "Significantly less poor than the region average" if u_ci_fh<l_ci


export delimited using "$data_output\fh_sae_bfa_commune.csv", replace


*===============================================================================
// Table for document with poverty for all  locations
*===============================================================================

sort adm3_pcode
keep adm3_pcode Worlpop_population fh_fgt0  fgt0 fh_fgt0_se dir_fgt0_var
gen numpoor = Worlpop_population*fh_fgt0
gen u_ci = min(1,fh_fgt0+invnormal(0.975)*fh_fgt0_se)
gen l_ci = max(0,fh_fgt0+invnormal(0.025)*fh_fgt0_se)


order adm3_pcode Worlpop_population fh_fgt0 fh_fgt0_se numpoor l_ci u_ci 

export excel using "$data_output\povertyTable.xlsx", sheet(tab_stata) first(variable) sheetreplace

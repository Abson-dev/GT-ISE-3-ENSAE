

*===============================================================================
//Specify team paths 
*===============================================================================

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso\00.Data"
global data_input       	"$main\00_Inputs\Geospatial Data"
global data_output       	"$main\01_Outputs"


*===============================================================================
//Geo data admin level 3
*===============================================================================


import delimited "$data_input\geo_indices_Stats_admin_3.csv",clear //geo_indices_Stats_admin_3
unab variable : ui_max - vari_max
 	foreach x in `variable' {
 		rename `x' geo_`x'
 	}
 

save "$data_output\spatial_data_admin3.dta", replace


*===============================================================================
//ACLED data admin level 3
*===============================================================================


//ACLED data
import delimited "$data_input\ACLED_Conflict_diffusion_Indicator_admin_3.csv",clear

rename conflict_diffusion_indicator acled_cdi
save "$data_output\cdi.dta", replace 
import delimited "$data_input\ACLED_Exposed_Indicator_admin_3.csv",clear

rename inhabitants_100m Worlpop_population
rename inhabitants_inside5km_events Worlpop_exposed
rename inhabitants_inside5km_vac vac
rename inhabitants_inside5km_battles battles
rename  inhabitants_inside5km_riots riots
rename  inhabitants_inside5km_protests protests
rename  inhabitants_inside5km_erv erv
rename  inhabitants_inside5km_sd sd
rename exposed_to_conflict_indicator acled_ei
merge 1:1 adm3_pcode using "$data_output\cdi.dta"
drop _merge
unab variable : vac battles riots protests erv sd 
 	foreach x in `variable' {
 		rename `x' acled_ei_`x'
 	}
unab variable : events* cdi_vac cdi_battles cdi_riots cdi_protests cdi_erv cdi_sd
 	foreach x in `variable' {
 		rename `x' acled_`x'
 	}


merge 1:1 adm3_pcode using "$data_output\spatial_data_admin3.dta" 
drop _merge
order adm3_pcode
save "$data_output\spatial_data_admin3.dta", replace 

*===============================================================================
//Healthcare data admin level 3
*===============================================================================
import delimited "$data_input\Healthcare_Stats_admin_3.csv",clear
merge 1:1 adm3_pcode using "$data_output\spatial_data_admin3.dta" 
drop _merge
order adm3_pcode
save "$data_output\spatial_data_admin3.dta", replace 


*===============================================================================
//Nighttime data admin level 3
*===============================================================================
import delimited "$data_input\Nighttime_Stats_admin_3.csv",clear
unab variable : scale_min - offset_stddev 
 	foreach x in `variable' {
 		rename `x' night_`x'
 	}
merge 1:1 adm3_pcode using "$data_output\spatial_data_admin3.dta" 
drop _merge
order adm3_pcode
save "$data_output\spatial_data_admin3.dta", replace 


*===============================================================================
//Malaria data admin level 3
*===============================================================================

import delimited "$data_input\Malaria_Stats_admin_3.csv",clear
merge 1:1 adm3_pcode using "$data_output\spatial_data_admin3.dta" 
drop _merge
order adm3_pcode
save "$data_output\spatial_data_admin3.dta", replace 




*===============================================================================
//Buildings data admin level 3
*===============================================================================
import delimited "$data_input\Buildings_Stats_admin_3.csv",clear
unab variable : count_min - urban_stddev
 	foreach x in `variable' {
 		rename `x' buildings_`x'
 	}

merge 1:1 adm3_pcode using "$data_output\spatial_data_admin3.dta" 
drop _merge
order adm3_pcode
save "$data_output\spatial_data_admin3.dta", replace 
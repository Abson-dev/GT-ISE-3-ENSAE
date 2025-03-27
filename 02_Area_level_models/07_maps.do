/*
this dofile creates maps at the admin level 1, admin level 2, and admin level 3 for the direct, FH and XGBoost estimates. 
*/

* ------------------------------------------------------------------------------
*    Packages
* ------------------------------------------------------------------------------
 /*
ssc install spmap
ssc install shp2dta
   
   
 
ssc install geoplot, replace
ssc install moremata, replace

ssc install palettes, replace
ssc install colrspace, replace
*/  

clear all

set more off

version 14


graph set window fontface "Arial Narrow"


*===============================================================================
//Specify team paths 
*===============================================================================

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso\00.Data"
global data_input       	"$main\00_Inputs\00_Country Shapefiles"
global data_output       	"$main\01_Outputs"
global figs        "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso\02.Area_level_models\04.graphics"

		
*===============================================================================
//Direct and XGBoost estimates  at the administrative level 3
*===============================================================================




 
 /*
  //compass(pos(2)) sbar(length(.002) units(km)) ///
 geoplot ///
 (area admin2 fgt0, levels(10) color(viridis, reverse) label("@lb - @ub (N=@n)")) ///
 , legend(pos(2) outside) 
 
*/


/*
    *Shapefiles 
	 shp2dta using "$main\00_Inputs\00_Country Shapefiles\bfa_admbnda_adm3_igb_20200323_em.shp", ///
	 database("$data_output\bfa_adm3") ///
	 coord("$data_output\bfa_adm3_coord")
*/

	 use  "$data_output\bfa_adm3.dta", clear
	 rename ADM3_PCODE adm3_pcode
	 

	 
	 merge 1:1 adm3_pcode using "$data_output\FH_sae_poverty.dta" 

	 save "$data_output\bfa_shp3.dta", replace


* ------------------------------------------------------------------------------
*     Map 1
* ------------------------------------------------------------------------------
use "$data_output\bfa_shp3.dta",replace
    spmap fgt0 using "$data_output\bfa_adm3_coord.dta" ///
        , ///
        id(_ID) ///
        fcolor(Reds) osize(.1) ocolor(black) ///
        clmethod(custom)  clbreaks(0 .2 .40 .6 .8 1)  ///
        legend(position(4) ///
               region(lcolor(black)) ///
               label(1 "No data") ///
               label(2 "0% to 20%") ///
               label(3 "20% to 40%") ///
               label(4 "40% to 60%") ///
               label(5 "60% to 80%") /// 
               label(6 "80% to 100%")) ///
        legend(region(color(white))) ///
        title("Estimated poverty rate in BFA communes") ///
        subtitle("(Direct estimates)") ///
        note("Source: EHCVM 2021 Survey")
graph export "$figs\direct_communes.png", as(png) replace
* ------------------------------------------------------------------------------
*     Map 2
* ------------------------------------------------------------------------------		

geoframe create admin3 "$data_output\bfa_shp3.dta", replace shpfile("$data_output\bfa_adm3_coord.dta")

frame change admin3

format  fgt0 %6.2f 
 
geoplot ///
 (area admin3 fgt0, levels(10) color(viridis, reverse)) ///
 , legend(pos(2) outside) ///
 title("Estimated poverty rate in BFA communes", size(6) span) ///
 subtitle("(Direct estimates)") ///
 note("Source: EHCVM 2021 Survey", size(2))
 graph export "$figs\direct_communes2.png", as(png) replace
	 

*===============================================================================
//FH estimates  at the administrative level 3
*=============================================================================== 

* ------------------------------------------------------------------------------
*     Map 1
* ------------------------------------------------------------------------------
 
use  "$data_output\bfa_adm3.dta", clear
rename ADM3_PCODE adm3_pcode

merge 1:1 adm3_pcode using "$data_output\FH_sae_poverty.dta"
drop _merge
spmap fh_fgt0 using "$data_output\bfa_adm3_coord.dta" ///
        , ///
        id(_ID) ///
        fcolor(Reds) osize(.1) ocolor(black) ///
        clmethod(custom)  clbreaks(0 .2 .40 .6 .8 1)  ///
        legend(position(4) ///
               region(lcolor(black)) ///
               label(1 "No data") ///
               label(2 "0% to 20%") ///
               label(3 "20% to 40%") ///
               label(4 "40% to 60%") ///
               label(5 "60% to 80%") /// 
               label(6 "80% to 100%")) ///
        legend(region(color(white))) ///
        title("Estimated poverty rate in BFA communes") ///
        subtitle("(FH estimates)") ///
        note("Source: EHCVM 2021 Survey")
		
graph export "$figs\fh_commune.png", as(png) replace		

* ------------------------------------------------------------------------------
*     Map 2
* ------------------------------------------------------------------------------		

geoframe create admin3 "$data_output\bfa_shp3.dta", replace shpfile("$data_output\bfa_adm3_coord.dta")

frame change admin3

format  fgt0 %6.2f 
 
geoplot ///
 (area admin3 fh_fgt0, levels(10) color(viridis, reverse)) ///
 , legend(pos(2) outside) ///
 title("Estimated poverty rate in BFA communes", size(6) span) ///
 subtitle("(FH estimates)") ///
 note("Source: EHCVM 2021 Survey", size(2))
 graph export "$figs\fh_communes2.png", as(png) replace

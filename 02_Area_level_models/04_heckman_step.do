set more off
clear all


set matsize 8000
set seed 648743

*===============================================================================
//Specify team paths 
*===============================================================================
global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"
global figs        "$main\05.Graphics"


use "$data\commune_survey_ehcvm_bfa_2021.dta", clear

sort adm3_pcode
quietly by adm3_pcode:  gen dup = cond(_N==1,0,_n)

tabulate dup
/*
dup = 0       record is unique
dup = 1       record is duplicate, first occurrence
dup = 2       record is duplicate, second occurrence
dup = 3       record is duplicate, third occurrence
etc.



        dup |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        235       98.33       98.33
          1 |          2        0.84       99.16
          2 |          2        0.84      100.00
------------+-----------------------------------
      Total |        239      100.00

*/

drop if dup>1
drop dup


merge 1:1 adm3_pcode using "$data\direct_survey_ehcvm_bfa_2021_geo_covariates_admin3.dta"
drop _merge

foreach x of varlist geo_* acled_* health_* travel_* malaria_* night_* {
	gen `x'2 = `x' * `x'
}





gen dummy = (dir_fgt0 !=.)

stepwise, pr(.1): reg dummy acled_* 
reg dummy  acled_sh_inside5km_riots2   acled_sh_inside5km_riots acled_cdi acled_sh_inside5km_battles 
/*
stepwise, pr(.1): reg fgt0  geo_mndwi geo_brba geo_nbai geo_ndsi geo_vari geo_savi geo_osavi geo_ndmi geo_evi geo_ndvi geo_sr geo_arvi geo_ui acled_ei acled_cdi acled_sh_inside5km_vac acled_sh_inside5km_battles acled_sh_inside5km_riots acled_sh_inside5km_protests acled_sh_inside5km_erv health_access_m health_access_w travel_time_to_cities_2015
*/
//stepwise, pr(.1): reg fgt0 geo_* health_* malaria_* night_* travel_* acled_* adm1_pcode1-adm1_pcode13

heckman fgt0 hage		hcsp6	resid1	hcsp4	lien1	lien2	lien3	lien4	lien5	lien6	lien7	lien8	lien9	lien10	hsectins3		mstat3		mstat6	religion1	religion2	religion3	religion4	ethnie1	ethnie2	ethnie3	ethnie4	ethnie5	ethnie6	ethnie7	ethnie8	ethnie9	ethnie10	ethnie11	nation1	nation2		nation4			nation7	nation8	nation9	nation10	hcsp8	hsectins1	nation13	nation14	nation15	mal30j1		hos12m1	couvmal1			educ_hi1	educ_hi2	educ_hi3	hcsp9	educ_hi5	educ_hi6		educ_hi8	diplome1	diplome2	diplome3	diplome4	diplome5	diplome6	diplome7	diplome8	hcsp3		diplome11		internet1	activ7j1	activ7j2	activ7j3	activ7j4	activ7j5	activ12m1	branch1	branch2	branch3	branch4	branch5	branch6	branch7	branch8	branch9	branch10	bank1	logem1	logem2	logem3	mur1	hcsp5	sol1		elec_ac1	elec_ur1	elec_ua1	ordure1	toilet1	eva_toi1	eva_eau1	tv1	fer1	hsectins2	cuisin1	ordin1	decod1	hsectins5	sh_id_demo1	sh_co_natu1	sh_co_eco1		sh_co_vio1	sh_co_oth1	milieu1		hmstat2		hmstat4	hmstat5	hmstat6	hreligion1	hreligion2	hreligion3	hreligion4	hnation1	hnation2	hnation3	hcsp7	hnation5	hnation6	hnation7	hethnie1	hethnie2	hethnie3	hethnie4	hethnie5	hethnie6	hethnie7	hethnie8		hsectins4	halfa1	heduc1	heduc2	heduc3	heduc4	heduc5	heduc6	heduc7	hdiploma1	hdiploma2	hdiploma3	hdiploma4	hdiploma6	hdiploma7	hdiploma8	hdiploma9	hdiploma10	hhandig1	hactiv7j1	hcsp1	hcsp2	hactiv7j4	hactiv12m1	hbranch1	hbranch2	hbranch3	hbranch4	hbranch5	hbranch6	hbranch7		hbranch9	hbranch10  , select(acled_cdi_*) twostep


probit dummy  acled_sh_inside5km_riots2   acled_sh_inside5km_riots acled_sh_inside5km_battles acled_cdi_vac acled_cdi_battles acled_cdi_riots acled_cdi_protests acled_cdi_erv

probit dummy   acled_sh_inside5km_vac acled_sh_inside5km_battles acled_sh_inside5km_riots acled_sh_inside5km_protests acled_sh_inside5km_erv acled_cdi_vac acled_cdi_battles acled_cdi_riots acled_cdi_protests acled_cdi_erv

stepwise, pr(.1): probit dummy acled_cdi_*

probit dummy acled_cdi_vac acled_cdi_battles   acled_cdi_erv acled_sh_inside5km_battles acled_cdi_riots

gen dummy_ei_battles = (acled_ei_battles >0)
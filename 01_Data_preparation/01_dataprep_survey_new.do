**************************************
*This dofile prepares data from BFA EHCVM 2021 for
* small area estimation
*****************************************
clear all

set more off

version 14




// [aw=hhweight_panel]
*===============================================================================
//Specify team paths 
*===============================================================================

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso\00.Data"
global data_input       	"$main\00_Inputs\EHCVM data\BFA_2021_EHCVM-P_v02_M_Stata"
global data_output       	"$main\01_Outputs"

*===============================================================================
//
// Welfare data: ehcvm_welfare_2b_bfa2021.dta
// 
*===============================================================================

use "$data_input\ehcvm_welfare_2b_bfa2021.dta",clear



tabulate  milieu, gen(milieu)
tabulate  hgender, gen(hgender)
tabulate  hmstat, gen(hmstat)
tabulate  hreligion, gen(hreligion)
tabulate  hnation, gen(hnation)
tabulate  hethnie, gen(hethnie)
rename    halfa2 halfa_2
tabulate  halfa, gen(halfa)
tabulate  heduc, gen(heduc)
tabulate  hdiploma, gen(hdiploma)
tabulate  hhandig, gen(hhandig)
tabulate  hactiv7j, gen(hactiv7j)
tabulate  hactiv12m, gen(hactiv12m)
tabulate  hbranch, gen(hbranch)
tabulate  hsectins, gen(hsectins)
tabulate  hcsp, gen(hcsp)



save "$data_output\survey_ehcvm_bfa_2021.dta",replace

*===============================================================================
//
// Household data: ehcvm_menage_bfa2021.dta
// 
*===============================================================================

use "$data_input\ehcvm_menage_bfa2021.dta",clear

tabulate  logem, gen(logem)
tabulate  mur, gen(mur)
tabulate  toit, gen(toit)
tabulate  sol, gen(sol)
tabulate  eauboi_ss, gen(eauboi_ss)
tabulate  eauboi_sp, gen(eauboi_sp)
tabulate  elec_ac, gen(elec_ac)
tabulate  elec_ur, gen(elec_ur)
tabulate  elec_ua, gen(elec_ua)
tabulate  ordure, gen(ordure)
tabulate  toilet, gen(toilet)
tabulate  eva_toi, gen(eva_toi)
tabulate  eva_eau, gen(eva_eau)
tabulate  tv, gen(tv)
tabulate  fer, gen(fer)
tabulate  frigo, gen(frigo)
tabulate  cuisin, gen(cuisin)
tabulate  ordin, gen(ordin)
tabulate  decod, gen(decod)
tabulate  car, gen(car)
tabulate  sh_id_demo, gen(sh_id_demo)
tabulate  sh_co_natu, gen(sh_co_natu)
tabulate  sh_co_eco, gen(sh_co_eco)
tabulate  sh_id_eco, gen(sh_id_eco)
tabulate  sh_co_vio, gen(sh_co_vio)
tabulate  sh_co_oth, gen(sh_co_oth)


merge 1:1 hhid using "$data_output\survey_ehcvm_bfa_2021.dta"

drop  _merge

save "$data_output\survey_ehcvm_bfa_2021.dta",replace


*===============================================================================
//
//Individual data: ehcvm_individu_bfa2021.dta 
*===============================================================================

use "$data_input\ehcvm_individu_bfa2021.dta",clear

tabulate  resid, gen(resid)
tabulate  sexe, gen(sexe)
tabulate  lien, gen(lien)
tabulate  mstat, gen(mstat)
tabulate  religion, gen(religion)
tabulate  ethnie, gen(ethnie)
tabulate  nation, gen(nation)
tabulate  mal30j, gen(mal30j)
tabulate  aff30j, gen(aff30j)
tabulate  arrmal, gen(arrmal)
tabulate  hos12m, gen(hos12m)
tabulate  couvmal, gen(couvmal)
tabulate  handit, gen(handit)
rename alfa2 alfa_2
tabulate  alfa, gen(alfa)
tabulate  educ_scol, gen(educ_scol)
tabulate  educ_hi, gen(educ_hi)
tabulate  diplome, gen(diplome)
tabulate  telpor, gen(telpor)
tabulate  internet, gen(internet)
tabulate  activ7j, gen(activ7j)
tabulate  activ12m, gen(activ12m)
tabulate  branch, gen(branch)
tabulate  sectins, gen(sectins)
tabulate  csp, gen(csp)
tabulate  emploi_sec, gen(emploi_sec)
tabulate  sectins_sec, gen(sectins_sec)
tabulate  csp_sec, gen(csp_sec)
tabulate  bank, gen(bank)
tabulate  serviceconsult, gen(serviceconsult)
tabulate  persconsult, gen(persconsult)


save "$data_output\ehcvm_individu_bfa2021_with_dummy.dta",replace

//use "$data\ehcvm_individu_bfa2021_with_dummy.dta", clear

collapse (first) region* (mean) age resid1	resid2	sexe1	sexe2	lien1	lien2	lien3	lien4	lien5	lien6	lien7	lien8	lien9	lien10	lien11	mstat1	mstat2	mstat3	mstat4	mstat5	mstat6	mstat7	religion1	religion2	religion3	religion4	religion5	ethnie1	ethnie2	ethnie3	ethnie4	ethnie5	ethnie6	ethnie7	ethnie8	ethnie9	ethnie10	ethnie11	ethnie12	nation1	nation2	nation3	nation4	nation5	nation6	nation7	nation8	nation9	nation10	nation11	nation12	nation13	nation14	nation15	nation16	mal30j1	mal30j2	aff30j1	aff30j2	aff30j3	aff30j4	aff30j5	aff30j6	aff30j7	aff30j8	aff30j9	aff30j10	aff30j11	aff30j12	aff30j13	aff30j14	aff30j15	aff30j16	aff30j17	arrmal1	arrmal2	hos12m1	hos12m2	couvmal1	couvmal2	handit1	handit2	alfa1	alfa2	educ_scol1	educ_scol2	educ_scol3	educ_scol4	educ_scol5	educ_scol6	educ_scol7	educ_scol8	educ_hi1	educ_hi2	educ_hi3	educ_hi4	educ_hi5	educ_hi6	educ_hi7	educ_hi8	educ_hi9	diplome1	diplome2	diplome3	diplome4	diplome5	diplome6	diplome7	diplome8	diplome9	diplome10	diplome11	telpor1	telpor2	internet1	internet2	activ7j1	activ7j2	activ7j3	activ7j4	activ7j5	activ7j6	activ12m1	activ12m2	activ12m3	activ12m4	branch1	branch2	branch3	branch4	branch5	branch6	branch7	branch8	branch9	branch10	branch11	sectins1	sectins2	sectins3	sectins4	sectins5	sectins6	csp1	csp2	csp3	csp4	csp5	csp6	csp7	csp8	csp9	csp10	emploi_sec1	emploi_sec2	sectins_sec1	sectins_sec2	sectins_sec3	sectins_sec4	sectins_sec5	sectins_sec6	csp_sec1	csp_sec2	csp_sec3	csp_sec4	csp_sec5	csp_sec6	csp_sec7	csp_sec8	csp_sec9	csp_sec10	bank1	bank2	serviceconsult1	serviceconsult2	serviceconsult3	serviceconsult4	serviceconsult5	persconsult1	persconsult2	persconsult3	persconsult4 [aw=hhweight], by(hhid)


merge 1:1 hhid using "$data_output\survey_ehcvm_bfa_2021.dta"
drop  _merge

save "$data_output\survey_ehcvm_bfa_2021.dta",replace

//////////////////////////

use "$data_input\ehcvm_individu_bfa2021.dta",clear

keep hhid province commune
bys hhid: keep if _n==1

merge 1:1 hhid using "$data_output\survey_ehcvm_bfa_2021.dta"
drop  _merge

////////////////////////////

save "$data_output\survey_ehcvm_bfa_2021.dta",replace

*===============================================================================
// Merge with HDX Data
*===============================================================================
use "$data_input\BFA_HDX_ADM3_EHCVM_Matching.dta", clear 

merge m:1 hhid using "$data_output\survey_ehcvm_bfa_2021.dta"
/*

    Result                      Number of obs
    -----------------------------------------
    Not matched                           142
        from master                       142  (_merge==1)
        from using                          0  (_merge==2)

    Matched                             7,176  (_merge==3)
    -----------------------------------------


*/
drop  _merge
save "$data_output\survey_ehcvm_bfa_2021.dta",replace


*===============================================================================
// Covariates in commune level
*===============================================================================
use "$data_output\survey_ehcvm_bfa_2021.dta",clear


rename ADM3_CODE adm3_pcode
rename ADM2_CODE adm2_pcode
rename ADM1_CODE adm1_pcode
tabulate  adm1_pcode, gen(adm1_pcode_)
keep if hhid == . 
keep adm1_pcode adm2_pcode adm3_pcode adm1_pcode_*  hhsize hage age  hgender1 hgender2 resid1 resid2 sexe1 sexe2 lien1 lien2 lien3 lien4 lien5 lien6 lien7 lien8 lien9 lien10 lien11 mstat1 mstat2 mstat3 mstat4 mstat5 mstat6 mstat7 religion1 religion2 religion3 religion4 religion5 ethnie1 ethnie2 ethnie3 ethnie4 ethnie5 ethnie6 ethnie7 ethnie8 ethnie9 ethnie10 ethnie11 ethnie12 nation1 nation2 nation3 nation4 nation5 nation6 nation7 nation8 nation9 nation10 nation11 nation12 nation13 nation14 nation15 nation16 mal30j1 mal30j2 aff30j1 aff30j2 aff30j3 aff30j4 aff30j5 aff30j6 aff30j7 aff30j8 aff30j9 aff30j10 aff30j11 aff30j12 aff30j13 aff30j14 aff30j15 aff30j16 aff30j17 arrmal1 arrmal2 hos12m1 hos12m2 couvmal1 couvmal2 handit1 handit2 alfa1 alfa2 educ_scol1 educ_scol2 educ_scol3 educ_scol4 educ_scol5 educ_scol6 educ_scol7 educ_scol8 educ_hi1 educ_hi2 educ_hi3 educ_hi4 educ_hi5 educ_hi6 educ_hi7 educ_hi8 educ_hi9 diplome1 diplome2 diplome3 diplome4 diplome5 diplome6 diplome7 diplome8 diplome9 diplome10 diplome11 telpor1 telpor2 internet1 internet2 activ7j1 activ7j2 activ7j3 activ7j4 activ7j5 activ7j6 activ12m1 activ12m2 activ12m3 activ12m4 branch1 branch2 branch3 branch4 branch5 branch6 branch7 branch8 branch9 branch10 branch11 sectins1 sectins2 sectins3 sectins4 sectins5 sectins6 csp1 csp2 csp3 csp4 csp5 csp6 csp7 csp8 csp9 csp10 emploi_sec1 emploi_sec2 sectins_sec1 sectins_sec2 sectins_sec3 sectins_sec4 sectins_sec5 sectins_sec6 csp_sec1 csp_sec2 csp_sec3 csp_sec4 csp_sec5 csp_sec6 csp_sec7 csp_sec8 csp_sec9 csp_sec10 bank1 bank2 serviceconsult1 serviceconsult2 serviceconsult3 serviceconsult4 serviceconsult5 persconsult1 persconsult2 persconsult3 persconsult4 logem1 logem2 logem3 logem4 mur1 mur2 toit1 toit2 sol1 sol2 eauboi_ss1 eauboi_ss2 eauboi_sp1 eauboi_sp2 elec_ac1 elec_ac2 elec_ur1 elec_ur2 elec_ua1 elec_ua2 ordure1 ordure2 toilet1 toilet2 eva_toi1 eva_toi2 eva_eau1 eva_eau2 tv1 tv2 fer1 fer2 frigo1 frigo2 cuisin1 cuisin2 ordin1 ordin2 decod1 decod2 car1 car2 sh_id_demo1 sh_id_demo2 sh_co_natu1 sh_co_natu2 sh_co_eco1 sh_co_eco2 sh_id_eco1 sh_id_eco2 sh_co_vio1 sh_co_vio2 sh_co_oth1 sh_co_oth2 milieu1 milieu2 hmstat1 hmstat2 hmstat3 hmstat4 hmstat5 hmstat6 hmstat7 hreligion1 hreligion2 hreligion3 hreligion4 hreligion5 hnation1 hnation2 hnation3 hnation4 hnation5 hnation6 hnation7 hnation8 hethnie1 hethnie2 hethnie3 hethnie4 hethnie5 hethnie6 hethnie7 hethnie8 hethnie9 hethnie10 hethnie11 hethnie12 halfa1 halfa2 heduc1 heduc2 heduc3 heduc4 heduc5 heduc6 heduc7 heduc8 hdiploma1 hdiploma2 hdiploma3 hdiploma4 hdiploma5 hdiploma6 hdiploma7 hdiploma8 hdiploma9 hdiploma10 hdiploma11 hhandig1 hhandig2 hactiv7j1 hactiv7j2 hactiv7j3 hactiv7j4 hactiv7j5 hactiv12m1 hactiv12m2 hactiv12m3 hbranch1 hbranch2 hbranch3 hbranch4 hbranch5 hbranch6 hbranch7 hbranch8 hbranch9 hbranch10 hbranch11 hsectins1 hsectins2 hsectins3 hsectins4 hsectins5 hsectins6 hcsp1 hcsp2 hcsp3 hcsp4 hcsp5 hcsp6 hcsp7 hcsp8 hcsp9 hcsp10 


duplicates drop adm1_pcode adm2_pcode adm3_pcode, force


save "$data_output\commune_survey_ehcvm_bfa_2021_missingHHID.dta" ,replace 

use "$data_output\survey_ehcvm_bfa_2021.dta",clear
rename ADM3_CODE adm3_pcode
rename ADM2_CODE adm2_pcode
rename ADM1_CODE adm1_pcode
tabulate  adm1_pcode, gen(adm1_pcode_)
collapse  (first) adm1_pcode_* (mean)  hhsize hage age  hgender1 hgender2 resid1 resid2 sexe1 sexe2 lien1 lien2 lien3 lien4 lien5 lien6 lien7 lien8 lien9 lien10 lien11 mstat1 mstat2 mstat3 mstat4 mstat5 mstat6 mstat7 religion1 religion2 religion3 religion4 religion5 ethnie1 ethnie2 ethnie3 ethnie4 ethnie5 ethnie6 ethnie7 ethnie8 ethnie9 ethnie10 ethnie11 ethnie12 nation1 nation2 nation3 nation4 nation5 nation6 nation7 nation8 nation9 nation10 nation11 nation12 nation13 nation14 nation15 nation16 mal30j1 mal30j2 aff30j1 aff30j2 aff30j3 aff30j4 aff30j5 aff30j6 aff30j7 aff30j8 aff30j9 aff30j10 aff30j11 aff30j12 aff30j13 aff30j14 aff30j15 aff30j16 aff30j17 arrmal1 arrmal2 hos12m1 hos12m2 couvmal1 couvmal2 handit1 handit2 alfa1 alfa2 educ_scol1 educ_scol2 educ_scol3 educ_scol4 educ_scol5 educ_scol6 educ_scol7 educ_scol8 educ_hi1 educ_hi2 educ_hi3 educ_hi4 educ_hi5 educ_hi6 educ_hi7 educ_hi8 educ_hi9 diplome1 diplome2 diplome3 diplome4 diplome5 diplome6 diplome7 diplome8 diplome9 diplome10 diplome11 telpor1 telpor2 internet1 internet2 activ7j1 activ7j2 activ7j3 activ7j4 activ7j5 activ7j6 activ12m1 activ12m2 activ12m3 activ12m4 branch1 branch2 branch3 branch4 branch5 branch6 branch7 branch8 branch9 branch10 branch11 sectins1 sectins2 sectins3 sectins4 sectins5 sectins6 csp1 csp2 csp3 csp4 csp5 csp6 csp7 csp8 csp9 csp10 emploi_sec1 emploi_sec2 sectins_sec1 sectins_sec2 sectins_sec3 sectins_sec4 sectins_sec5 sectins_sec6 csp_sec1 csp_sec2 csp_sec3 csp_sec4 csp_sec5 csp_sec6 csp_sec7 csp_sec8 csp_sec9 csp_sec10 bank1 bank2 serviceconsult1 serviceconsult2 serviceconsult3 serviceconsult4 serviceconsult5 persconsult1 persconsult2 persconsult3 persconsult4 logem1 logem2 logem3 logem4 mur1 mur2 toit1 toit2 sol1 sol2 eauboi_ss1 eauboi_ss2 eauboi_sp1 eauboi_sp2 elec_ac1 elec_ac2 elec_ur1 elec_ur2 elec_ua1 elec_ua2 ordure1 ordure2 toilet1 toilet2 eva_toi1 eva_toi2 eva_eau1 eva_eau2 tv1 tv2 fer1 fer2 frigo1 frigo2 cuisin1 cuisin2 ordin1 ordin2 decod1 decod2 car1 car2 sh_id_demo1 sh_id_demo2 sh_co_natu1 sh_co_natu2 sh_co_eco1 sh_co_eco2 sh_id_eco1 sh_id_eco2 sh_co_vio1 sh_co_vio2 sh_co_oth1 sh_co_oth2 milieu1 milieu2 hmstat1 hmstat2 hmstat3 hmstat4 hmstat5 hmstat6 hmstat7 hreligion1 hreligion2 hreligion3 hreligion4 hreligion5 hnation1 hnation2 hnation3 hnation4 hnation5 hnation6 hnation7 hnation8 hethnie1 hethnie2 hethnie3 hethnie4 hethnie5 hethnie6 hethnie7 hethnie8 hethnie9 hethnie10 hethnie11 hethnie12 halfa1 halfa2 heduc1 heduc2 heduc3 heduc4 heduc5 heduc6 heduc7 heduc8 hdiploma1 hdiploma2 hdiploma3 hdiploma4 hdiploma5 hdiploma6 hdiploma7 hdiploma8 hdiploma9 hdiploma10 hdiploma11 hhandig1 hhandig2 hactiv7j1 hactiv7j2 hactiv7j3 hactiv7j4 hactiv7j5 hactiv12m1 hactiv12m2 hactiv12m3 hbranch1 hbranch2 hbranch3 hbranch4 hbranch5 hbranch6 hbranch7 hbranch8 hbranch9 hbranch10 hbranch11 hsectins1 hsectins2 hsectins3 hsectins4 hsectins5 hsectins6 hcsp1 hcsp2 hcsp3 hcsp4 hcsp5 hcsp6 hcsp7 hcsp8 hcsp9 hcsp10 (sum) pop=hhsize [aw=hhweight], by(adm1_pcode adm2_pcode adm3_pcode)

append using "$data_output\commune_survey_ehcvm_bfa_2021_missingHHID.dta"


save "$data_output\commune_survey_ehcvm_bfa_2021.dta",replace
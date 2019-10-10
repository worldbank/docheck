*===========================================================================
*Title:      Datacheck for project 03
*Author:       Laura Moreno
*Dependencies:  World Bank Poverty GP
*---------------------------------------------------------------------------

*#==================================================================
*#    0. Set up
*#==================================================================

clear all

global rootdatalib "S:\Datalib"
local c_date= c(current_date)
local today = subinstr("`c_date'", " " , "_", .)
local testfile cedlas03
global mainpath "Z:\public\Stats_Team\others\adocheck\project03"
set matsize 11000, permanently
local countrylist "BRA"
local foryears "2012(1)2017"
*#==================================================================
*#   1. Loop / no modification needed after this point
*#==================================================================



		noi di "`code' `year'"
		noi di "Do-check"	

				foreach code of local countrylist {
				foreach iyear of numlist `foryears' {
				foreach type in "base" "sedlac" {
					
					local period ""
					if ("`code'"=="arg") local period "period(s2)"
					if ("`code'"=="bra") local period "period(e1)"
					docheck, country(`code') year(`iyear') project(03)	run(replicate) type(`type') `period'
					
					clear
					set obs 1
					if ("`r(comparison)'"=="1") local comparison "Perfect comparison" 
					if ("`r(comparison)'"=="0") local comparison "Replicate with error"
					if ("`r(comparison)'"=="")  local comparison "No replicate"	
					if (_rc==601) {
					local comparison "Do-file not found"
					gen docheckresult="$S_DATE $S_TIME,`comparison', `r(name_do)', `r(country)', `r(year)'"
					}
					else {
					gen docheckresult="$S_DATE $S_TIME,`comparison', `r(name_do)', `r(country)', `r(year)', `r(survey)', `r(type)', `r(veralt)', `r(vermast)',`r(project)', `r(N_old)', `r(N_new)', `r(k_old)', `r(k_new)', `r(hh_old)', `r(hh_new)', `r(urban_old)', `r(urban_new)', `r(hombre_old)', `r(hombre_new)', `r(nipcf_old)', `r(nipcf_new)', `r(meanipcf_old)', `r(meanipcf_new)', `r(p10ipcf_old)', `r(p10ipcf_new)',  `r(p50ipcf_old)', `r(p50ipcf_new)', `r(p90ipcf_old)', `r(p90ipcf_new)', `r(gini_old)', `r(gini_new)',  `r(b40_old)', `r(b40_new)', `r(pov19_old)', `r(pov19_new)', `r(pov32_old)', `r(pov32_new)', `r(pov55_old)', `r(pov55_new)', `r(pop_old)', `r(pop_new)' "
					
					cap confirm file "${mainpath}\analysis_specific\docheck\docheck_pro03_`code'`iyear'`type'.dta"
					if (_rc==0) append using "${mainpath}\analysis_specific\docheck\docheck_pro03_`code'`iyear'`type'.dta"
					save "${mainpath}\analysis_specific\docheck\docheck_pro03_`code'`iyear'`type'.dta", replace
					
					}
					
				}	// end loop type
				}	// end loop year
				}	//end loop code
				

exit


*
**FIN
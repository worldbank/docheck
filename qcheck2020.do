*===============================================================================
*project:       Qcheck Oct2019
*Author:        Sandra Segovia / Laura Moreno 
*Dependencies:  World Bank Poverty GP
*-------------------------------------------------------------------------------

*Location: Z:\public\Stats_Team\others\adocheck\project03\do-files\

*Creation Date:   Oct2019
*Modification Date:   
*Do-file version:    01
*References:          
*Output:             Excel file
*===============================================================================

*===============================================================================
*                        0: Program set up
*===============================================================================
cap restore
clear all 
set more off
set matsize 5000
set memory 800m

**Add main directories**********************************************************

global mainpath "Z:\public\Stats_Team\others\adocheck\project03"  
global testdir "${mainpath}\test"

*===============================================================================
*                       1: Options
*===============================================================================

**Add all specific options here!
** This are the options used for the program qcheck

local countrylist "ARG BRA MEX"
local foryears 2000(1)2018
local testfile "cedlas03"				  		// name of the test
local pro "03"
local out_file "project`pro'`country'`year'"	// name of the output file

local type "sedlac"						  // sedlac, base or lablac
local source "datalib"					  // datalib, datalibweb or others 

local w "pondera"						  // weight for dynamic tests

local varlist_sta "all"		  			  // vars for static test
local varlist_dyn "all"					  // vars for dynamic tests
local varlist_cat  "all"				  // vars for categorical tests
 

*===============================================================================
*                        2: Update Tests
*===============================================================================

**Whenever there is an update/change in the test, run this line

qcheck load, path(${testdir}) test(qcheck_`testfile') replace

*===============================================================================
*                      3: Which tests do we want?
*===============================================================================


local static="yes"					// Static Test
local dyn_basic="yes"				// Dynamic Test (Basic)
local dyn_indic = "yes"				// Dynamic Test (indicators:Pov & Ineq)
local dyn_cat="yes"					// Dynamic Test (Categorical- Weighted)
local dyn_cat_unw="yes"				// Dynamic Test (Categorical-Unweighted)


*===============================================================================
*              4: Tests  ( no modification needed after this point)
*===============================================================================

foreach year of numlist `foryears' {
	noi di "`year'"
	foreach country of local countrylist {
		noi di "`code'"
		if ("`code'"=="ARG") local elperiod "period(s2)"
		if ("`code'"!="ARG") local elperiod ""

*******************************Static*******************************************
		if ("`static'"=="yes") {
			noi di "Static" 
			cap mkdir "${mainpath}\analysis_specific\static"
			cap qcheck static, countries(`country') year(`year') ///
				path(${mainpath}\analysis_specific\static) test(`testfile') ///
				var(`varlist_sta') replace out(`out_file'`country'`year') ///
				project(`pro') type(`type') source(`source') ///

			local rc=_rc
			local sta "`country', `year', static, `rc', $S_DATE $S_TIME"
			noi di "`sta'"
				
		} // end if static test		
					
*******************************Dynamic Basic************************************		
		if ("`dyn_basic'"=="yes")  {

			noi di "Dynamic Basic" 
			cap mkdir "${mainpath}\analysis_specific\dyn_basic"
			cap qcheck dynamic, countries(`country') year(`year') ///
				path(${mainpath}\analysis_specific\dyn_basic) ///
				test(`testfile') var(`varlist_dyn') replace ///
				out(`out_file'`country'`year') project(`pro') ///
				cases(basic) weight(`w') source(`source') ///
				type(`type') ///
				
			local rc=_rc
			local dba "`country', `year', dyn_basic, `rc', $S_DATE $S_TIME"
			noi di "`dba'"
		} // end if dynamic test
						
		
************************Dynamic Poverty/Inequality******************************		
		if ("`dyn_indic'"=="yes")  {

			noi di "Dynamic Basic" 
			cap mkdir "${mainpath}\analysis_specific\dyn_indic"
			cap qcheck dynamic, countries(`country') year(`year') ///
				path(${mainpath}\analysis_specific\dyn_indic) ///
				test(`testfile') var(`varlist_dyn') replace ///
				out(`out_file'`country'`year') project(`pro') ///
				cases(povertyinequal) weight(`w') source(`source') ///
				type(`type')  ///
				
			local rc=_rc
			local din "`country', `year', dyn_indic, `rc', $S_DATE $S_TIME"
			noi di "`din'"
		} // end if dynamic test
		
*****************************Dynamic Categorical********************************				
		
		if ("`dyn_cat'"=="yes")  {
			noi di "Dynamic Categorical" 
			cap mkdir "${mainpath}\analysis_specific\dyn_categ"
			cap qcheck dynamic, countries(`country') year(`year') ///
				path(${mainpath}\analysis_specific\dyn_categ) ///
				test(`testfile') var(`varlist_cat') replace /// 
				out(`out_file'`country'`year') project(`pro') ///
				cases(categorical) weight(`w') source(`source')  ///
				type(`type') ///
				
			local rc=_rc
			local dc  "`country', `year', dyn_cat, `rc', $S_DATE $S_TIME"
			noi di "`dc'"
		} // end if dynamic test		
				
*****************************Dynamic Categorical UNWEIGHTED*********************				
		if ("`dyn_cat_unw'"=="yes")  {
			noi di "Dynamic Categorical-Unweighted" 
			cap mkdir "${mainpath}\analysis_specific\dyn_categ_unw"
			cap qcheck dynamic, countries(`country') year(`year') ///
				path(${mainpath}\analysis_specific\dyn_categ_unw) ///
				test(`testfile') var(`varlist_cat') replace /// 
				out(`out_file'`country'`year') project(`pro') ///
				cases(categorical) source(`source')  ///
				type(`type') ///
				
			local rc=_rc
			local dc_unw "`country', `year', dyn_cat_unw,`rc', $S_DATE $S_TIME"
			noi di "`dc_unw'"
		} // end if dynamic test		
		
********************************************************************************
		
	}  // end countrylist loop

} // end years loop		
		
exit



*===============================================================================
*   						5. Append
*===============================================================================

*ssc install fs
*generalizar
cd ""
clear
fs basicqcheck@*.dta
append using `r(files)'

replace country = "Argentina" if acronym ==	"arg"
replace country = "Bolivia"	 if acronym ==	"bol"
replace country = "Brazil"	 if acronym ==	"bra"
replace country = "Chile"	 if acronym ==	"chl"
replace country = "Colombia" if acronym ==	"col"
replace country = "Costa Rica" if acronym == "cri"
replace country = "Dominican Republic"	if acronym =="dom"
replace country = "Ecuador" if acronym == "ecu"
replace country = "El Salvador"	if acronym =="slv"
replace country = "Guatemala"	if acronym =="gtm"
replace country = "Honduras"	if acronym =="hnd"
replace country = "Haiti"		if acronym =="hti"
replace country = "Mexico"		if acronym =="mex"
replace country = "Nicaragua"	if acronym =="nic"
replace country = "Panama"		if acronym =="pan"
replace country = "Paraguay"	if acronym =="pry"
replace country = "Peru"		if acronym =="per"
replace country = "Uruguay"	if acronym =="ury"

replace type = "sedlac" 

save "${qpath}\dyn_basic@`basename'.dta", replace


*===============================================================================
*   						3. Export
*===============================================================================

export excel using "${qpath}\dyn_basic@`basename'.xlsx", ///
	sheetreplace firstrow(variables) sheet("dyn_basic@`basename'")







exit

/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

Notes:
1.
2.
3.


Version Control:


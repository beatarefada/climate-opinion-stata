*-------------------------------------------------------------------------------
* Project: Climate Change Opinion Analysis (Data from Howe et al., 2015)
* Author: Betania Alves
* Date: February 2026
* Purpose: Data cleaning, integrity checks, and automated regression analysis
*-------------------------------------------------------------------------------

* 1. SETUP & ENVIRONMENT
* ------------------------------------------------------------------------------
version 17
clear all
set more off
macro drop _all

* Define output directory (Current directory)
local output_dir "." 

* 2. IMPORT DATA
* ------------------------------------------------------------------------------
import delimited "https://course-resources.minerva.edu/uploaded_files/mke/Y6azen/howe-2016-data.csv", clear

* Keep only state-level observations
keep if GeoType == "State"

* 3. DATA INTEGRITY CHECKS
* ------------------------------------------------------------------------------
* Verify that each state appears only once (Primary Key Check)
* Ensures data is tidy and uniquely identified by GeoName
isid GeoName 

* Check for missing values in key analysis variables
misstable summarize supportRPS discuss mediaweekly

* 4. FEATURE ENGINEERING
* ------------------------------------------------------------------------------
* Initialize region variable
generate region = "Other"

* Assign states to macro-regions
replace region = "Southeast" if inlist(GeoName, "District of Columbia", "Virginia", "Alabama", "Arkansas", "Florida", "Georgia", "Kentucky", "Louisiana", "Mississippi", "North Carolina", "South Carolina", "Tennessee", "West Virginia")
replace region = "West" if inlist(GeoName, "Alaska", "California", "Colorado", "Hawaii", "Idaho", "Montana", "Nevada", "Oregon", "Utah", "Washington", "Wyoming")
replace region = "Southwest" if inlist(GeoName, "Arizona", "New Mexico", "Oklahoma", "Texas")
replace region = "Northeast" if inlist(GeoName, "Connecticut", "Delaware", "Maine", "Maryland", "Massachusetts", "New Hampshire", "New Jersey", "New York", "Pennsylvania", "Rhode Island", "Vermont")
replace region = "Midwest" if inlist(GeoName, "Illinois", "Indiana", "Iowa", "Kansas", "Michigan", "Minnesota", "Missouri", "Nebraska", "North Dakota", "Ohio", "South Dakota", "Wisconsin")

* Create numeric identifier for categorical analysis
encode region, gen(region_id)

* 5. DESCRIPTIVE STATISTICS
* ------------------------------------------------------------------------------
* Preserve full dataset state before subsetting
preserve 
keep if region == "Northeast"

* Calculate mean opposition scores for key policy variables
display "--- Average Opposition Scores (Northeast) ---"
foreach var of varlist CO2limitsOppose regulateOppose supportRPSOppose fundrenewablesOppose {
    quietly summarize `var'
    display "`var': " %9.2f r(mean) "%"
}

* 6. REGRESSION ANALYSIS
* ------------------------------------------------------------------------------
* Objective: Identify drivers of support for Renewable Portfolio Standards (RPS)

* Define predictor variables for iteration
local predictors "discuss mediaweekly"
local model_count = 1

* Loop through predictors to generate sequential models
foreach x of local predictors {
    * Run OLS regression with robust standard errors
    regress supportRPS `x', robust
    
    * Store model results for table generation
    estimates store m`model_count'
    
    * Increment model counter
    local model_count = `model_count' + 1
}

* 7. EXPORT RESULTS
* ------------------------------------------------------------------------------
* Display regression table in console
estimates table m1 m2, star stats(N r2) b(%9.3f) se(%9.3f) title("Regression Results")

* Export results to CSV
esttable m1 m2 using "`output_dir'/regression_results.csv", replace ///
    stats(N r2) b(%9.3f) se(%9.3f)

* 8. VISUALIZATION
* ------------------------------------------------------------------------------
* Visualize relationship between discussion frequency and policy support
twoway (scatter supportRPS discuss, mcolor(navy%70)) ///
       (lfit supportRPS discuss, lcolor(red)), ///
       title("Discussion vs. Policy Support (Northeast)") ///
       xtitle("Discuss with family and friends (%)") ///
       ytitle("Support for RPS (%)") ///
       legend(off) scheme(s2color)

* Restore full dataset
restore
exit

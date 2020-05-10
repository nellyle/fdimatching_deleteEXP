/*******************************************************************************
						DESCRIPTIVE ANALYSIS DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	  Do-File 02
		
		PURPOSE:	Analysis of Dataset
		
		OUTLINE:	PART 1:	Overview
					PART 2: Summary Statistics
					PART 3: Balance Tables
					
********************************************************************************
					PART 1: Overview
*******************************************************************************/
 
	describe
	
//	Frequencies of FDI types
	tab FDITYPE2016
	
*------------------------------------------------------------------------------*
*	PART 1.1: Correlations matrix
*------------------------------------------------------------------------------*

	corr	FDI2016 ///
			OWN TECH PORT ///
			logwages2015 TFP2015 emp2015 DEBTS2015 EXP2015 RD2015 

	
********************************************************************************
*					PART 2: Summary Statistics
********************************************************************************

//	Continuous variables	
	outreg2 using "$results/02_Descriptive_Analysis/summarystats.tex", ///
	sum(detail) replace ///
	keep(wages15 TFP2015 debts15 EXP2015 emp2015) ///
	label eqkeep(mean p50 sd min max)
	
//	Categorical variables
	tab PORT
	tab OWN
	tab TECH
	tab RD2015
	
*------------------------------------------------------------------------------*
*	PART 2.1: Checking for Outliers in employment variable
*------------------------------------------------------------------------------*

	set scheme plotplainblind
	scatter TFP2017 emp2015, ytitle("TFP in 2017")	
	graph save $results/02_Descriptive_Analysis/emp2015_outliers.gph, ///
	replace

	graph export $results/02_Descriptive_Analysis/emp2015_outliers.png, ///
	as(png) replace


********************************************************************************
*					PART 3: Balance Tables
********************************************************************************
	
//			By treatment variable 
iebaltab 	TECH PORT ///
			logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, ///
			grpvar(FDI2016) ///
			savetex("$results/02_Descriptive_Analysis/baltest_byfdi_pre.tex") ///
			rowvarlabels texdoc replace

		
//			By FDI type (treatment arms) [not reported in paper]
iebaltab 	TECH PORT ///
			logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, ///
			grpvar(FDITYPE2016) ///
			savetex("$results/02_Descriptive_Analysis/baltest_fditype_pre.tex") ///
			rowvarlabels texdoc replace
			
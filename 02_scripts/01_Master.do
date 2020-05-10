/*******************************************************************************
								MASTER DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	  Do-File 01
	
		PURPOSE:	Root file that manages the execution of all 
					subordinated do-files.
		
		OUTLINE:	PART 1:	Prepare Folder Paths
					PART 2: Descriptive Analysis
					PART 3: Results
						 3.1: Effect of FDI on TFP
						 3.2: Robustness Checks
						 3.3: Analysis by  Type of FDI
					

********************************************************************************
			PART 1: Prepare Folder Paths
*******************************************************************************/
	
	global root	"C:\Users\Emilie\Documents\Emilie\Master\Nottingham\2_Appl_Microeconometrics\fdimatching_deleteEXP"

	cap log close
	log using $root/log_fdi_matching, replace
	clear all
	
*------------------------------------------------------------------------------*
*	PART 1.0: Download Packages
*------------------------------------------------------------------------------*

//	package gr0070 from http://www.stata-journal.com/software/sj17-3
	cap ssc install gr0070
	
//	package outreg2
	cap ssc install outreg2
	
//	package tabout
	cap ssc install tabout

*------------------------------------------------------------------------------*
*	PART 1.1: Set globals for do-file routines
*------------------------------------------------------------------------------*
	
	global input	"$root/01_input"
	global scripts	"$root/02_scripts"
	global log	"$root/03_log"
	global results	"$root/04_results"
	
	use "$input/FDI_project"


*------------------------------------------------------------------------------*
*	PART 1.2: Adjust variable labels
*------------------------------------------------------------------------------*

	label var OWN "Ownership"
	label var TECH "Technology intensity"
	label var PORT "Access to port"
	label var logwages2015 "Log wages"
	label var TFP2015 "TFP"
	label var logemp2015 "Log employment"
	label var DEBTS2015 "Log debts"
	label var EXP2015 "Export intensity"
	label var RD2015 "R&D dummy"
	label var logwages2017 "Log wages"
	label var TFP2017 "TFP"
	
*------------------------------------------------------------------------------*
*	PART 1.3: Transforming variables
*------------------------------------------------------------------------------*

	generate TFPS17=  (TFP2017-3.656046)/2.056464
	generate emp2015= exp(logemp2015)
	generate wages15 = exp(logwages2015)
	generate debts15 = exp(DEBTS2015)

	save $input/fdi_matching_clean, replace
	
*------------------------------------------------------------------------------*
*	PART 1.4: Set globals for variables
*------------------------------------------------------------------------------*

	global F "OWN TECH RD2015"
	global C "logwages2015 TFP2015 emp2015 DEBTS2015"

********************************************************************************
*			PART 2: Descriptive Analysis
********************************************************************************

		do $scripts/02_Descriptive_Analysis
	

********************************************************************************
*			PART 3: Results
********************************************************************************

*------------------------------------------------------------------------------*
*	PART 3.1: Effect of FDI on TFP
*------------------------------------------------------------------------------*

		do $scripts/03a_Main_Results

*------------------------------------------------------------------------------*
*	PART 3.2: Robustness Checks
*------------------------------------------------------------------------------*

		do $scripts/03b_Robustness_Checks

*------------------------------------------------------------------------------*
*	PART 3.3: Analysis by  Type of FDI
*------------------------------------------------------------------------------*

		do $scripts/03c_by_FDITYPE
	
	

	log close
	translate $root/log_fdi_matching.smcl $root/log_fdi_matching.pdf , ///
	trans(smcl2pdf) replace 	
	
	erase $root/log_fdi_matching.smcl







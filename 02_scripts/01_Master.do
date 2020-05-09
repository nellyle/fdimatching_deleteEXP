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

	cap log close
	log using $log/fdi_matching, replace
	clear all
	
*------------------------------------------------------------------------------*
*	PART 1.1: Set globals for do-file routines
*------------------------------------------------------------------------------*

//	Adjust root file:	
	global root	"C:\Users\schne\Documents\GitHub\try\fdimatching_deleteEXP"

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

		do $scripts/03d_by_FDITYPE
	
	

	log close
	translate $log/fdi_matching,.smcl $log/fdi_matching,.pdf , ///
	trans(smcl2pdf) replace 	
	
	erase $log/fdi_matching,.smcl







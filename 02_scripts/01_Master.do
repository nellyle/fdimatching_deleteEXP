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
					PART 3: PSM
					PART 4: Robustness Checks 
					
********************************************************************************
			PART 1: Prepare Folder Paths
*******************************************************************************/

	clear all

*------------------------------------------------------------------------------*
*	PART 1.1: Set globals for do-file routines
*------------------------------------------------------------------------------*

//	Adjust root file:	
	global root	"/Users/theazollner/Documents/GitHub/fdimatching_clean"

	global input	"$root\01_input"
	global scripts	"$root\02_scripts"
	global log		"$root\03_log"
	global results	"$root\04_results"
	
	use "$input\FDI_project"
	
********************************************************************************
*			PART 2: Descriptive Analysis
********************************************************************************

	cap log close
	log using $log\02_Descriptive_Analysis, replace

			do $scripts\$02_scripts\02_Descriptive_Analysis
	
	log close
	translate $log\02_Descriptive_Analysis.smcl $log\02_Descriptive_Analysis.pdf , ///
	trans(smcl2pdf) replace 	
	
	erase $log\02_Descriptive_Analysis.smcl


********************************************************************************
*			PART 3: Matching
********************************************************************************

*------------------------------------------------------------------------------*
*	PART 3.1: PSM
*------------------------------------------------------------------------------*
	
	cap log close
	log using $log\03_PSM, replace

			do $scripts\03_PSM
	
	log close
	translate $log\03_PSM.smcl $log\03_PSM.pdf , ///
	trans(smcl2pdf) replace 	
	
	erase $log\03_PSM.smcl

*------------------------------------------------------------------------------*
*	PART 3.2: NNM
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
*	PART 3.3: AIPW
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
*	PART 3.4: FDITYPE
*------------------------------------------------------------------------------*	

	
********************************************************************************
*			PART 4: Robustness Checks 
********************************************************************************





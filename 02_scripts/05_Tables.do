/*******************************************************************************
								Tables DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 03a
		
		PURPOSE:	Tables to include in .tex file
		
		OUTLINE:	TABLE 1: Frequency of FDI Types 
					TABLE 2: MAIN RESULTS
					TABLE 3: ROBUSTNESS
		
********************************************************************************
			TABLE 3: ROBUSTNESS
*******************************************************************************/
*------------------------------------TFP---------------------------------------*

//TME1: displays the coefficients for the logit treatment model; euqation from treatment effect
//OME0 and OME1 represent the linear regression coefficients for the untreated and treated potential-outcome equations, respectively

*------------------------------------------------------------------------------*
*	(1) NN1 interaction
*	(2) NN1 (excluding emp outlier>8.000.000)
*	(3) NN1 (including port)
*	(4) ATT for NN1
*------------------------------------------------------------------------------*//


//	Setting globals and generating variables
	
	cap generate TFPS17=  (TFP2017-3.656046)/2.056464
	cap generate emp2015= exp(logemp2015)
	
	global F "OWN TECH"
	global C "logwages2015 TFP2015 emp2015 DEBTS2015 RD2015"


*====================*
* (1) NN1 interaction
*====================*

	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
						(FDI2016 i.($F)##c.($C), logit), atet	///
						osample(osa1) generate(p1)

	outreg2 using $results/05_Tables/Table3_Robustness.tex, replace dec(3) drop(i.OWN i.TECH logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) nocon eqdrop(TME1) 


*====================*
* (2) NN1 emp2015<8M
*====================*

	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
						(FDI2016 i.($F) c.($C), logit) if emp2015<4000000,		///
						osample(osa1) generate(p1)

	outreg2 using $results/05_Tables/Table3_Robustness.tex, append dec(3) drop(i.OWN i.TECH logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) nocon eqdrop(TME1) 


*====================*
* (3) NN1 (incl. port)
*====================*

global P "OWN TECH PORT"

	cap drop osa1 
	cap drop p1* 
	teffects psmatch (TFPS17) ///
					 (FDI2016 i.($P) c.($C), logit),	///
					  osample(osa1) generate(p1)
	outreg2 using $results/05_Tables/Table3_Robustness.tex, append dec(3) drop(i.OWN i.TECH i.PORT logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) nocon eqdrop(TME1)


*====================*
* (4) ATT for NN1
*====================*

	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
						(FDI2016 i.($F) c.($C), logit), atet	///
						osample(osa1) generate(p1)

	outreg2 using $results/05_Tables/Table3_Robustness.tex, append dec(3) drop(i.OWN i.TECH logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) nocon eqdrop(TME1) 


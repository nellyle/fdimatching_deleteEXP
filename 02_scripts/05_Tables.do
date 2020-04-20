/*******************************************************************************
								Tables DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 03a
		
		PURPOSE:	Tables to include in .tex file
		
		OUTLINE:	PART 1:	TFP
					PART 2: Wages
														
*------------------------------------------------------------------------------*
*	PART 1:TFP  Output - Including TECH, excluding EXP
*------------------------------------------------------------------------------*
*------------------------------------TFP---------------------------------------*

//TME1: displays the coefficients for the logit treatment model; euqation from treatment effect
//OME0 and OME1 represent the linear regression coefficients for the untreated and treated potential-outcome equations, respectively

*------------------------------------------------------------------------------*
*	Table 1: NN1, NN5, caliper(0.05)
*------------------------------------------------------------------------------*//

//	Setting globals and generating variables
	
	cap generate TFPS17=  (TFP2017-3.656046)/2.056464
	cap generate emp2015= exp(logemp2015)
	
	global F "OWN TECH RD2015"
	global C "logwages2015 TFP2015 emp2015 DEBTS2015"
	

	//NN1
		//ATE
	cap drop osa1 
	cap drop p1* 
	 cap teffects psmatch (TFPS17) ///
					 (FDI2016 i.OWN i.PORT ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015, logit),	///
					  osample(osa1) generate(p1)
	outreg2 using $results/05_Tables/Table1.2_TFP.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1)
	
		// ATET
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
						(FDI2016 i.OWN i.PORT ///
						logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015, logit), atet	///
						osample(osa1) generate(p1)

	outreg2 using $results/05_Tables/Table1.2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 

	//NN5 caliper 0.05
		// ATE	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
						(FDI2016 i.OWN i.PORT ///
						logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015, logit),	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 5 observations violate caliper
	 
	// Reestimate
	cap teffects psmatch (TFPS17) ///
					 (FDI2016 i.OWN i.PORT ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015, logit) if osa1==0,	///
					  nneighbor(5) caliper(.05)  generate(p1) 
					  
	outreg2 using $results/05_Tables/Table1.2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 
	
		// ATET
cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
						(FDI2016 i.OWN i.PORT ///
						logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015, logit), atet	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 6  observations have fewer than 5 propensity-score matches within caliper .05
	 
	// Reestimate
	cap teffects psmatch (TFPS17) ///
					 (FDI2016 i.OWN i.PORT ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015, logit) if osa1==0, atet	///
					  nneighbor(5) caliper(.05)  generate(p1)
	outreg2 using $results/05_Tables/Table1.2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 
	
*------------------------------------------------------------------------------*
*	Table 1: IPW, AIPW (TFP)
*------------------------------------------------------------------------------* 
//IWP:

	//ATE
cap drop osa1
	teffects ipw (TFPS17) (FDI2016 i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015),  	osample(osa1) 
	outreg2 using $results/05_Tables/Table1.2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 
	
	//ATET
	cap drop osa1	
teffects ipw (TFPS17) ///
						(FDI2016 i.OWN i.PORT ///
						logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015, logit), atet	///
						 osample(osa1) 	
	outreg2 using $results/05_Tables/Table1.2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 

//AIWP
	cap drop osa1
teffects aipw (TFPS17 emp2015 logwages2015 TFP2015 i.OWN i.TECH RD2015 DEBTS2015)(FDI2016 emp2015 logwages2015 TFP2015 i.TECH i.OWN RD2015 DEBTS2015) 

	outreg2 using $results/05_Tables/Table1.2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon  eqdrop(OME0 OME1 TME1)

***----Robustness 
**Drop Outlierss	
	cap drop osa1
teffects aipw (TFPS17 emp2015 logwages2015 TFP2015 i.OWN i.TECH RD2015 DEBTS2015)(FDI2016 emp2015 logwages2015 TFP2015 i.TECH i.OWN RD2015 DEBTS2015) if emp2015<8000000

*------------------------------------------------------------------------------*
*	PART 2: WAGES, Excluding TECH, including EXP
*------------------------------------------------------------------------------*
*------------------------------------WAGES-------------------------------------*
	//NN1
		// ATE
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.PORT ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015, logit),	///
					  osample(osa1) generate(p1)	  
					  
					  
	outreg2 using $results/05_Tables/Table1.1_wages.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 
	
		// ATET
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
						(FDI2016 i.OWN i.PORT ///
						logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015, logit), atet	///
						 osample(osa1) generate(p1)

	outreg2 using $results/05_Tables/Table1.1_wages.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1)
					  
	// NN5 caliper0.05: 
		// ATE
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
						(FDI2016 i.OWN i.PORT ///
						logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015, logit),	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 6 observations violate caliper

	// Reestimate
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.PORT ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015, logit) if osa1==0,	///
					  nneighbor(5) caliper(.05)  generate(p1) 
					  
	outreg2 using $results/05_Tables/Table1.1_wages.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 
		
		//ATET
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
						(FDI2016 i.OWN i.PORT ///
						logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015, logit), atet	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 6  observations have fewer than 5 propensity-score matches within caliper .05
	 
	// Reestimate
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.PORT ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015, logit) if osa1==0, atet	///
					  nneighbor(5) caliper(.05)  generate(p1)
	outreg2 using $results/05_Tables/Table1.1_wages.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 
	

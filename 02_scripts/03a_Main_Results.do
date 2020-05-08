/*******************************************************************************
							MAIN RESULTS DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 03a
	
		PURPOSE:	Estimation of the effect of FDI on TFP.
		
		OUTLINE:	PART 1: Several ATE estimations for	main model 
					PART 1.1: Setting globals and generating variables
					Part 1.2: NN1
					Part 1.3: NN5 with caliper 0.05
					Part 1.4: IPW
					Part 1.5: AIPW

********************************************************************************
			PART 1: 
*******************************************************************************/

*------------------------------------------------------------------------------*
*	PART 1.1: Setting globals and generating variables 
*------------------------------------------------------------------------------*
	
	cap generate TFPS17=  (TFP2017-3.656046)/2.056464
	cap generate emp2015= exp(logemp2015)
	
	global F "OWN TECH RD2015"
	global C "logwages2015 TFP2015 emp2015 DEBTS2015"
	
*------------------------------------------------------------------------------*
*	PART 1.2: NN1
*------------------------------------------------------------------------------*
		//ATE
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
					 (FDI2016 i.($F) c.($C), logit),	///
					  osample(osa1) generate(p1)
					  
	outreg2 using $results/05_Tables/Table2_TFP.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1)
	
	tebalance summarize

*------------------------------------------------------------------------------*
*	PART 1.3: NN5 with caliper 0.05 
*------------------------------------------------------------------------------*	
		// ATE	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
						(FDI2016 i.($F) c.($C), logit),	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 5 observations violate caliper
	 
	// Reestimate
	cap teffects psmatch (TFPS17) ///
					 (FDI2016 i.($F) c.($C), logit) if osa1==0,	///
					  nneighbor(5) caliper(.05)  generate(p1) 
					  
	outreg2 using $results/05_Tables/Table2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 
	
 tebalance summarize 
 
*------------------------------------------------------------------------------*
*	PART 1.4: IPW
*------------------------------------------------------------------------------*
		//ATE
cap drop osa1
	teffects ipw (TFPS17) (FDI2016 i.($F) c.($C), logit),  	osample(osa1) 
	outreg2 using $results/05_Tables/Table2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 
	
	tebalance summarize
	
*------------------------------------------------------------------------------*
*	PART 1.5: AIWP 
*------------------------------------------------------------------------------*		
// ATE
	cap drop osa1
teffects aipw (TFP2017 ($F)($C) )(FDI2016 i.($F) c.($C) ) 

	outreg2 using $results/05_Tables/Table2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 emp2015 DEBTS2015 i.TECH RD2015) nocon  eqdrop(OME0 OME1 TME1)
	
	tebalance summarize



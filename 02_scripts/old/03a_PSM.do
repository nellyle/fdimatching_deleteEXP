/*******************************************************************************
								PSM DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 03a
		
		PURPOSE:	Perform Propensity Score Matching
					Effect of FDI on TFP
		
		OUTLINE:	PART 1:	Complete Model
					PART 2: Improved Model (w/o EXP)
														
	
********************************************************************************
					PART 1:	Complete Model
*******************************************************************************/

//	Setting globals for interaction terms
	global F "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
cap gen TFPS17 =  (TFP2017 -  3.656046) / 2.056464
*------------------------------------------------------------------------------*
*	PART 1.1: No interactions
*------------------------------------------------------------------------------*

*========*
* Logit
*========*

*	ATE:
*	----
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015),	///
					  osample(osa1) generate(p1)
	// Significant ATE			

	teffects overlap, ptlevel(1) saving($results/03a_PSM/overl_log_comp1.gph, replace)
	graph export $results/03a_PSM/overl_log_comp1.pdf, as(pdf) replace
	// Really bad overlap
	
	tebalance summarize
	// SD catastrophy. VR not good either.
			  
					  
*========*
* Probit
*========*
*	ATE:
*	----	
	cap drop osa1 
	cap drop p1 	
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit),	///
					  osample(osa1) generate(p1)
				   // violation of overlap assumption for 389 obs 	

	// Reestimate			   
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit)	///
					  if osa1 == 0
					  
	tebalance summarize
	// SD catastrophy. VR not good either.
					  
	teffects overlap, ptlevel(1) saving($results/03a_PSM/overl_prob_comp1.gph, replace)
	graph export $results/03a_PSM/overl_prob_comp1.pdf, as(pdf) replace
	// Really bad overlap

		
*------------------------------------------------------------------------------*
*	PART 1.2: Interacting dummies 
*------------------------------------------------------------------------------*
/* 	From now on only probit, bc. no large differences and previous pscore 
	estimations consistently gave higher R2.								*/
	
*	ATE:
*	----	
	cap drop osa1 
	cap drop p1 	
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.($F)##i.($F) $C, probit),	///
					  osample(osa1) generate(p1)
				   // violation of overlap assumption for 415 obs 	

	// Reestimate			   
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($F)##i.($F) $C, probit)	///
					 if osa1 == 0
					  
	tebalance summarize
	// SD catastrophy. VR not good.
					  
	teffects overlap, ptlevel(1)
	// Really bad overlap

*------------------------------------------------------------------------------*
*	PART 1.3: Interacting continuous variables
*------------------------------------------------------------------------------*

*	ATE:
*	----	
	cap drop osa1 
	cap drop p1 	
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.($F) c.($C)##c.($C), probit),	///
					  osample(osa1) generate(p1)
				   // violation of overlap assumption for 517 obs 	

	// Reestimate			   
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($F) c.($C)##c.($C), probit)	///
					 if osa1 == 0
					  
	tebalance summarize
	// SD catastrophy. VR ok.
					  
	teffects overlap, ptlevel(1)


*------------------------------------------------------------------------------*
*	PART 1.4: Interacting all variables
*------------------------------------------------------------------------------*

*	ATE:
*	----	
	cap drop osa1 
	cap drop p1 	
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.($F)##c.($C) i.($F)#i.($F) c.($C)#c.($C), probit),	///
					  osample(osa1) generate(p1)
				   // violation of overlap assumption for 998 obs 	

	// Reestimate			   
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($F)##c.($C) i.($F)#i.($F) c.($C)#c.($C), probit)	///
					 if osa1 == 0

	tebalance summarize
	// SD catastrophy. VR too.
					  
	teffects overlap, ptlevel(1) 
	// Really bad overlap
	

/*	There is no way of getting good overlap with the complete model, TECH is 
	too good at explaining who gets the treatment. Redo this all with improved
	model (i.e. excluding TECH). 				*/
	
	
	
********************************************************************************
*					PART 2:	Improved Model (w/o EXP)
*******************************************************************************/

//	Setting global for interaction terms
	global I "logwages2015 TFP2015 logemp2015 DEBTS2015 RD2015"		
	// continuous variables w/o EXP

*------------------------------------------------------------------------------*
*	PART 2.1: No interactions
*------------------------------------------------------------------------------*	

*========*
* Logit
*========*	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 /*EXP2015*/ RD2015),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results/03a_PSM/overl_log_noEXP.gph, replace)
	graph export $results/03a_PSM/overl_log_noEXP.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

*========*
* Probit
*========*	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 /*EXP2015*/ RD2015, probit),	///
					  osample(osa1) generate(p1)

	 outreg2 using $results/test_1.tex, replace dec(3) addnote("This is a note")   
					  
	teffects overlap, ptlevel(1) saving($results/03a_PSM/overl_prob_noEXP.gph, replace)
	graph export $results/03a_PSM/overl_prob_noEXP.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.


	
	
	
	
*------------------------------------------------------------------------------*
*	PART 2.2: Interacting dummies
*------------------------------------------------------------------------------*	
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($F)##i.($F) $I, probit), ///
					  osample(osa1) generate(p1)

	outreg2 using $results/test_1.tex, append dec(3) 	
		 
	teffects overlap, ptlevel(1) saving($results/03a_PSM/overl_prob_noEXP#d.gph, replace)
	graph export $results/03a_PSM/overl_prob_noEXP#d.pdf, as(pdf) replace
	
	tebalance summarize
	// SD better for some, worse for others but all still below 10%. VR fine.

*------------------------------------------------------------------------------*
*	PART 2.3: Interacting continuous variables
*------------------------------------------------------------------------------*	

	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($F) c.($I)##c.($I), probit), ///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results/03a_PSM/overl_prob_noEXP#c.gph, replace)
	graph export $results/03a_PSM/overl_prob_noEXP#c.pdf, as(pdf) replace
	
	tebalance summarize
	// SD now worse (one above 10%). VR fine.

*------------------------------------------------------------------------------*
*	PART 2.4: Interacting all variables
*------------------------------------------------------------------------------*	

	cap drop osa1 
	cap drop p1 
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.($F)##c.($I) i.($F)#i.($F) c.($I)#c.($I), probit), ///
					  osample(osa1) generate(p1)
					  // Treatment overlap assumption violated by 61 obs
	
	// Reestimate				  
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($F)##c.($I) i.($F)#i.($F) c.($I)#c.($I), probit) ///
					  if osa1 == 0
	
	tebalance summarize
	// SD above 10% for some interactions. VR fine.
					  
	teffects overlap, ptlevel(1) saving($results/03a_PSM/overl_prob_noEXP#all.gph, replace)
	graph export $results/03a_PSM/overl_prob_noEXP#all.pdf, as(pdf) replace
	
	

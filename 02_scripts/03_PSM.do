/*******************************************************************************
								PSM DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 03a
		
		PURPOSE:	Perform Propensity Score Matching
		
		OUTLINE:	PART 1:	Complete Model
					PART 2: Improved Model (w/o TECH)
														
	
********************************************************************************
					PART 1:	Complete Model
*******************************************************************************/

//	Setting globals for interaction terms
	global F "OWN TECH PORT"	// Dummies with TECH
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"

*------------------------------------------------------------------------------*
*	PART 1.1: No interactions
*------------------------------------------------------------------------------*

*========*
* Logit
*========*

*	ATE:
*	----
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015),	///
					  osample(osa1) generate(p1)
	// Insignificant ATE			

	teffects overlap, ptlevel(1) saving($results\ATE\overl_log_comp1.gph, replace)
	graph export $results\overl_log_comp1.pdf, as(pdf) replace
	// Really bad overlap
	
	tebalance summarize
	// SD catastrophy. VR fine.
			  
					  
*========*
* Probit
*========*
*	ATE:
*	----	
	cap drop osa1 
	cap drop p1 	
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit),	///
					  osample(osa1) generate(p1)
				   // violation of overlap assumption for 389 obs 	

	// Reestimate			   
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit)	///
					  if osa1 == 0
					  
	tebalance summarize
	// SD catastrophy. VR fine.
					  
	teffects overlap, ptlevel(1) saving($results\ATE\overl_prob_comp1.gph, replace)
	graph export $results\ATT\overl_prob_comp1.pdf, as(pdf) replace
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
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.($F)##i.($F) $C, probit),	///
					  osample(osa1) generate(p1)
				   // violation of overlap assumption for 415 obs 	

	// Reestimate			   
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.($F)##i.($F) $C, probit)	///
					 if osa1 == 0
					  
	tebalance summarize
	// SD catastrophy. VR too.
					  
	teffects overlap, ptlevel(1)
	// Really bad overlap

*------------------------------------------------------------------------------*
*	PART 1.3: Interacting continuous variables
*------------------------------------------------------------------------------*

*	ATE:
*	----	
	cap drop osa1 
	cap drop p1 	
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.($F) c.($C)##c.($C), probit),	///
					  osample(osa1) generate(p1)
				   // violation of overlap assumption for 517 obs 	

	// Reestimate			   
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.($F) c.($C)##c.($C), probit)	///
					 if osa1 == 0
					  
	tebalance summarize
	// SD catastrophy. VR too.
					  
	teffects overlap, ptlevel(1)
	// Really bad overlap


*------------------------------------------------------------------------------*
*	PART 1.4: Interacting all variables
*------------------------------------------------------------------------------*

*	ATE:
*	----	
	cap drop osa1 
	cap drop p1 	
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.($F)##c.($C) i.($F)#i.($F) c.($C)#c.($C), probit),	///
					  osample(osa1) generate(p1)
				   // violation of overlap assumption for 998 obs 	

	// Reestimate			   
	teffects psmatch (logwages2017) ///
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
*					PART 2:	Improved Model (w/o TECH)
*******************************************************************************/

//	Setting global for interaction terms
	global D "OWN PORT"			// Dummies without TECH

*------------------------------------------------------------------------------*
*	PART 2.1: No interactions
*------------------------------------------------------------------------------*	

*========*
* Logit
*========*	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results\\overl_log_noTECH.gph, replace)
	graph export $results\overl_log_noTECH.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

*========*
* Probit
*========*	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results\overl_prob_noTECH.gph, replace)
	graph export $results\overl_prob_noTECH.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

	
*------------------------------------------------------------------------------*
*	PART 2.2: Interacting dummies
*------------------------------------------------------------------------------*	
* NOT DONE YET
























								


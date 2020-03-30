/*******************************************************************************
								NNM DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 03b
		
		PURPOSE:	Perform Nearest-Neighbour Matching
		
		OUTLINE:	PART 1:	NN
					PART 2:	5NN and Caliper
		
														
	
********************************************************************************
					PART 1:	NN
*******************************************************************************/




********************************************************************************
*					PART 2: 5NN and Caliper .05 [WAGES]
********************************************************************************

//	All specifications probit without TECH	

//	Setting globals for interaction terms
	global D "OWN PORT" /*TECH*/
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
		

*------------------------------------------------------------------------------*
*	PART 2.1: No interactions
*------------------------------------------------------------------------------*	
	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit),	///
					  nneighbor(5) caliper(.05) osample(osa1) generate(p1)
					  // 5 observations violate caliper
	
	// Reestimate
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit) if osa1==0,	///
					  nneighbor(5) caliper(.05)  generate(p1) 
	
	teffects overlap, ptlevel(1) saving($results\03b_NNM\WAGES_overl_nn5.gph, replace)
	graph export $results\03b_NNM\WAGES_overl_nn5.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

	
*------------------------------------------------------------------------------*
*	PART 2.2: Including interactions #dc
*------------------------------------------------------------------------------*	
	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
						 (FDI2016 i.($D)##c.($C), probit),	///
						  nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						  // 2 observation with pscore too low
	
	// Reestimate
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.($D)##c.($C), probit) if osa1==0,	///
					  nneighbor(5) caliper(.05) generate(p1) 

	teffects overlap, ptlevel(1) saving($results\03b_NNM\WAGES_overl_nn5#cd.gph, replace)
	graph export $results\03b_NNM\WAGES_overl_nn5#cd.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

	
	
********************************************************************************
*					PART 3: 5NN and Caliper .05 [TFP]
********************************************************************************

*------------------------------------------------------------------------------*
*	PART 2.2: No interactions 
*------------------------------------------------------------------------------*	
	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
						(FDI2016 i.OWN /*i.TECH*/ PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit),	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 5 observations violate caliper
	 
	// Reestimate
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit) if osa1==0,	///
					  nneighbor(5) caliper(.05)  generate(p1) 
	
	teffects overlap, ptlevel(1) saving($results\03b_NNM\TFP_overl_nn5.gph, replace)
	graph export $results\03b_NNM\TFP_overl_nn5.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

*------------------------------------------------------------------------------*
*	PART 3.2: Including interactions #dc
*------------------------------------------------------------------------------*	

	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
						(FDI2016 i.($D)##c.($C), probit),	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 2 observation with pscore too low
	
	//Reesimate 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($D)##c.($C), probit) if osa1==0,	///
					  nneighbor(5) caliper(.05) generate(p1) 

	teffects overlap, ptlevel(1) saving($results\03b_NNM\TFP_overl_nn5#cd.gph, replace)
	graph export $results\03b_NNM\TFP_overl_nn5#cd.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.	

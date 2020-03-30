/*******************************************************************************
								NNM DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 03b
		
		PURPOSE:	Perform Nearest Neighbour Matching
		
		OUTLINE:	PART 1:	
		
														
	
********************************************************************************
					PART 1:	??
*******************************************************************************/

*_________________________________Probit [wages] w/o TECH, using 5NN and Caliper
	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit),	///
					  nneighbor(5) caliper(.05) osample(osa1) generate(p1)
	 // 5 observations violate caliper
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit) if osa1==0,	///
					  nneighbor(5) caliper(.05)  generate(p1) 
	
	teffects overlap, ptlevel(1) saving($results\overl_WAGES_prob_noTECH_nn5.gph, replace)
	graph export $results\overl_WAGES_prob_noTECH_nn5.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.


*__________Probit [wages] w/o TECH including interactions, using 5NN and Caliper
	
	cap drop osa1 
	cap drop p1* 
	global D "OWN PORT" /*TECH*/
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.($D)##c.($C), probit),	///
					  nneighbor(5) caliper(.05) osample(osa1) generate(p1)
	// 2 observation with pscore too low
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.($D)##c.($C), probit) if osa1==0,	///
					  nneighbor(5) caliper(.05) generate(p1) 

	teffects overlap, ptlevel(1) saving($results\overl_WAGES_prob_noTECH_nn5_interact.gph, replace)
	graph export $results\overl_WAGES_prob_noTECH_nn5_interact.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

	
*___________________________________Probit [TFP] w/o TECH, using 5NN and Caliper
	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit),	///
					  nneighbor(5) caliper(.05) osample(osa1) generate(p1)
	 // 5 observations violate caliper
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit) if osa1==0,	///
					  nneighbor(5) caliper(.05)  generate(p1) 
	
	teffects overlap, ptlevel(1) saving($results\overl_TFP_prob_noTECH_nn5.gph, replace)
	graph export $results\overl_TFP_prob_noTECH_nn5.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.


*____________Probit [TFP] w/o TECH including interactions, using 5NN and Caliper
	
	cap drop osa1 
	cap drop p1* 
	global D "OWN PORT" /*TECH*/
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.($D)##c.($C), probit),	///
					  nneighbor(5) caliper(.05) osample(osa1) generate(p1)
	// 2 observation with pscore too low
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($D)##c.($C), probit) if osa1==0,	///
					  nneighbor(5) caliper(.05) generate(p1) 

	teffects overlap, ptlevel(1) saving($results\overl_TFP_prob_noTECH_nn5_interact.gph, replace)
	graph export $results\overl_TFP_prob_noTECH_nn5_interact.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.	

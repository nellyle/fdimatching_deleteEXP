/*******************************************************************************
						ROBUSTNESS CHECKS DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 04a
		
		PURPOSE:	Perform robustness checks
		
		OUTLINE:	PART 1:	Treatment effects for different TECH-levels
		
														
	
********************************************************************************
			PART 1:	Treatment effects for different TECH-levels
*******************************************************************************/



*------------------------------------------------------------------------------*
*	PART 2.3: Estimation on wages and TFP divided into TECH subsamples
*------------------------------------------------------------------------------*

// all models use probit and nneigghbor (3) and no interactions
// with nn5 and caliper .05 would need to drop too many variables
// in general not useful to divide into TECH subsamples
	
*_________________________Probit [wages] w/o TECH but dividing sample, using 3NN

** TECH==1	
	cap drop osa1 
	cap drop p1* 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit) if TECH==1,	///
					  nneighbor(3) osample(osa1) generate(p1)
	
	teffects overlap, ptlevel(1) saving($results\overl_WAGES_prob_TECH1.gph, replace)
	graph export $results\overl_WAGES_prob_TECH1.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

** TECH==2	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit) if TECH==2,	///
					  nneighbor(3) osample(osa1) generate(p1)
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit) if TECH==2 & osa1==0,	///
					  nneighbor(3) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results\overl_WAGES_prob_TECH2.gph, replace)
	graph export $results\overl_WAGES_prob_TECH2.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad
	
** TECH==3	
		cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit) if TECH==3,	///
					  nneighbor(3) osample(osa1) generate(p1)
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit) if TECH==3 & osa1==0,	///
					  nneighbor(3) generate(p1)

	
	teffects overlap, ptlevel(1) saving($results\overl_WAGES_prob_TECH3.gph, replace)
	graph export $results\overl_WAGES_prob_TECH3.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

** TECH==4
 	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit) if TECH==4,	///
					  nneighbor(3) osample(osa1) generate(p1)
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit) if TECH==4 & osa1==0,	///
					  nneighbor(3) generate(p1)

	
	teffects overlap, ptlevel(1) saving($results\overl_WAGES_prob_TECH4.gph, replace)
	graph export $results\overl_WAGES_prob_TECH4.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad
	
*__Probit [wages] w/o TECH but dividing sample including interactions, using 3NN
	
	cap drop osa1 
	cap drop p1* 
	global D "OWN PORT" /*TECH*/
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.($D)##c.($C), probit) if TECH==1,	///
					  nneighbor(3) osample(osa1) generate(p1)
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.($D)##c.($C), probit) if TECH==1 & osa1==0,	///
					  nneighbor(3) generate(p1)

					  
	teffects overlap, ptlevel(1) saving($results\overl_WAGES_prob_TECH1_interact.gph, replace)
	graph export $results\overl_WAGES_prob_TECH1_interact.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

	// no point in running interaction model with other subsamples 
	
*_________________________________Probit [TFP] w/o TECH, using 5NN and Caliper

** TECH==1	
	cap drop osa1 
	cap drop p1* 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit)if TECH==1,	///
					  nneighbor(3) osample(osa1) generate(p1)
		
	teffects overlap, ptlevel(1) saving($results\overl_TFP_prob_TECH1.gph, replace)
	graph export $results\overl_TFP_prob_TECH1.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

** TECH==2
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit)if TECH==2,	///
					  nneighbor(3) osample(osa1) generate(p1)
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit)if TECH==2 & osa1==0,	///
					  nneighbor(3) generate(p1)
		
	
	teffects overlap, ptlevel(1) saving($results\overl_TFP_prob_TECH2.gph, replace)
	graph export $results\overl_TFP_prob_TECH2.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

	
** TECH==3	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit)if TECH==3,	///
					  nneighbor(3) osample(osa1) generate(p1)
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit)if TECH==3 & osa1==0,	///
					  nneighbor(3) generate(p1)
		
	teffects overlap, ptlevel(1) saving($results\overl_TFP_prob_TECH3.gph, replace)
	graph export $results\overl_TFP_prob_TECH3.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

	
** TECH==4	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit)if TECH==4,	///
					  nneighbor(3) osample(osa1) generate(p1)
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit)if TECH==4 & osa1==0,	///
					  nneighbor(3) generate(p1)
		
	teffects overlap, ptlevel(1) saving($results\overl_TFP_prob_TECH4.gph, replace)
	graph export $results\overl_TFP_prob_TECH4.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad
	
	
	
*____Probit [TFP] w/o TECH but dividing sample including interactions, using 3NN
	
	cap drop osa1 
	cap drop p1* 
	global D "OWN PORT" /*TECH*/
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.($D)##c.($C), probit) if TECH==1,	///
					  nneighbor(3) osample(osa1) generate(p1)
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($D)##c.($C), probit) if TECH==1 & osa1==0,	///
					  nneighbor(3) generate(p1)

					  
	teffects overlap, ptlevel(1) saving($results\overl_TFP_prob_TECH1_interact.gph, replace)
	graph export $results\overl_TFP_prob_TECH1_interact.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

	// no point in running interaction model with other subsamples 
		


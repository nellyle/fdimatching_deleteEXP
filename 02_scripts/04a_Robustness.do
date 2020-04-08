/*******************************************************************************
						ROBUSTNESS CHECKS DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 04a
		
	PURPOSE:	Perform robustness checks
		
	OUTLINE:	PART 1:	Treatment effects for different TECH-levels (TFP)
				PART 2:	Treatment effects for different TECH-levels (wages)
				PART 3: T-test for differences in means
														
	
********************************************************************************
			PART 1:	Treatment effects for different TECH-levels (TFP)
*******************************************************************************/
/*		
		- All models use probit and nneigghbor (3) and no interactions
		- with nn5 and caliper .05 would need to drop too many variables
		--> in general not useful to divide into TECH subsamples			*/

*------------------------------------------------------------------------------*
*	PART 1.1: Probit w/o TECH, using 3NN
*------------------------------------------------------------------------------*

** TECH==1 (low)	
*----------
	cap drop osa1 
	cap drop p1* 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit)if TECH==1,	///
					  nneighbor(3) osample(osa1) generate(p1)
		
	teffects overlap, ptlevel(1) saving($results/04_Robustness/TFP_3NN_TECH1.gph, replace)
	graph export $results/04_Robustness/TFP_3NN_TECH1.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

** TECH==2 (medium-low)
*----------
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
		
	
	teffects overlap, ptlevel(1) saving($results/04_Robustness/TFP_3NN_TECH2.gph, replace)
	graph export $results/04_Robustness/TFP_3NN_TECH2.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

	
** TECH==3 (medium-high)
*----------	
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
		
	teffects overlap, ptlevel(1) saving($results/04_Robustness/TFP_3NN_TECH3.gph, replace)
	graph export $results/04_Robustness/TFP_3NN_TECH3.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

	
** TECH==4 (high)
*----------
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
		
	teffects overlap, ptlevel(1) saving($results/04_Robustness/TFP_3NN_TECH4.gph, replace)
	graph export $results/04_Robustness/TFP_3NN_TECH4.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad
	
	
*------------------------------------------------------------------------------*
*	PART 1.2: Probit w/o TECH including interactions, using 3NN
*------------------------------------------------------------------------------*
	
** TECH==1	
*----------
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

					  
	teffects overlap, ptlevel(1) saving($results/04_Robustness/TFP_3NN#dc_TECH1.gph, replace)
	graph export $results/04_Robustness/TFP_3NN#dc_TECH1.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

	// no point in running interaction model with other subsamples 

	
	
********************************************************************************
*			PART 2:	Treatment effects for different TECH-levels (wages)
*******************************************************************************/

*------------------------------------------------------------------------------*
*	PART 2.1: Probit w/o TECH, using 3NN
*------------------------------------------------------------------------------*

** TECH==1	
*----------
	cap drop osa1 
	cap drop p1* 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit) if TECH==1,	///
					  nneighbor(3) osample(osa1) generate(p1)

	teffects overlap, ptlevel(1) saving($results/04_Robustness/WAGES_3NN_TECH1.gph, replace)
	graph export $results/04_Robustness/WAGES_3NN_TECH1.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

** TECH==2
*----------	
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
					  
	teffects overlap, ptlevel(1) saving($results/04_Robustness/WAGES_3NN_TECH2.gph, replace)
	graph export $results/04_Robustness/WAGES_3NN_TECH2.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad
	
** TECH==3	
*----------
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

	
	teffects overlap, ptlevel(1) saving($results/04_Robustness/WAGES_3NN_TECH3.gph, replace)
	graph export $results/04_Robustness/WAGES_3NN_TECH3.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

** TECH==4
*----------
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

	
	teffects overlap, ptlevel(1) saving($results/04_Robustness/WAGES_3NN_TECH4.gph, replace)
	graph export $results/04_Robustness/WAGES_3NN_TECH4.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

	
*------------------------------------------------------------------------------*
*	PART 2.2: Probit w/o TECH including interactions, using 3NN
*------------------------------------------------------------------------------*
** TECH==1	
*----------
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

					  
	teffects overlap, ptlevel(1) saving($results/04_Robustness/WAGES_3NN#dc_TECH1.gph, replace)
	graph export $results/04_Robustness/WAGES_3NN#dc_TECH1.pdf, as(pdf) replace
	// bad overlap
	
	tebalance summarize
	// SD very bad

	// no point in running interaction model with other subsamples 


/********************************************************************************
			PART 3:	T-test for differences in means
*******************************************************************************/

/*ssc install psmatch2*/

psmatch2 FDI2016 (i.OWN PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015), outcome(TFP2017) logit ate
// same ATE like standard model (logit w/o TECH)

pstest, both
// 't-test for equality of means in the two samples' -> meaning H0: equality?
// some differences significantly different from 0 -> typical probelmatic variables: PORT, logemp2015, EXP2015
// bias: % difference of the sample means in the treated and non-treated (full or matched) sub-samples as a percentage of the square root of the average of the sample variances in the treated and non-treated groups
// pstest by default considers balancing for the ATT (Average Treatment Effect on the Treated)

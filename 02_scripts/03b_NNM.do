/*******************************************************************************
								NNM DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 03b
		
		PURPOSE:	Perform Nearest-Neighbour Matching
		
		OUTLINE:	PART 1:	NN: Wages and TFP
					PART 2:	5NN and Caliper: Wages
					PART 3: 5NN and Caliper; IPW; AIPW: TFP 
					PART 4: Output: Tables 1 & 2 
		
														
	
********************************************************************************
					PART 1:	NN, logit;
********************************************************************************
to Install Outreg run: ssc install outreg2, replace
to Install esttout run: ssc install estout, replace
*------------------------------------------------------------------------------*
*	PART 1.2: WAGES
*------------------------------------------------------------------------------*//
cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit),	///
					  osample(osa1) generate(p1)
	
	teffects overlap, ptlevel(1) saving($results/03b_NNM/WAGES_overl_nn1.gph, replace)
	graph export $results/WAGES_overl_nn1.pdf, as(pdf) replace
	
	
	
	// SD way below 10% for all variables. VR fine.

*------------------------------------------------------------------------------*
*	PART 1.3: TFP2015
*------------------------------------------------------------------------------*
cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit),	///
					  osample(osa1) generate(p1)			  
	
	teffects overlap, ptlevel(1) saving($results/03b_NNM/WAGES_overl_nn1.gph, replace)
	graph export $results/TFP_overl_nn1.pdf, as(pdf) replace
	tebalance summarize
	

	
	clear eststo 

********************************************************************************
*					PART 2: 5NN and Caliper .05 logit [WAGES]
********************************************************************************
//

//	All specifications logit without TECH	

//	Setting globals for interaction terms
	global D "OWN PORT" /*TECH*/
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
		

*------------------------------------------------------------------------------*
*	PART 2.1: No interactions
*------------------------------------------------------------------------------*	
	
	cap drop osa1 
	cap drop p1* 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit),	///
					  nneighbor(5) caliper(.05) osample(osa1) generate(p1)
					  // have fewer than 6 propensity-score matches within caliper .05
	
	// Reestimate
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit) if osa1==0,	///
					  nneighbor(5) caliper(.05)  generate(p1) 
	
	teffects overlap, ptlevel(1) saving($results/03b_NNM/WAGES_overl_nn5.gph, replace)
	graph export $results/EXP/WAGES_overl_nn5.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize

	// SD way below 10% for all variables. VR fine.

	
*------------------------------------------------------------------------------*
*	PART 2.2: Including interactions #dc
*------------------------------------------------------------------------------*	
	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
						 (FDI2016 i.($D)##c.($C), logit),	///
						  nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						  // 2 observation with pscore too low
	
	// Reestimate
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.($D)##c.($C), logit) if osa1==0,	///
					  nneighbor(5) caliper(.05) generate(p1) 

	teffects overlap, ptlevel(1) saving($results/03b_NNM/WAGES_overl_nn5#cd.gph, replace)
	graph export $results/EXP/WAGES_overl_nn5#cd.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

	
	
********************************************************************************
*					PART 3: 5NN and Caliper .05 logit [TFP]
********************************************************************************

*------------------------------------------------------------------------------*
*	PART 2.2: No interactions 
*------------------------------------------------------------------------------*	
*------------------------5NN and Caliper .05-----------------------------------*
// ATE	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
						(FDI2016 i.OWN /*i.TECH*/ PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit),	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 5 observations violate caliper
	 
	// Reestimate
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit) if osa1==0,	///
					  nneighbor(5) caliper(.05)  generate(p1) 
	
	teffects overlap, ptlevel(1) saving($results/03b_NNM/TFP_overl_nn5.gph, replace)
	graph export $results/EXP/TFP_overl_nn5.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

// ATET
cap drop osa1 
	cap drop p1* 
	teffects psmatch (TFP2017) ///
						(FDI2016 i.OWN /*i.TECH*/ PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit), atet	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 6  observations have fewer than 5 propensity-score matches within caliper .05
	 
	// Reestimate
	 teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit) if osa1==0, atet	///
					  nneighbor(5) caliper(.05)  generate(p1)
	
	
*------------------------IPW---------------------------------------------------*

// ATE
 cap drop osa1 
	cap drop p1* 
	eststo IPW: teffects ipw (TFP2017) ///
						(FDI2016 i.OWN /*i.TECH*/ PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit),	///
						 osample(osa1) 
teffects overlap, ptlevel(1) saving($results/03b_NNM/TFP_overl_ipw.gph, replace)
	graph export $results/03b_NNM/TFP_overl_ipw.pdf, as(pdf) replace
	
	tebalance summarize						

// ATET
cap drop osa1 
	cap drop p1* 
	eststo IPWATET: teffects ipw (TFP2017) ///
						(FDI2016 i.OWN /*i.TECH*/ PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit), atet	///
						 osample(osa1) 
teffects overlap, ptlevel(1) saving($results/03b_NNM/TFP_overl_ipw.gph, replace)
	graph export $results/03b_NNM/TFP_overl_ipw.pdf, as(pdf) replace
	
	tebalance summarize						

*------------------------AIWP---------------------------------------------------*
cap drop osa1
	eststo AIWP: teffects aipw (TFP2017 logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OW i.TECH)(FDI2016 logemp2015 	  logwages2015 TFP2015 EXP2015 i.PORT i.OWN i.TECH), osample(osa1)

teffects overlap, ptlevel(1) saving($results/03b_NNM/TFP_overl_aipw.gph, replace)
	graph export $results/03b_NNM/TFP_overl_aipw.pdf, as(pdf) replace
    
	tebalance summarize
	
*------------------------------------------------------------------------------*
*	PART 3.2: Including interactions #dc
*------------------------------------------------------------------------------*	

	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
						(FDI2016 i.($D)##c.($C), logit),	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 2 observation with pscore too low
	
	//Reesimate 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($D)##c.($C), logit) if osa1==0,	///
					  nneighbor(5) caliper(.05) generate(p1) 

	teffects overlap, ptlevel(1) saving($results/03b_NNM/TFP_overl_nn5#cd.gph, replace)
	graph export $results/03b_NNM/TFP_overl_nn5#cd.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.	

*------------------------------------------------------------------------------*
*	PART4: Output: including EXP, excluding TECH 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*	Table 1/2: NN1.(wages, TFP) NN5cal (TFP, wages)
*------------------------------------------------------------------------------*
//TME1: displays the coefficients for the logit treatment model; euqation from treatment effect
//OME0 and OME1 represent the linear regression coefficients for the untreated and treated potential-outcome equations, respectively


generate EMPL=exp(logemp2015)

*------------------------------------WAGES-------------------------------------*
	//NN1
		// ATE
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit),	///
					  osample(osa1) generate(p1)	  
					  
	outreg2 using $results/03b_NNM/Table1.1_wages.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015) nocon eqdrop(TME1) 
	
		// ATET
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
						(FDI2016 i.OWN /*i.TECH*/ PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit), atet	///
						 osample(osa1) generate(p1)

	outreg2 using $results/03b_NNM/Table1.1_wages.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015) nocon eqdrop(TME1)
					  
	// NN5 caliper0.05: 
		// ATE
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
						(FDI2016 i.OWN /*i.TECH*/ PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit),	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 6 observations violate caliper

	// Reestimate
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit) if osa1==0,	///
					  nneighbor(5) caliper(.05)  generate(p1) 
					  
	outreg2 using $results/03b_NNM/Table1.1_wages.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015) nocon eqdrop(TME1) 
		
		//ATET
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
						(FDI2016 i.OWN /*i.TECH*/ PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit), atet	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 6  observations have fewer than 5 propensity-score matches within caliper .05
	 
	// Reestimate
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit) if osa1==0, atet	///
					  nneighbor(5) caliper(.05)  generate(p1)
	outreg2 using $results/03b_NNM/Table1.1_wages.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015) nocon eqdrop(TME1) 

	
*------------------------------------TFP---------------------------------------*
generate EMPL=exp(logemp2015)	
	
	//NN1
		//ATE
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit),	///
					  osample(osa1) generate(p1)	
	
	outreg2 using $results/03b_NNM/Table1.2_TFP.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015) nocon eqdrop(TME1) 
	
		// ATET
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
						(FDI2016 i.OWN /*i.TECH*/ PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit), atet	///
						osample(osa1) generate(p1)

	outreg2 using $results/03b_NNM/Table1.2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015) nocon eqdrop(TME1) 

	//NN5 caliper 0.05
		// ATE	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
						(FDI2016 i.OWN /*i.TECH*/ PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit),	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 5 observations violate caliper
	 
	// Reestimate
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit) if osa1==0,	///
					  nneighbor(5) caliper(.05)  generate(p1) 
					  
	outreg2 using $results/03b_NNM/Table1.2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015) nocon eqdrop(TME1) 
	
		// ATET
cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
						(FDI2016 i.OWN /*i.TECH*/ PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit), atet	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 6  observations have fewer than 5 propensity-score matches within caliper .05
	 
	// Reestimate
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit) if osa1==0, atet	///
					  nneighbor(5) caliper(.05)  generate(p1)
	outreg2 using $results/03b_NNM/Table1.2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015) nocon eqdrop(TME1) 
	
*------------------------------------------------------------------------------*
*	Table 2: IPW, AIPW (TFP)
*------------------------------------------------------------------------------* 
//IWP:

	//ATE
cap drop osa1
	teffects ipw (TFP2017) (FDI2016 i.OWN /*i.TECH*/ PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015),  	osample(osa1) 
	outreg2 using $results/03b_NNM/Table2_TFP.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015) nocon eqdrop(TME1) 
	
	//ATET
	cap drop osa1	
teffects ipw (TFP2017) ///
						(FDI2016 i.OWN /*i.TECH*/ PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, logit), atet	///
						 osample(osa1) 	
	outreg2 using $results/03b_NNM/Table2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015) nocon eqdrop(TME1) 

//AIWP
	cap drop osa1
teffects aipw (TFP2017 logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OW i.TECH)(FDI2016 logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OWN i.TECH)

	outreg2 using $results/03b_NNM/Table2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015) nocon  eqdrop(OME0 OME1 TME1)

	
	
*------------------------------------------------------------------------------*
*	PART4: Output -  excl. EXPORT, incl. TECH
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*	Table 1/2: NN1.(wages, TFP) NN5cal (TFP, wages)
*------------------------------------------------------------------------------*
//TME1: displays the coefficients for the logit treatment model; euqation from treatment effect
//OME0 and OME1 represent the linear regression coefficients for the untreated and treated potential-outcome equations, respectively


*------------------------------------WAGES-------------------------------------*
	//NN1
		// ATE
	cap drop osa1 
	cap drop p1* 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015, logit),	///
					  osample(osa1) generate(p1)	  
					  
	outreg2 using $results/EXP/Table1.1_wages.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 
	
		// ATET
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
						(FDI2016 i.OWN i.PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015, logit), atet	///
						 osample(osa1) generate(p1)

	outreg2 using $results/EXP/Table1.1_wages.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1)
					  
	// NN5 caliper0.05: 
		// ATE
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
						(FDI2016 i.OWN i.PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015, logit),	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 6 observations violate caliper

	// Reestimate
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015, logit) if osa1==0,	///
					  nneighbor(5) caliper(.05)  generate(p1) 
					  
	outreg2 using $results/EXP/Table1.1_wages.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 
		
		//ATET
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (logwages2017) ///
						(FDI2016 i.OWN i.PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015, logit), atet	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 6  observations have fewer than 5 propensity-score matches within caliper .05
	 
	// Reestimate
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015, logit) if osa1==0, atet	///
					  nneighbor(5) caliper(.05)  generate(p1)
	outreg2 using $results/EXP/Table1.1_wages.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 

	
*------------------------------------TFP---------------------------------------*
	//NN1
		//ATE
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015, logit),	///
					  osample(osa1) generate(p1)	
	
	outreg2 using $results/EXP/Table1.2_TFP.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 
	
		// ATET
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
						(FDI2016 i.OWN i.PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015, logit), atet	///
						osample(osa1) generate(p1)

	outreg2 using $results/EXP/Table1.2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 

	//NN5 caliper 0.05
		// ATE	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
						(FDI2016 i.OWN PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015, logit),	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 5 observations violate caliper
	 
	// Reestimate
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015, logit) if osa1==0,	///
					  nneighbor(5) caliper(.05)  generate(p1) 
					  
	outreg2 using $results/EXP/Table1.2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 
	
		// ATET
cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
						(FDI2016 i.OWN i.PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015, logit), atet	///
						nneighbor(5) caliper(.05) osample(osa1) generate(p1)
						// 6  observations have fewer than 5 propensity-score matches within caliper .05
	 
	// Reestimate
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015, logit) if osa1==0, atet	///
					  nneighbor(5) caliper(.05)  generate(p1)
	outreg2 using $results/EXP/Table1.2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 
	
*------------------------------------------------------------------------------*
*	Table 2: IPW, AIPW (TFP)
*------------------------------------------------------------------------------* 
//IWP:

	//ATE
cap drop osa1
	teffects ipw (TFP2017) (FDI2016 i.OWN i.PORT logwages2015 TFP2015 EMPL DEBTS2015 i.TECH RD2015),  	
	osample(osa1) 
	
	outreg2 using $results/EXP/Table2_TFP.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 
	
	//ATET
	cap drop osa1	
teffects ipw (TFP2017) ///
						(FDI2016 i.OWN i.PORT ///
						logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015, logit), atet	///
						 osample(osa1) 	
	outreg2 using $results/EXP/Table2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015) nocon eqdrop(TME1) 

//AIWP
	cap drop osa1
teffects aipw (TFP2017 logemp2015 logwages2015 TFP2015 i.TECH i.PORT i.OW i.TECH)(FDI2016 logemp2015 logwages2015 TFP2015 i.TECH i.PORT i.OWN i.TECH)

	outreg2 using $results/EXP/Table2_TFP.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 i.TECH RD2015) nocon  eqdrop(OME0 OME1 TME1)
	

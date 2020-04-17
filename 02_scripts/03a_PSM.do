/*******************************************************************************
								PSM DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 03a
		
		PURPOSE:	Perform Propensity Score Matching
					Effect of FDI on TFP
		
		OUTLINE:	PART 1:	Complete Model
					PART 2: Improved Model (w/o TECH)
					PART 3: Figure Overlap w/ and w/o TECH
					PART 4: Figure Overlap w/ and w/o EXP2015
														
	
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

	
global F "OWN TECH"	
global C "logwages2015 TFP2015 emp2015 DEBTS2015 RD2015"	
	
	
*TESTTESTTEST*	
generate EXP3=EXP2015^3
generate EXP2=EXP2015^2
generate emp2015=exp(logemp2015)
generate wagesemp=logwages2015*emp2015
generate tfpemp=TFP2015*emp2015
generate logtfpemp=TFP2015*logemp2015
	global F "OWN TECH"	
	global C "logwages2015 TFP2015 emp2015 DEBTS2015 EXP3 RD2015"


*	ATE:
*	----
*------------------------------------------------------------------------------*
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH ///
					  logwages2015 TFP2015 emp2015 EXP3 DEBTS2015 RD2015) if TECH!=4,	///
					  osample(osa1) generate(p1)
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH ///
					  logwages2015 TFP2015 emp2015 EXP3 DEBTS2015 RD2015) if TECH!=4 & osa1==0,	///
					  generate(p1)				  		

	teffects overlap, ptlevel(1) 
	
	tebalance summarize
	// good balance! 	
*------------------------------------------------------------------------------*	
	
	generate RDTECH=TECH*RD2015
	generate TFPEXP=TFP2015*EXP2015
	generate EXP3=EXP2015^3
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH ///
					  logwages2015 TFP2015 emp2015 EXP3 DEBTS2015 RD2015 RDTECH),	///
					  nneighbor(5) caliper(.05) osample(osa1) generate(p1)
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH ///
					  logwages2015 TFP2015 emp2015 EXP3 DEBTS2015 RD2015 RDTECH) if osa1==0,	///
					 nneighbor(5) caliper(.05) generate(p1)				  		

	teffects overlap, ptlevel(1) 
	
	tebalance summarize

	
	
	cap drop osa1 
	cap drop p1 
	cap teffects ipw (TFP2017) ///
					 (FDI2016 i.OWN i.TECH ///
					  logwages2015 TFP2015 emp2015 EXP3 DEBTS2015 RD2015 RDTECH),	///
					  osample(osa1)
	teffects ipw (TFP2017) ///
					 (FDI2016 i.OWN i.TECH ///
					  logwages2015 TFP2015 emp2015 EXP3 DEBTS2015 RD2015 RDTECH) if osa1==0				  		

	teffects overlap, ptlevel(1) 
	
	tebalance summarize

	
	
	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.($F)##c.($C)),	///
					  osample(osa1) generate(p1)
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($F)##c.($C)) if osa1==0,	///
					 generate(p1)
	
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
	

*------------------------------------------------------------------------------*
*	PART 1.5: Cubic exports, interacting problematic variables - Possible solution?
*------------------------------------------------------------------------------*	
	
	generate EXP3=EXP2015^3
	generate emp2015=exp(logemp2015)
	generate PORTEXP=PORT*EXP2015
	generate TECHEXP=TECH*EXP2015
	generate TECHPORT=TECH*PORT
	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN TECHEXP TECHPORT PORTEXP PORT ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 EXP3 RD2015), 	///
					  osample(osa1) generate(p1)
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN TECHEXP TECHPORT PORTEXP PORT ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 EXP3 RD2015) if osa1==0, 	///
					  generate(p1)	
					  
	teffects overlap, ptlevel(1) saving($results/03a_PSM/overl_log_cubic.gph, replace)
	graph export $results/03a_PSM/overl_log_cubic.pdf, as(pdf) replace
	// overlap not great, but better
	
	tebalance summarize
	// SD okay
	
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

	drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results/03a_PSM/overl_log_noTECH.gph, replace)
	graph export $results/03a_PSM/overl_log_noTECH.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

*========*
* Probit
*========*	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit),	///
					  osample(osa1) generate(p1)

	 outreg2 using $results\test_1.tex, replace dec(3) addnote("This is a note")   
					  
	teffects overlap, ptlevel(1) saving($results/03a_PSM/overl_prob_noTECH.gph, replace)
	graph export $results/03a_PSM/overl_prob_noTECH.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

	
	
*------------------------------------------------------------------------------*
*	PART 2.2: Interacting dummies
*------------------------------------------------------------------------------*	
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($D)##i.($D) $C, probit), ///
					  osample(osa1) generate(p1)

	outreg2 using $results\test_1.tex, append dec(3) 	
		 
	teffects overlap, ptlevel(1) saving($results/03a_PSM/overl_prob_noTECH#d.gph, replace)
	graph export $results/03a_PSM/overl_prob_noTECH#d.pdf, as(pdf) replace
	
	tebalance summarize
	// SD better for some, worse for others but all still below 10%. VR fine.

*------------------------------------------------------------------------------*
*	PART 2.3: Interacting continuous variables
*------------------------------------------------------------------------------*	

	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($D) c.($C)##c.($C), probit), ///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results/03a_PSM/overl_prob_noTECH#c.gph, replace)
	graph export $results/03a_PSM/overl_prob_noTECH#c.pdf, as(pdf) replace
	
	tebalance summarize
	// SD now worse (one above 10%). VR fine.

*------------------------------------------------------------------------------*
*	PART 2.4: Interacting all variables
*------------------------------------------------------------------------------*	

	cap drop osa1 
	cap drop p1 
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.($D)##c.($C) i.($D)#i.($D) c.($C)#c.($C), probit), ///
					  osample(osa1) generate(p1)
					  // Treatment overlap assumption violated by 1 obs
	
	// Reestimate				  
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($D)##c.($C) i.($D)#i.($D) c.($C)#c.($C), probit) ///
					  if osa1 == 0
	
	tebalance summarize
	// SD above 10% for some interactions. VR fine.
					  
	teffects overlap, ptlevel(1) saving($results/03a_PSM/overl_prob_noTECH#all.gph, replace)
	graph export $results/03a_PSM/overl_prob_noTECH#all.pdf, as(pdf) replace


/*******************************************************************************
					PART 3: Figure Overlap w/ and w/o TECH
*******************************************************************************/

*------------------------------------------------------------------------------*
*	PART 3.1: Full model vs w/o TECH
*------------------------------------------------------------------------------*

// Using graphs of the two models above (NN1, logit)

*========*
* W/ TECH
*========*
	
	cap drop osa1 
	cap drop p1 	
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015),	///
					  osample(osa1) generate(p1)		   
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015)	///
					  if osa1 == 0				  		  
	teffects overlap, ptlevel(1) xtitle("Propensity Score") ytitle("Density") title("Including Technology") legend(label(1 "No FDI") label(2 "FDI")) graphregion(fcolor(white)) graphregion(lcolor(white)) saving($results/03a_PSM/overl_prob_comp1.gph, replace)
	graph export $results/03a_PSM/overl_prob_comp1.pdf, as(pdf) replace

*========*
* W/O TECH
*========*
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015),	///
					  osample(osa1) generate(p1)  
	teffects overlap, ptlevel(1) xtitle("Propensity Score") ytitle("Density") title("Excluding Technology") legend(label(1 "No FDI") label(2 "FDI")) graphregion(fcolor(white)) graphregion(lcolor(white)) saving($results/03a_PSM/overl_prob_noTECH.gph, replace)
	graph export $results/03a_PSM/overl_prob_noTECH.pdf, as(pdf) replace

*========*
* COMBINE
*========*
	
	
gr combine $results/03a_PSM/overl_prob_comp1.gph $results/03a_PSM/overl_prob_noTECH.gph, xsize(9) ysize(4.5) /*title("FIGURE 1 - Propensity Score Overlap")*/ graphregion(fcolor(white)) saving($results/03a_PSM/overl_figure1_TECHvsnoTECH.gph, replace)
	graph export $results/03a_PSM/overl_figure1_TECHvsnoTECH.pdf, as(pdf) replace

*------------------------------------------------------------------------------*
*	PART 3.2: Model w/o TECH vs w/o TECH including interactions
*------------------------------------------------------------------------------*

// Using graphs of the two models above (NN1, logit)

*========*
* W/O TECH
*========*
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015),	///
					  osample(osa1) generate(p1)  
	teffects overlap, ptlevel(1) xtitle("Propensity Score") ytitle("Density") title("Without Interaction Terms") legend(label(1 "No FDI") label(2 "FDI")) graphregion(fcolor(white)) graphregion(lcolor(white)) saving($results/03a_PSM/overl_prob_noTECH.gph, replace)
	graph export $results/03a_PSM/overl_prob_noTECH.pdf, as(pdf) replace


*============*
* INTERACTIONS
*============*
	
	cap global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	cap global D "OWN PORT"			// Dummies without TECH
	cap drop osa1 
	cap drop p1 
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.($D)##c.($C) i.($D)#i.($D) c.($C)#c.($C), probit), ///
					  osample(osa1) generate(p1)			  
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.($D)##c.($C) i.($D)#i.($D) c.($C)#c.($C), probit) ///
					  if osa1 == 0
	tebalance summarize		  
	teffects overlap, ptlevel(1) xtitle("Propensity Score") ytitle("Density") title("Including Interaction Terms") legend(label(1 "No FDI") label(2 "FDI")) graphregion(fcolor(white)) graphregion(lcolor(white)) saving($results/03a_PSM/overl_prob_noTECH#all.gph, replace)
	graph export $results/03a_PSM/overl_prob_noTECH#all.pdf, as(pdf) replace
		
	
*========*
* COMBINE
*========*
	
	
gr combine $results/03a_PSM/overl_prob_noTECH.gph $results/03a_PSM/overl_prob_noTECH#all.gph, xsize(9) ysize(4.5) /*title("FIGURE 1 - Propensity Score Overlap with interactions")*/ graphregion(fcolor(white)) saving($results/03a_PSM/overl_figure1_TECHvsnoTECH_interactions.gph, replace)
	graph export $results/03a_PSM/overl_figure1_TECHvsnoTECH_interactions.pdf, as(pdf) replace
	
	

	
	
/*******************************************************************************
					PART 4: Figure Overlap w/ and w/o EXP2015
*******************************************************************************/

*------------------------------------------------------------------------------*
*	PART 3.1: Full model vs w/o EXP2015
*------------------------------------------------------------------------------*

// Using graphs of the two models above (NN1, logit)

cap generate emp2015=exp(logemp2015)

*========*
* W/ TECH
*========*
	
	cap drop osa1 
	cap drop p1 	
	cap teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 EXP2015 RD2015),	///
					  osample(osa1) generate(p1)		   
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015)	///
					  if osa1 == 0				  		  
	teffects overlap, ptlevel(1) xtitle("Propensity Score") ytitle("Density") title("Including Exports") legend(label(1 "No FDI") label(2 "FDI")) graphregion(fcolor(white)) graphregion(lcolor(white)) saving($results/03a_PSM/overl_prob_comp1.gph, replace)
	graph export $results/03a_PSM/overl_prob_comp1.pdf, as(pdf) replace

*========*
* W/O TECH
*========*
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 /*EXP2015*/ RD2015),	///
					  osample(osa1) generate(p1)  
	teffects overlap, ptlevel(1) xtitle("Propensity Score") ytitle("Density") title("Excluding Exports") legend(label(1 "No FDI") label(2 "FDI")) graphregion(fcolor(white)) graphregion(lcolor(white)) saving($results/03a_PSM/overl_prob_noEXP.gph, replace)
	graph export $results/03a_PSM/overl_prob_noEXP.pdf, as(pdf) replace

*========*
* COMBINE
*========*
	
	
gr combine $results/03a_PSM/overl_prob_comp1.gph $results/03a_PSM/overl_prob_noEXP.gph, xsize(9) ysize(4.5) /*title("FIGURE 1 - Propensity Score Overlap")*/ graphregion(fcolor(white)) saving($results/03a_PSM/overl_figure1_EXPvsnoEXP.gph, replace)
	graph export $results/03a_PSM/overl_figure1_EXPvsnoEXP.pdf, as(pdf) replace


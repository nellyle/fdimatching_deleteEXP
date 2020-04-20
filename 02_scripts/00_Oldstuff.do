/***SAVING OLD STUFF:
		
		PART 1: Test for Overlap of pscore (Emilie)
		PART 2: PSM tests with logit and probit (Georg)
		PART 3: PSM balance checks after dropping different variables (emilie)
		PART 4: All the rest from PSM we probably won't need (everyone)
		PART 5: Old robustness checks

********************************************************************************
					PART 1: Test for Overlap
*******************************************************************************/

//	Check OLS regression (Test with complete model)
	reg logwages2017 FDI2016 i.OWN i.TECH PORT ///
	logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015

*------------------------------------------------------------------------------*
*	PART 1.1: Propensity Score and Kdensity Plots
*------------------------------------------------------------------------------*
// NOT SURE WE NEED THIS	
	
//	Test overlap with all covariates (logit)
	logit 	FDI2016 i.OWN i.TECH PORT 		///
			logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015
			// Pseudo R² of  0.5652
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	
/*	--> Terrible overlap
	Note: All variables except logwages2015 have a significant influence on 
	treatment status			*/
		
//	Test overlap with all covariates (probit)
	drop pscore
	probit 	FDI2016 i.OWN i.TECH PORT ///
			logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015
			// slight increase in Pseudo R² (= 0.5700)
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	
/*	--> Similarly terrible overlap
	Note: As in the logit model, logwages2015 is the only variable with an
	insignifcant coefficient.			*/

	
/*	Attempt to improve overlap by including square terms (logit)
	--> squaring dummies			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	logit FDI2016 i.($D)##i.($D) $C 
	// Pseudo R² = 0.5669
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	
//	--> Somewhat better overlap but far from good	

/*	Attempt to improve overlap by including square terms (probit)
	--> squaring dummies			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	probit FDI2016 i.($D)##i.($D) $C 
	// Pseudo R² = 0.5718
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	

/*	Attempt to improve overlap by including square terms (logit)
	--> squaring continuous variables			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	logit FDI2016 c.($C)##c.($C) $D
	// Decrease in Pseudo R² (=0.5337)
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	

/*	Attempt to improve overlap by including square terms (probit)
	--> squaring continuous variables			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	probit FDI2016 c.($C)##c.($C) $D
	// Pseudo R² =0.5378
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")
	
/*	Attempt to improve overlap by including square terms (logit)
	--> squaring dummies with continuous variables			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	logit FDI2016 $D $C i.($D)#c.($C)
	// Pseudo R² =  0.5814 --> highest so far
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	

/*	Attempt to improve overlap by including square terms (probit)
	--> squaring dummies with continuous variables			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	probit FDI2016 $D $C i.($D)#c.($C)
	// Pseudo R² = 0.5859 
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")
	
/*	Attempt to improve overlap by including square terms (logit)
	(squaring all variables)			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	logit FDI2016 i.($D)##i.($D) c.($C)##c.($C) i.($D)#c.($C)
	// Pseudo R² = 0.5942 
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	

/*	Attempt to improve overlap by including square terms (probit)
	(squaring all variables)			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	probit FDI2016 i.($D)##i.($D) c.($C)##c.($C) i.($D)#c.($C)
	// Pseudo R²  0.5986 --> highest so far
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")
	
/*	Note: 
	1) Non of the models yields satifying overlap. Check if there are varibales
	which perfectly predict treatment status
	2) probit models consistently yield higher R² than logit models for our data
	--> Preference for probit models?
	3) logwages2015 remains insignificant throughout all specifications. 
	When including higher order terms, TFP2015, DEBTS2015 and RD2015 also become
	insignificant. 						*/

* --> Continue narrowing down the model based on descriptive analysis? 


*------------------------------------------------------------------------------*
*	PART 1.2: Covariate Balancing Tests
*------------------------------------------------------------------------------*

// Frequency distribution of treated and control units across the strata

// Divide into quintiles
// Has to be after actual logit estimation determining pscore 
xtile strata=pscore, n(5)
save FDI_project_working, replace

// Replicating table on slide 23 
summarize pscore FDI2016 if strata==1
summarize pscore FDI2016 if strata==1 & FDI2016==0
summarize pscore FDI2016 if strata==1 & FDI2016==1
summarize pscore FDI2016 if strata==2
summarize pscore FDI2016 if strata==2 & FDI2016==0
summarize pscore FDI2016 if strata==2 & FDI2016==1
summarize pscore FDI2016 if strata==3
summarize pscore FDI2016 if strata==3 & FDI2016==0
summarize pscore FDI2016 if strata==3 & FDI2016==1
summarize pscore FDI2016 if strata==4
summarize pscore FDI2016 if strata==4 & FDI2016==0
summarize pscore FDI2016 if strata==4 & FDI2016==1
summarize pscore FDI2016 if strata==5
summarize pscore FDI2016 if strata==5 & FDI2016==0
summarize pscore FDI2016 if strata==5 & FDI2016==1


********************************************************************************
* PART 2: PSM tests with logit and probit
*******************************************************************************/

global S " OWN TECH PORT"
global P " logemp2015 DEBTS2015 EXP2015 RD2015 logwages2015"


*smol model
 cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
*keep wages to controll for pre*
teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015  i.PORT i.OWN),  osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize

*big model


 cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
teffects psmatch (logwages2017) (FDI2016  i.TECH i.PORT logemp2015 DEBTS2015 EXP2015 RD2015 logwages2015),  osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize

	
*------------------------------------------------------------------------------*
*	PART 2.2: Estimation using psmatching with probit estimator
*------------------------------------------------------------------------------*

cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN, probit), osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize	
			
cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 c.EXP2015##c.EXP2015 i.PORT i.OWN, probit), osample(osa2) generate(p2)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize			
			
generate logexp2015 = log(EXP2015)

cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
cap teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN, probit), osample(osa3) generate(p3)
teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN, probit) if osa3==0, generate (p3) 
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize		


********************************************************************************
* PART 3: PSM balance checks after dropping different variables
*******************************************************************************/
*------------------------------------------------------------------------------*
*	PART 3.1: Estimation using psmatching with logit model
*------------------------------------------------------------------------------*

*_________________________________________Deleting problematic variable: EXP2015
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 /*EXP2015*/ RD2015),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results/overl_log_noEXP.gph, replace)
	graph export $results/overl_log_noEXP.pdf, as(pdf) replace
	// Ok overlap except left-hand tail.
	
	tebalance summarize
	// SD still above 20% for TECH. VR fine.

*_______________________________Deleting problematic variables: TECH and EXP2015
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 /*EXP2015*/ RD2015),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results/overl_log_noTECHEXP.gph, replace)
	graph export $results/overl_log_noTECHEXP.pdf, as(pdf) replace
	// Ok overlap except left-hand tail.
	
	tebalance summarize
	// SD and VR fine.
	
*____________________________Deleting problematic variables: TECH and logemp2015
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 /*logemp2015*/ DEBTS2015 EXP2015 RD2015),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results/overl_log_noTECHemp.gph, replace)
	graph export $results/overl_log_noTECHemp.pdf, as(pdf) replace
	// Ok overlap, but tails still not so good.
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.
	
*___________________Deleting problematic variables: TECH, EXP2015 and logemp2015
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 /*logemp2015*/ DEBTS2015 /*EXP2015*/ RD2015),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results/overl_log_noTECHEXPemp.gph, replace)
	graph export $results/overl_log_noTECHEXPemp.pdf, as(pdf) replace
	// Very good overlap.
	
	tebalance summarize
	// SD very good, VR also fine.	

*------------------------------------------------------------------------------*
*	PART 3.2: Estimation using psmatching with probit model
*------------------------------------------------------------------------------*

*_________________________________________________________________Complete model
	
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
					  
	teffects overlap, ptlevel(1) saving($results/overl_prob_comp1.gph, replace)
	graph export $results/overl_prob_comp1.pdf, as(pdf) replace
	// Catastrophic overlap

	
*____________________________________________Deleting problematic variable: TECH
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results/overl_prob_noTECH.gph, replace)
	graph export $results/overl_prob_noTECH.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

	
*_________________________________________Deleting problematic variable: EXP2015

	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 /*EXP2015*/ RD2015, probit),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results/overl_prob_noEXP.gph, replace)
	graph export $results/overl_prob_noEXP.pdf, as(pdf) replace
	// Ok overlap except left-hand tail.
	
	tebalance summarize
	// SD not great, some above 10% but none above 20%. VR fine.
	


*_______________________________Deleting problematic variables: TECH and EXP2015
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 /*EXP2015*/ RD2015, probit),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results/overl_prob_noTECHEXP.gph, replace)
	graph export $results/overl_prob_noTECHEXP.pdf, as(pdf) replace
	// Ok overlap except left-hand tail.
	
	tebalance summarize
	// SD and VR fine.
	
*____________________________Deleting problematic variables: TECH and logemp2015
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 /*logemp2015*/ DEBTS2015 EXP2015 RD2015, probit),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results/overl_prob_noTECHemp.gph, replace)
	graph export $results/overl_prob_noTECHemp.pdf, as(pdf) replace
	// Ok overlap, but tails still not so good.
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

	
*___________________Deleting problematic variables: TECH, EXP2015 and logemp2015
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 /*logemp2015*/ DEBTS2015 /*EXP2015*/ RD2015, probit),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results/overl_prob_noTECHEXPemp.gph, replace)
	graph export $results/overl_prob_noTECHEXPemp.pdf, as(pdf) replace
	// Very good overlap, left-hand tail still not perfect but acceptable.
	
	tebalance summarize
	// SD very good, VR also fine.			

	
*==============================================================================*
*		PART 4: All the rest from PSM we probably won't need 
*==============================================================================*
// BELOW HERE NOT IN ORDER not sure we need models below - partly same as before 
	
cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN, probit), osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize	
			
cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 c.EXP2015##c.EXP2015 i.PORT i.OWN, probit), osample(osa2) generate(p2)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize			
			
generate logexp2015 = log(EXP2015)

cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
cap teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN, probit), osample(osa3) generate(p3)
teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN, probit) if osa3==0, generate (p3) 
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize				
			
*Interactions for better pscores*			
			
cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
teffects psmatch (logwages2017) (FDI2016   c.($P)#i.($S) ) if osa1=0 ,  osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize
			
cap teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN, probit), osample(osa3) generate(p3)
teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN, probit) if osa3==0, generate (p3) 
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize				
			
*Interactions for better pscores*			
		
cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
teffects psmatch (logwages2017) (FDI2016   c.($P)#i.($S)#i.($S) ) if OWN!=4,  osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize
				

				
				
				
*constructing pscores
cap drop pscore
logit FDI2016  i.($S)##c.($P) c.($P)##c.($P)
predict pscore			
twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
legend(order(1 "control" 2 "treated")) xtitle("prop. score")			


cap drop pscore
logit FDI2016  i.OWN##i.TECH i.PORT i.TECH c.EXP2015 c.logemp2015  DEBTS2015	RD2015
predict pscore			
twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
legend(order(1 "control" 2 "treated")) xtitle("prop. score")			


cap drop pscore
logit FDI2016  i.OWN i.TECH i.PORT i.TECH c.EXP2015 c.logemp2015##c.logemp2015  c.DEBTS2015##c.DEBTS2015	RD2015
predict pscore			
twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
legend(order(1 "control" 2 "treated")) xtitle("prop. score")			




*==============================================================================*
*		PART 4: All the rest from PSM we probably won't need 
*==============================================================================*
/********************************************************************************
			PART 4.1:	Treatment effects for different TECH-levels (TFP)
*******************************************************************************/
/*		
		- All models use probit and nneigghbor (3) and no interactions
		- with nn5 and caliper .05 would need to drop too many variables
		--> in general not useful to divide into TECH subsamples			*/

*---------------------------*
* Probit w/o TECH, using 3NN
*---------------------------*

cap gen TFPS17 =  (TFP2017 -  3.656046) / 2.056464


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
	
	
*--------------------------------------------------*
* Probit w/o TECH including interactions, using 3NN
*--------------------------------------------------*
	
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
*			PART 4.2:	Treatment effects for different TECH-levels (wages)
*******************************************************************************/

*---------------------------*
* Probit w/o TECH, using 3NN
*---------------------------*

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

	
*--------------------------------------------------*
* Probit w/o TECH including interactions, using 3NN
*--------------------------------------------------*
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

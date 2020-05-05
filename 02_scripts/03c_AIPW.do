/*******************************************************************************
								AIPW DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 03c
		
		PURPOSE:	Perform AIPW Matching
		
		OUTLINE:	PART 1:	
		

	
********************************************************************************
					
*******************************************************************************/

	global S "OWN TECH RD2015 "	// Dummies with TECH
	global P "logwages2015 TFP2015 emp15 DEBTS2015 "
		
	cap gen emp15 = exp(logemp2015)
	cap gen TFPST2017 = (TFP2017 - 3.656046) /2.056464 
	
*------------------------------------------------------------------------------*
*	PART 1.1: just for checking
*------------------------------------------------------------------------------*

cap drop osa1
cap drop p*
teffects psmatch (TFPST2017)(FDI2016  i.($S) c.($P)) , osample(osa1) gen(p1) atet
tebalance summarize
teffects overlap


cap drop osa1
teffects ipw (TFPST2017 )(FDI2016  i.($S) c.($P)) , osample(osa1) 
tebalance summarize
*teffects overlap


cap drop osa1
teffects aipw (TFPST2017  i.($S) c.($P)) (FDI2016   i.($S) c.($P) ) , osample(osa1) 
tebalance summarize
*teffects overlap


/********************************************************************************
					PART 2:	AIPW by type  
*******************************************************************************/

*MLOGIT 


*AIPW by type
cap drop osa1
teffects aipw (TFPST2017  i.($S) c.($P) )(FDITYPE2016  i.($S) c.($P) ) , osample(osa1) 
teffects overlap
outreg2 using $results\04_bytype\bytype_table_1.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 OME2 OME3 TME1 TME2 TME3) lab()
tebalance summarize 
*worst is 8% diff for independent, 0.7 for logemp


*ipw by type
cap drop osa1
teffects ipw (TFPST2017 )(FDITYPE2016  i.($S) c.($P) ) , osample(osa1) 
outreg2  using $results\04_bytype\bytype_table_1.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME 0 OME1 OME2 OME3 TME1 TME2 TME3)
tebalance summarize





*seperate logits

*AIPW Logit type1 
cap drop osa1
teffects aipw (TFPST2017   i.($S) c.($P) )(FDI2016 c.($P) i.($S)  ) if FDITYPE2016==1 | FDITYPE2016==0, osample(osa1)
outreg2 using $results\04_bytype\bytype_table_1.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 TME1)


*AIPW Logit type2
cap drop osa1
teffects aipw (TFPST2017   i.($S) c.($P) )(FDI2016 c.($P) i.($S)  ) if FDITYPE2016==2 | FDITYPE2016==0, osample(osa1)
outreg2 using $results\04_bytype\bytype_table_1.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 TME1)


*AIPW Logit type3
cap drop osa1
teffects aipw (TFPST2017   i.($S) c.($P) )(FDI2016 c.($P) i.($S)  ) if FDITYPE2016==3 | FDITYPE2016==0, osample(osa1)
outreg2 using $results\04_bytype\bytype_table_1.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 TME1)


/********************************************************************************
					PART 3:	by type with tech matches
*******************************************************************************/
cap drop osa1
teffects aipw (TFPST2017  i.($S) c.($P) )(FDITYPE2016  i.($S) c.($P) ) if TECH==1, osample(osa1)
*outreg2 using $results\04_bytype\bytype_mlog_1.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 OME2 OME3 TME1 TME2 TME3) lab()
tebalance summarize 
*0.15 for all, emp has shit Var Ratio

cap drop osa1
teffects aipw (TFPST2017  i.($S) c.($P) )(FDITYPE2016  i.($S) c.($P) ) if TECH==2, osample(osa1)
*outreg2 using $results\04_bytype\bytype_mlog_1.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 OME2 OME3 TME1 TME2 TME3) lab()
tebalance summarize 
*0.12-0.14 var ratio of emp shit

cap drop osa1
teffects aipw (TFPST2017  i.($S) c.($P) )(FDITYPE2016  i.($S) c.($P) ) if TECH==3, osample(osa1)
*outreg2 using $results\04_bytype\bytype_mlog_1.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 OME2 OME3 TME1 TME2 TME3) lab()
tebalance summarize 
*0.14-0.15, var rat of emp shit

cap drop osa1
teffects aipw (TFPST2017  i.($S) c.($P) )(FDITYPE2016  i.($S) c.($P) ) if TECH==4, osample(osa1)
*outreg2 using $results\04_bytype\bytype_mlog_1.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 OME2 OME3 TME1 TME2 TME3) lab()
tebalance summarize 
*0.11-0.14 , SD kinda crap, var ratio okay except for emp


/********************************************************************************
					PART 3: creating log for balances
*******************************************************************************/

cap log close
	log using $log/04_bytype_balances, replace

	cap teffects aipw (TFPST2017  i.($S) c.($P) )(FDITYPE2016  i.($S) c.($P) )
	tebalance summarize
	
	cap teffects ipw (TFPST2017 )(FDITYPE2016  i.($S) c.($P) )
	tebalance summarize
	
	cap teffects aipw (TFPST2017   i.($S) c.($P) )(FDI2016 c.($P) i.($S)  ) if FDITYPE2016==1 | FDITYPE2016==0
	tebalance summarize
	
	cap teffects aipw (TFPST2017   i.($S) c.($P) )(FDI2016 c.($P) i.($S)  ) if FDITYPE2016==2 | FDITYPE2016==0
	tebalance summarize
	
	cap teffects aipw (TFPST2017   i.($S) c.($P) )(FDI2016 c.($P) i.($S)  ) if FDITYPE2016==3 | FDITYPE2016==0
	tebalance summarize
	
log close

/*******************************************************************************
								AIPW DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 03c
		
		PURPOSE:	Perform AIPW Matching
		
		OUTLINE:	PART 1:	
		
														
	
********************************************************************************
					PART 1:	AIPW (THEA part)
*******************************************************************************/

	global S "OWN PORT"	// Dummies with TECH
	global P "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	
*------------------------------------------------------------------------------*
*	PART 1.1: Probit w/o TECH, using 3NN
*------------------------------------------------------------------------------*

cap drop osa1
teffects aipw (logwages2017 c.($P) i.($S))(FDI2016 c.($P) i.($S)  ) , ///
osample(osa1) 

/********************************************************************************
					PART 2:	AIPW by type  (Georg part)
*******************************************************************************/

*AIPW by type
cap drop osa1
teffects aipw (TFP2017  i.($S) c.($P) )(FDITYPE2016  i.($S) c.($P) ) , osample(osa1)
outreg2 using $results/04_bytype/bytype_mlog_1.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 OME2 OME3 TME1 TME2 TME3) lab()
tebalance summarize 
*worst is 8% diff for independent, 0.7 for logemp

/*c#i interactions
cap drop osa1
teffects aipw (TFP2017  i.($S)##c.($P) )(FDITYPE2016  i.($S)##c.($P) ) , osample(osa1)
*same results/4_bytype as with interactions
*outreg2 using $results/4_bytype/bytype_12.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME1 OME2 OME3)
tebalance summarize */



*ipw by type
cap drop osa1
teffects ipw (TFP2017 )(FDITYPE2016  i.($S) c.($P) ) , osample(osa1) 
outreg2  using $results/04_bytype/bytype_mlog_1.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME 0 OME1 OME2 OME3 TME1 TME2 TME3)
tebalance summarize



*seperate logits
cap drop osa1
teffects aipw (TFP2017   i.($S) c.($P) )(FDI2016 c.($P) i.($S)  ) if FDITYPE2016==1 | FDITYPE2016==0, osample(osa1)
outreg2 using $results/04_bytype/bytype_log_1.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 TME1)
cap drop osa1
teffects aipw (TFP2017   i.($S) c.($P) )(FDI2016 c.($P) i.($S)  ) if FDITYPE2016==2 | FDITYPE2016==0, osample(osa1)
outreg2 using $results/04_bytype/bytype_log_1.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 TME1)

cap drop osa1
teffects aipw (TFP2017   i.($S) c.($P) )(FDI2016 c.($P) i.($S)  ) if FDITYPE2016==3 | FDITYPE2016==0, osample(osa1)
outreg2 using $results/04_bytype/bytype_log_1.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 TME1)


*seperate probits with dropping of variables
cap drop osa1
cap teffects aipw (TFP2017   i.($S)##c.($P) )(FDI2016 c.($P) i.($S), probit  ) if FDITYPE2016==1 | FDITYPE2016==0, osample(osa1)
teffects aipw (TFP2017   i.($S)##c.($P) )(FDI2016 c.($P) i.($S), probit  ) if FDITYPE2016==1 | FDITYPE2016==0 & osa1==0
outreg2 using $results/04_bytype/bytype_prob_1.tex, replace dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 TME1)

cap drop osa1
cap teffects aipw (TFP2017   i.($S)##c.($P) )(FDI2016 c.($P) i.($S), probit ) if FDITYPE2016==2 | FDITYPE2016==0, osample(osa1)
teffects aipw (TFP2017   i.($S)##c.($P) )(FDI2016 c.($P) i.($S), probit ) if FDITYPE2016==2 | FDITYPE2016==0 & osa1==0
outreg2 using $results/04_bytype/bytype_prob_1.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 TME1)

cap drop osa1
cap teffects aipw (TFP2017   i.($S)##c.($P) )(FDI2016 c.($P) i.($S), probit ) if FDITYPE2016==3 | FDITYPE2016==0, osample(osa1)
teffects aipw (TFP2017   i.($S)##c.($P) )(FDI2016 c.($P) i.($S), probit ) if FDITYPE2016==3 | FDITYPE2016==0 & osa1==0
outreg2 using $results/04_bytype/bytype_prob_1.tex, append dec(3) drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) nocon eqdrop(OME0 OME1 TME1)



*ipws sep logits
cap drop osa1
teffects ipw (TFP2017)  (FDI2016 c.($P) i.($S)  ) if FDITYPE2016==1 | FDITYPE2016==0, osample(osa1)
outreg2 using $results/4_bytype/bytype_ipw_1.tex, replace dec(3) 
cap drop osa1
teffects ipw (TFP2017)  (FDI2016 c.($P) i.($S)  ) if FDITYPE2016==2 | FDITYPE2016==0, osample(osa1)
outreg2 using $results/4_bytype/bytype_ipw_1.tex, append dec(3) 

cap drop osa1
teffects ipw (TFP2017)   (FDI2016 c.($P) i.($S)  ) if FDITYPE2016==3 | FDITYPE2016==0, osample(osa1)
outreg2 using $results/4_bytype/bytype_ipw_1.tex, append dec(3) 



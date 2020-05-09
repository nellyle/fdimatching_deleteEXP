/*******************************************************************************
							BY FDI TYPE DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 03c
	
		PURPOSE:	Estimation of the effect of different types of FDI on TFP.
		
		OUTLINE:	PART 1:	Multinnominal Logit Models
						 1.1: AIPW
						 1.2: IPW
					PART 2: Seperate Models
						 2.1 AIPW

********************************************************************************
			PART 1: Mulitnominal Logit Models
*******************************************************************************/
	cap global S "OWN TECH RD2015 "	// Dummies with TECH
	cap global P "logwages2015 TFP2015 emp15 DEBTS2015 "
		
	cap gen emp15 = exp(logemp2015)
	cap gen TFPST2017 = (TFP2017 - 3.656046) /2.056464 
*------------------------------------------------------------------------------*
*	PART 1.1:	AIPW
*------------------------------------------------------------------------------*

teffects aipw (TFPST2017  i.($S) c.($P) )(FDITYPE2016  i.($S) c.($P) ) , 
teffects overlap, ptlevel(1) saving($results\04_bytype\bytype_overlap_l1.gph, replace)
teffects overlap, ptlevel(2) saving($results\04_bytype\bytype_overlap_l2.gph, replace)
teffects overlap, ptlevel(3) saving($results\04_bytype\bytype_overlap_l3.gph, replace)

outreg2 using $results\04_bytype\bytype_table_1.tex, replace dec(3) ///
	drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) ///
	nocon eqdrop(OME0 OME1 OME2 OME3 TME1 TME2 TME3) lab()

tebalance summarize 

*------------------------------------------------------------------------------*
*	PART 1.2:	IPW
*------------------------------------------------------------------------------*

teffects ipw (TFPST2017 )(FDITYPE2016  i.($S) c.($P))

outreg2  using $results\04_bytype\bytype_table_1.tex, append dec(3) ///
	drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) ///
	nocon eqdrop(OME 0 OME1 OME2 OME3 TME1 TME2 TME3)

tebalance summarize


********************************************************************************
*			PART 2: Seperate Logit Models
********************************************************************************

*------------------------------------------------------------------------------*
*	PART 2.1:	AIPW
*------------------------------------------------------------------------------*

*AIPW Logit type1 

teffects aipw (TFPST2017   i.($S) c.($P) )(FDI2016 c.($P) i.($S)  ) ///
	if FDITYPE2016==1 | FDITYPE2016==0

outreg2 using $results\04_bytype\bytype_table_1.tex, append dec(3) ///
	drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) ///
	nocon eqdrop(OME0 OME1 TME1)


*AIPW Logit type2

teffects aipw (TFPST2017   i.($S) c.($P) )(FDI2016 c.($P) i.($S)  ) ///
	if FDITYPE2016==2 | FDITYPE2016==0

outreg2 using $results\04_bytype\bytype_table_1.tex, append dec(3) ///
	drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) ///
	nocon eqdrop(OME0 OME1 TME1)


*AIPW Logit type3

teffects aipw (TFPST2017   i.($S) c.($P) )(FDI2016 c.($P) i.($S)  ) ///
	if FDITYPE2016==3 | FDITYPE2016==0

outreg2 using $results\04_bytype\bytype_table_1.tex, append dec(3) ///
	drop(i.OWN i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015 ) ///
	nocon eqdrop(OME0 OME1 TME1)


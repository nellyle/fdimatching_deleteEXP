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
	
*------------------------------------------------------------------------------*
*	PART 1.1:	AIPW
*------------------------------------------------------------------------------*

	teffects aipw (TFPS17  i.($F) c.($C) )(FDITYPE2016  i.($F) c.($C) ) 
	
	tebalance summarize 	
	
	teffects overlap, ptlevel(1) ///
		saving($results\04_bytype\bytype_overlap_l1.gph, replace)
	
	teffects overlap, ptlevel(2) ///
		saving($results\04_bytype\bytype_overlap_l2.gph, replace)
		
	teffects overlap, ptlevel(3) ///
		saving($results\04_bytype\bytype_overlap_l3.gph, replace)

	outreg2 using $results\04_bytype\bytype_table_1.tex, replace dec(3) ///
		drop(OWN TECH RD2015 logwages2015 TFP2015 emp2015 DEBTS2015) ///
		nocon eqdrop(OME0 OME1 OME2 OME3 TME1 TME2 TME3) lab()


*------------------------------------------------------------------------------*
*	PART 1.2:	IPW
*------------------------------------------------------------------------------*

	teffects ipw (TFPS17 )(FDITYPE2016  i.($F) c.($C))
	
	tebalance summarize
	
	outreg2  using $results\04_bytype\bytype_table_1.tex, append dec(3) ///
		drop(OWN TECH RD2015 logwages2015 TFP2015 emp2015 DEBTS2015) ///
		nocon eqdrop(OME 0 OME1 OME2 OME3 TME1 TME2 TME3)




********************************************************************************
*			PART 2: Seperate Logit Models
********************************************************************************

*------------------------------------------------------------------------------*
*	PART 2.1:	AIPW Logit
*------------------------------------------------------------------------------*

*=============================*
* Type 1 (Exports-oriented FDI) 
*=============================*
//	Type 0: No FDI 

	teffects aipw (TFPS17   i.($F) c.($C) )(FDI2016 c.($C) i.($F)  ) ///
		if FDITYPE2016==1 | FDITYPE2016==0

	tebalance summarize		

	outreg2 using $results\04_bytype\bytype_table_1.tex, append dec(3) ///
		drop(OWN TECH RD2015 logwages2015 TFP2015 emp2015 DEBTS2015) ///
		nocon eqdrop(OME0 OME1 TME1)


*=================================*
* Type 2(Technology intensive FDI) 
*=================================*

	teffects aipw (TFPS17   i.($F) c.($C) )(FDI2016 c.($C) i.($F)  ) ///
		if FDITYPE2016==2 | FDITYPE2016==0

	tebalance summarize
	
	outreg2 using $results\04_bytype\bytype_table_1.tex, append dec(3) ///
		drop(OWN TECH RD2015 logwages2015 TFP2015 emp2015 DEBTS2015) ///
		nocon eqdrop(OME0 OME1 TME1)


*====================================*
* Type 3(Domestic market seeking FDI) 
*====================================*

	teffects aipw (TFPS17   i.($F) c.($C) )(FDI2016 c.($C) i.($F)  ) ///
		if FDITYPE2016==3 | FDITYPE2016==0

	tebalance summarize
	
	outreg2 using $results\04_bytype\bytype_table_1.tex, append dec(3) ///
		drop(OWN TECH RD2015 logwages2015 TFP2015 emp2015 DEBTS2015) ///
		nocon eqdrop(OME0 OME1 TME1)






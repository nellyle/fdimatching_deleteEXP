/*******************************************************************************
								AIPW DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 03c
		
		PURPOSE:	Perform AIPW Matching
		
		OUTLINE:	PART 1:	
		
														
	
********************************************************************************
					PART 1:	??
*******************************************************************************/

*lets use AIPW* 
*AIPW bt type
global S " OWN PORT"
global P "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"

drop osa1
teffects aipw (TFP2017  i.($S) c.($P) )(FDITYPE2016  i.($S) c.($P) ) , osample(osa1)
	 outreg2 using $results\test_1.tex, replace dec(3) addnote("This is a note") stats(ATE POmean)


tebalance summarize
*teffects overlap, ptlevel(1) saving(overlap_type_m1.gph, replace)
*teffects overlap, ptlevel(2) saving(overlap_type_m2.gph, replace)
*teffects overlap, ptlevel(3) saving(overlap_type_m3.gph, replace)
drop osa1




cap drop osa1
teffects aipw (logwages2017  logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) ///
(FDI2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) if TECH!=4 , osample(osa1) 
*teffects aipw (logwages2017  logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN i.TECH)///
*(FDI2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN i.TECH) if osa1==0
teffects overlap 
tebalance summarize

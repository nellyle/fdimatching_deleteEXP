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
cap drop osa1
cap teffects aipw (logwages2017 c.($P) i.($S))(FDI2016 c.($P) i.($S)  ) , ///
osample(osa1) 
teffects aipw (logwages2017 c.($P) i.($S))(FDI2016 c.($P) i.($S)  ) if osa1==0
teffects overlap
tebalance summarize

cap drop osa1
teffects aipw (logwages2017  logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) ///
(FDI2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) if TECH!=4 , osample(osa1) 
*teffects aipw (logwages2017  logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN i.TECH)///
*(FDI2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN i.TECH) if osa1==0
teffects overlap 
tebalance summarize

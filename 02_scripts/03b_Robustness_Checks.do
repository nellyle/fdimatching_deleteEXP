/*******************************************************************************
							ROBUSTNESS DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 03b
	
		PURPOSE:	Robustness Checks.
		
		OUTLINE:	PART 1:	Including Interactions
					PART 2: Excluding Outliers
					PART 3: Including PORT
					PART 4: ATT
					PART 5: Analysis by TECH
					PART 6: Appendix: Frequency of FDI by TECH

********************************************************************************
			PART 1: Including Interactions
*******************************************************************************/

	cap drop osa1 
	cap drop p1* 
	teffects psmatch (TFPS17) ///
					 (FDI2016 i.($F)##c.($C), logit),	///
					  osample(osa1) generate(p1)
					  
	tebalance summarize
	
	outreg2 using $results/05_Tables/Table6_Robustness.tex, replace dec(3) ///
	drop(i.OWN i.TECH logwages2015 TFP2015 emp2015 DEBTS2015 RD2015) ///
	nocon eqdrop(TME1) 

********************************************************************************
*			PART 2: Excluding Outliers
********************************************************************************

	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
						 (FDI2016 i.($F) c.($C), logit) if emp2015<4000000,		///
						 osample(osa1) generate(p1)
						 
	tebalance summarize
	
	outreg2 using $results/05_Tables/Table6_Robustness.tex, append dec(3) ///
	drop(i.OWN i.TECH logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) ///
	nocon eqdrop(TME1) 
	
********************************************************************************
*			PART 3: Including PORT
********************************************************************************

global P "OWN TECH RD2015 PORT"

	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
					 (FDI2016 i.($P) c.($C), logit),	///
					  osample(osa1) generate(p1)
					  
	tebalance summarize
	
	outreg2 using $results/05_Tables/Table6_Robustness.tex, append dec(3) ///
	drop(i.OWN i.TECH i.PORT logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) ///
	nocon eqdrop(TME1)
	
********************************************************************************
*			PART 4: ATT
********************************************************************************
	
	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
						(FDI2016 i.($F) c.($C), logit), atet	///
						osample(osa1) generate(p1)
						
	tebalance summarize
	
	outreg2 using $results/05_Tables/Table6_Robustness.tex, append dec(3) ///
	drop(i.OWN i.TECH logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) ///
	nocon eqdrop(TME1) 

********************************************************************************
*			PART 5: Analysis by TECH
********************************************************************************

*====================*
* (1) NN1 TECH=1
*====================*

	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFPS17) ///
					 (FDI2016  i.($F) c.($C), logit) if TECH==1,	///
					  osample(osa1) generate(p1)
					  
	tebalance summarize				  

	outreg2 using $results/05_Tables/Table7_Robustness.tex, replace dec(3) ///
	drop(i.OWN i.TECH i.PORT logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) ///
	nocon eqdrop(TME1)
		
*====================*
* (2) NN1 TECH=2
*====================*
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFPS17) ///
					 (FDI2016  i.($F) c.($C), logit) if TECH==2,	///
					  osample(osa1) generate(p1)
					  
	tebalance summarize

	outreg2 using $results/05_Tables/Table7_Robustness.tex, append dec(3) ///
	drop(i.OWN i.TECH i.PORT logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) ///
	nocon eqdrop(TME1)	
	
*====================*
* (3) NN1 TECH=3
*====================*
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFPS17) ///
					 (FDI2016  i.($F) c.($C), logit) if TECH==3,	///
					  osample(osa1) generate(p1)
					  
	tebalance summarize

	outreg2 using $results/05_Tables/Table7_Robustness.tex, append dec(3) ///
	drop(i.OWN i.TECH i.PORT logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) ///
	nocon eqdrop(TME1)
	
*====================*
* (4) NN1 TECH=4
*====================*
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFPS17) ///
					 (FDI2016  i.($F) c.($C), logit) if TECH==4,	///
					  osample(osa1) generate(p1)
	tebalance summarize				  				  

	outreg2 using $results/05_Tables/Table7_Robustness.tex, append dec(3) ///
	drop(i.OWN i.TECH i.PORT logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) ///
	nocon eqdrop(TME1)	
	
	// Calculating ATE weighted by each sample size: 
	display ///
	(0.1600066*4194+0.0864057*1685+0.1721028*3539+0.1802721*1905)/11232 
	/*= 0.15750992*/


********************************************************************************
*			PART 6: Appendix: Frequency of FDI by TECH
********************************************************************************

	tab2 TECH FDI2016, row

	tabout TECH FDI2016 using $results/05_Tables/Table7a_Robustness.tex, ///
	cells(freq row cum) format(0 1) style(tex) clab(No. Col_% Cum_%) replace

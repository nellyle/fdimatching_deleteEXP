/*******************************************************************************
								Tables DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	 Do-File 04a
		
		PURPOSE:	Robustness checks of NN1 model
		
		OUTLINE:	TABLE 3: ROBUSTNESS
					
/********************************************************************************
			TABLE 3: ROBUSTNESS
*******************************************************************************/
*------------------------------------------------------------------------------*
*	(1) NN1 interaction
*	(2) NN1 (excluding emp outlier>8.000.000)
*	(3) NN1 (including port)
*	(4) ATT for NN1
*	(5) - (6) NN1 by TECH
*------------------------------------------------------------------------------*//


//	Setting globals and generating variables
	
	cap generate TFPS17=  (TFP2017-3.656046)/2.056464
	cap generate emp2015= exp(logemp2015)
	
	global F "OWN TECH RD2015"
	global C "logwages2015 TFP2015 emp2015 DEBTS2015"


*====================*
* (1) NN1 interaction
*====================*

	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
						(FDI2016 i.($F)##c.($C), logit),	///
						osample(osa1) generate(p1)

	outreg2 using $results/05_Tables/Table3_Robustness.tex, replace dec(3) drop(i.OWN i.TECH logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) nocon eqdrop(TME1) 


*====================*
* (2) NN1 emp2015<8M
*====================*

	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
						(FDI2016 i.($F) c.($C), logit) if emp2015<4000000,		///
						osample(osa1) generate(p1)

	outreg2 using $results/05_Tables/Table3_Robustness.tex, append dec(3) drop(i.OWN i.TECH logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) nocon eqdrop(TME1) 


*====================*
* (3) NN1 (incl. port)
*====================*

global P "OWN TECH RD2015 PORT"

	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
					 (FDI2016 i.($P) c.($C), logit),	///
					  osample(osa1) generate(p1)
	outreg2 using $results/05_Tables/Table3_Robustness.tex, append dec(3) drop(i.OWN i.TECH i.PORT logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) nocon eqdrop(TME1)


*====================*
* (4) ATT for NN1
*====================*

	cap drop osa1 
	cap drop p1* 
	cap teffects psmatch (TFPS17) ///
						(FDI2016 i.($F) c.($C), logit), atet	///
						osample(osa1) generate(p1)

	outreg2 using $results/05_Tables/Table3_Robustness.tex, append dec(3) drop(i.OWN i.TECH logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) nocon eqdrop(TME1) 

*------------------------------------------------------------------------------*
*	ATE OF FDI ON TFP BY TECH INTENSITY
*------------------------------------------------------------------------------*	

*====================*
* (5) NN1 TECH=1
*====================*

	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFPS17) ///
					 (FDI2016  i.($F) c.($C), logit) if TECH==1,	///
					  osample(osa1) generate(p1)
	tebalance summarize				  
	// very good SD and variance ratio
	// ATE =  .1600066 
	//4194 observations

	outreg2 using $results/05_Tables/Table3_Robustness.tex, append dec(3) drop(i.OWN i.TECH i.PORT logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) nocon eqdrop(TME1)
		
*====================*
* (6) NN1 TECH=2
*====================*
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFPS17) ///
					 (FDI2016  i.($F) c.($C), logit) if TECH==2,	///
					  osample(osa1) generate(p1)
	tebalance summarize
	// very good SD and variance ratio
	// ATE = .0864057 
	// 1685 observations

	outreg2 using $results/05_Tables/Table3_Robustness.tex, append dec(3) drop(i.OWN i.TECH i.PORT logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) nocon eqdrop(TME1)	
	
*====================*
* (7) NN1 TECH=3
*====================*
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFPS17) ///
					 (FDI2016  i.($F) c.($C), logit) if TECH==3,	///
					  osample(osa1) generate(p1)
	tebalance summarize
	// very good SD, variance ratios good except emp2015 (0.5) 
	// ATE = .1721028  
	// 3539 observations

	outreg2 using $results/05_Tables/Table3_Robustness.tex, append dec(3) drop(i.OWN i.TECH i.PORT logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) nocon eqdrop(TME1)
	
*====================*
* (8) NN1 TECH=4
*====================*
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFPS17) ///
					 (FDI2016  i.($F) c.($C), logit) if TECH==4,	///
					  osample(osa1) generate(p1)
	tebalance summarize				  				  
	// very good variance ratio, SD good except emp2015 (0.15)
	// ATE = .1802721
	// 1905 observations

	outreg2 using $results/05_Tables/Table3_Robustness.tex, append dec(3) drop(i.OWN i.TECH i.PORT logwages2015 TFP2015 emp2015 DEBTS2015  RD2015) nocon eqdrop(TME1)	
	
* Calculating ATE weighted by each sample size: 
display (0.1600066*4194+0.0864057*1685+0.1721028*3539+0.1802721*1905)/11232 /*= 0.15750992*/
//find bigger effect if require observations to be matched with observations of same technology intensity only*/



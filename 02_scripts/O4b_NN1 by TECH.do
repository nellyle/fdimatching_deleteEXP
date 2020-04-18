/********************************************************************************
				ASSUMING THAT MATCHES ONLY GOOD WITHIN SECTOR
*******************************************************************************/

// analysis is motivated by 'Gifted kids or pushy parents? Foreign direct investment and plant productivity in Indonesia' by Arnold and Javorcik (2009):

/*'In constructing the pairs of
observations matched on the propensity score, we make sure that the
matched control observations are assigned only from the same year
and the same sector as the acquired plant. This eliminates the
possibility that differences in productivity or other aspects of plant
operations observed across sector-year combinations exert influence
on our estimated effects.' (p.44)*/

/* BibTex: \citep{arnold2009gifted}

// CONCLUSION: ATE with 0.15750992 similar in magnitude although more similar to interaction model => might conclude that real ATE lies in between but is definitely positive and significant

*------------------------------------------------------------------------------*
*	ATE OF FDI ON TFP BY TECH INTENSITY (NN1)
*------------------------------------------------------------------------------*/	

	
	
	generate emp2015=exp(logemp2015)
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 /*EXP2015*/ RD2015) if TECH==1,	///
					  osample(osa1) generate(p1)
	tebalance summarize				  
	// very good SD and variance ratio
	// ATE =   .3290479 
	//4194 observations
	
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 /*EXP2015*/ RD2015) if TECH==2,	///
					  osample(osa1) generate(p1)
	tebalance summarize
	// very good SD and variance ratio
	// ATE =  .1776903 
	// 1685 observations
	
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 /*EXP2015*/ RD2015) if TECH==3,	///
					  osample(osa1) generate(p1)
	tebalance summarize
	// very good SD, variance ratios good except emp2015 (0.5) 
	// ATE =  .3539232 
	// 3539 observations
	
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFP2017) ///
					 (FDI2016 i.OWN i.TECH ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 /*EXP2015*/ RD2015) if TECH==4,	///
					  osample(osa1) generate(p1)
	tebalance summarize				  				  
	// very good variance ratio, SD good except emp2015 (0.15)
	// ATE =  .370723
	// 1905 observations
	
/* Calculating ATE weighted by each sample size: 
(0.3290479*4194+0.1776903*1685+0.3539232*3539+0.370723*1905)/11232 = .32391351 
=> find bigger effect if require observations to be matched with observations of same technology intensity only*/


*------------------------------------------------------------------------------*
*	ATE OF FDI ON TFP BY TECH INTENSITY (NN1) - STANDARDISED
*------------------------------------------------------------------------------*	


gen TFPS17 =  (TFP2017 -  3.656046) / 2.056464


	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFPS17) ///
					 (FDI2016 i.OWN i.TECH ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 /*EXP2015*/ RD2015) if TECH==1,	///
					  osample(osa1) generate(p1)
	tebalance summarize				  
	// very good SD and variance ratio
	// ATE =  .1600066 
	//4194 observations
	
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFPS17) ///
					 (FDI2016 i.OWN i.TECH ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 /*EXP2015*/ RD2015) if TECH==2,	///
					  osample(osa1) generate(p1)
	tebalance summarize
	// very good SD and variance ratio
	// ATE = .0864057 
	// 1685 observations
	
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFPS17) ///
					 (FDI2016 i.OWN i.TECH ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 /*EXP2015*/ RD2015) if TECH==3,	///
					  osample(osa1) generate(p1)
	tebalance summarize
	// very good SD, variance ratios good except emp2015 (0.5) 
	// ATE = .1721028  
	// 3539 observations
	
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (TFPS17) ///
					 (FDI2016 i.OWN i.TECH ///
					  logwages2015 TFP2015 emp2015 DEBTS2015 /*EXP2015*/ RD2015) if TECH==4,	///
					  osample(osa1) generate(p1)
	tebalance summarize				  				  
	// very good variance ratio, SD good except emp2015 (0.15)
	// ATE = .1802721
	// 1905 observations
	
/* Calculating ATE weighted by each sample size: 
(0.1600066*4194+0.0864057*1685+0.1721028*3539+0.1802721*1905)/11232 = 0.15750992
=> find bigger effect if require observations to be matched with observations of same technology intensity only*/


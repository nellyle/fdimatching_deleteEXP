/*******************************************************************************
						DESCRIPTIVE ANALYSIS DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	  Do-File 02
		
		PURPOSE:	Analysis of Data Set
		
		OUTLINE:	PART 1:	Overview
					PART 2: Balance Tests
					PART 3: Figure TECH by FDI
					
********************************************************************************
					PART 1: Overview
*******************************************************************************/
	
	describe

//	Covariance matrix
	corr	
/*	--> fdi is pos correlated to PORT, negatively to TECH
	--> pos. to logemp2015, EXP2015, logwages2017, logemp2017 and EXP2017	*/
	

********************************************************************************
*					PART 2: Balance Tests
********************************************************************************

*------------------------------------------------------------------------------*
*	PART 2.1: Overlap of pre-treatement variables
*------------------------------------------------------------------------------*
//	Density plots comparing tratment and control groups for selected varaibles
		
//	OWN 
	tab2 OWN FDI2016, col
	twoway kdensity OWN if FDI2016==0 || kdensity OWN if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))
	// Good overlap, except for listed companies, which have received less FDI
	
//	TECH 
	tab2 TECH FDI2016, col
	twoway hist TECH if FDI2016==0 || hist TECH if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))	
	/* Low-tech firms seem to be more likely to get FDI than high-tech firms
	 --> Significant imbalance, might cause trouble if prediciton is "too good"		*/
	
//	PORT 
	tab2 PORT FDI2016, col
	twoway kdensity PORT if FDI2016==0 || kdensity PORT if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))	
	// Firms without port seem to be less likely to receive FDI

//	logwages2015 
	twoway kdensity logwages2015 if FDI2016==0 || kdensity logwages2015 if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))	
	// Almost perfect overlap

//	TFP2015 
	twoway kdensity TFP2015 if FDI2016==0 || kdensity TFP2015 if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))	
	// Almost perfect overlap

//	logemp2015 
	twoway kdensity logemp2015 if FDI2016==0 || kdensity logemp2015 if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))	
	// Decent overlap, only few control obs at left-hand tail without overlap
	
//	DEBTS2015 
	twoway kdensity DEBTS2015 if FDI2016==0 || kdensity DEBTS2015 if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))	
	// Almost perfect overlap
	
//	EXP2015 
	xtile EXP2015_index5=EXP2015, n(5)
	tab2 EXP2015_index5 FDI2016, col
	twoway kdensity EXP2015 if FDI2016==0 || kdensity EXP2015 if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))
	// Not the best overlap --> no overlap at right hand tail 
	
//	RD2015
	twoway kdensity RD2015 if FDI2016==0 || kdensity RD2015 if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))	
	// Decent overlap
	
	
*------------------------------------------------------------------------------*
*	PART 2.2: Balance test of pre-treatment variables
*------------------------------------------------------------------------------*	
//			By treatment variable
iebaltab 	TECH PORT ///
			logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, ///
			grpvar(FDI2016) save($results/02_Descriptive_Analysis/baltest_byfdi_pre.xlsx) replace

/*	--> Significant differnces betw. treatment and control group in all
		respects even before treatment. 	*/
		
//			By FDI type (treatment arms)
iebaltab 	TECH PORT ///
			logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, ///
			grpvar(FDITYPE2016) save($results/02_Descriptive_Analysis/baltest_byfditype_pre.xlsx) replace

			
	
/********************************************************************************
					PART 3: Figure TECH by FDI
*******************************************************************************/

histogram TECH, discrete by (FDI2016, note("")) frequency subtitle("No FDI") subtitle("FDI") xtitle("Industry Technology Intensity") gap(30) xlabel(1 2 3 4) saving($results/02_Descriptive_Analysis/hist_TECHbyFDI.gph, replace)
//FDI textboxes manually renamed
graph export $results/02_Descriptive_Analysis/hist_TECHbyFDI.pdf, as(pdf) replace

cap drop x
cap drop fx*
kdensity FDI2016, nograph generate(x fx)
kdensity FDI2016 if TECH==1, nograph generate(fx0) at(x)
kdensity FDI2016 if TECH==2, nograph generate(fx1) at(x)
kdensity FDI2016 if TECH==3, nograph generate(fx2) at(x)
kdensity FDI2016 if TECH==4, nograph generate(fx3) at(x)
label var fx0 "Low-tech"
label var fx1 "Medium low-tech"
label var fx2 "Medium high-tech"
label var fx3 "High-tech"
line fx0 fx1 fx2 fx3 x, sort  ytitle(Density) xtitle(No FDI vs FDI) saving($results/02_Descriptive_Analysis/kdensity_FDIbyTECH.gph, replace)
graph export $results/02_Descriptive_Analysis/kdensity_FDIbyTECH.pdf, as(pdf) replace
			
			
			
			
			
			
			
			
			
			
			
			
			

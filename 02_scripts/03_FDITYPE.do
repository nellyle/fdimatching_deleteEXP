*------------------------------------------------------------------------------*
*	PART 3.4: Estimation using psmatching with probit estimator: WAGES
 ATT, ATE, ATN in FDITYPES model without interactions
*------------------------------------------------------------------------------*
****----------------------------------AIWP-------------------------------------*
cap drop osa1
teffects aipw (logwages2017  logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) ///
(FDITYPE2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) if TECH!=4 , osample(osa1)
 
teffects aipw (logwages2017  logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN i.TECH)///
(FDITYPE2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN i.TECH) if osa1==0
teffects overlap 
tebalance summarize

*ATET is not possible for AIWP
****----------------------------------IPW--------------------------------------*
cap drop 
osa1 teffects ipw (logwages2017  logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH)(FDITYPE2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) if FDITYPE!=0  , osample(osa1) 
**
 cap drop osa1 
 teffects ipw (logwages2017)(FDI2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH), osample(osa1)
**by FDITYPE2016: ATE
 cap drop osa1
 teffects ipw (logwages2017)(FDITYPE2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) if osa1==0
**by FDITYPE2016: ATET: negative results 
 cap drop osa1
 teffects ipw (logwages2017)(FDITYPE2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH),atet osample(osa1)
****----------------------------------RA--------------------------------------*
**by FDITYPE2016: ATE
cap drop osa1 
teffects ra (logwages2017  logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH)(FDITYPE2016)
**by FDITYPE2016: ATET: positive results 
teffects ra (logwages2017  logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH)(FDITYPE2016),atet


*------------------------------------------------------------------------------*
*	PART 2.3: Estimation using psmatching with probit estimator: TFP2017
 ATT, ATE, ATN in FDITYPES model without interactions
*------------------------------------------------------------------------------*
****----------------------------------AIWP-------------------------------------*
cap drop osa1
teffects aipw (TFP2017 logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OW i.TECH)(FDITYPE2016 logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OWN i.TECH) if TECH!=4 , osample(osa1)


teffects aipw (TFP2017 logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OWN i.TECH)(FDITYPE2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) if osa1==0
teffects overlap 
tebalance summarize

*ATET is not possible for AIWP
****----------------------------------IPW--------------------------------------*
cap drop osa1 
teffects ipw (TFP2017)(FDITYPE2016 logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OWN i.TECH) if FDITYPE!=0  , osample(osa1) 
**
 cap drop osa1 
 teffects ipw (TFP2017)(FDI2016 logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OWN i.TECH), osample(osa1)
**by FDITYPE2016: ATE
cap drop osa1
teffects ipw (TFP2017)(FDITYPE2016 logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OWN i.TECH) if osa1==0
**by FDITYPE2016: ATET:  positive results 
 cap drop osa1
 teffects ipw (TFP2017)(FDITYPE2016 logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OWN i.TECH), atet 
****----------------------------------RA--------------------------------------*
**by FDITYPE2016: ATE
cap drop osa1 
teffects ra (TFP2017 logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OWN i.TECH)(FDITYPE2016)
**by FDITYPE2016: ATET: positive smaller results 
teffects ra (TFP2017  logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OWN i.TECH)(FDITYPE2016),atet

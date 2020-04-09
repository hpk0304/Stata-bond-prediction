clear
use "E:\Kiel\Thesis\Estimation\Methodology\Realization\Realization.dta"
merge 1:1 ID tm using "E:\Kiel\Thesis\Estimation\Methodology\HistSim\VaR_HistSim.dta"
drop _merge
merge 1:1 ID tm using "E:\Kiel\Thesis\Estimation\Methodology\VaRGARCH\VaR_GARCH.dta"
drop _merge

*=============== EXPECTED SHORTFALL =================

*====== HISTORICAL SIMULATION ==========
* ES is average of VaR and exceeding values
**** Portfolio by country

*q(5%)
rangestat (sum) rmdreal if rmdreal <= myquantile_w1, interval(y -1  0) by(c)
rename rmdreal_sum  rmdreal_sum_w1
rangestat (count) m if rmdreal <= myquantile_w1, interval(y -1  0) by(c)
rename m_count m_count_w1
gen ES_w1=rmdreal_sum_w1/m_count_w1

rangestat (sum) rmdreal if rmdreal <= myquantile_w5, interval(y -5  0) by(c)
rename rmdreal_sum  rmdreal_sum_w5
rangestat (count) m if rmdreal <= myquantile_w5, interval(y -5  0) by(c)
rename m_count m_count_w5
gen ES_w5=rmdreal_sum_w5/m_count_w5

rangestat (sum) rmdreal if rmdreal <= myquantile_w20, interval(y -20  0) by(c)
rename rmdreal_sum  rmdreal_sum_w20
rangestat (count) m if rmdreal <= myquantile_w20, interval(y -20  0) by(c)
rename m_count m_count_w20
gen ES_w20=rmdreal_sum_w20/m_count_w20

rangestat (sum) rmdreal if rmdreal <= myquantile_w50, interval(y -50  0) by(c)
rename rmdreal_sum  rmdreal_sum_w50
rangestat (count) m if rmdreal <= myquantile_w50, interval(y -50  0) by(c)
rename m_count m_count_w50
gen ES_w50=rmdreal_sum_w50/m_count_w50

rangestat (sum) rmdreal if rmdreal <= myquantile_w100, interval(y -100  0) by(c)
rename rmdreal_sum  rmdreal_sum_w100
rangestat (count) m if rmdreal <= myquantile_w100, interval(y -100  0) by(c)
rename m_count m_count_w100
gen ES_w100=rmdreal_sum_w100/m_count_w100

*q(1%)
rangestat (sum) rmdreal if rmdreal <= myquantile_w1_q1, interval(y -1  0) by(c)
rename rmdreal_sum  rmdreal_sum_w1_q1
rangestat (count) m if rmdreal <= myquantile_w1_q1, interval(y -1  0) by(c)
rename m_count m_count_w1_q1
gen ES_w1_q1=rmdreal_sum_w1_q1/m_count_w1_q1

rangestat (sum) rmdreal if rmdreal <= myquantile_w5_q1, interval(y -5  0) by(c)
rename rmdreal_sum  rmdreal_sum_w5_q1
rangestat (count) m if rmdreal <= myquantile_w5_q1, interval(y -5  0) by(c)
rename m_count m_count_w5_q1
gen ES_w5_q1=rmdreal_sum_w5_q1/m_count_w5_q1

rangestat (sum) rmdreal if rmdreal <= myquantile_w20_q1, interval(y -20  0) by(c)
rename rmdreal_sum  rmdreal_sum_w20_q1
rangestat (count) m if rmdreal <= myquantile_w20_q1, interval(y -20  0) by(c)
rename m_count m_count_w20_q1
gen ES_w20_q1=rmdreal_sum_w20_q1/m_count_w20_q1

rangestat (sum) rmdreal if rmdreal <= myquantile_w50_q1, interval(y -50  0) by(c)
rename rmdreal_sum  rmdreal_sum_w50_q1
rangestat (count) m if rmdreal <= myquantile_w50_q1, interval(y -50  0) by(c)
rename m_count m_count_w50_q1
gen ES_w50_q1=rmdreal_sum_w50_q1/m_count_w50_q1

rangestat (sum) rmdreal if rmdreal <= myquantile_w100_q1, interval(y -100  0) by(c)
rename rmdreal_sum  rmdreal_sum_w100_q1
rangestat (count) m if rmdreal <= myquantile_w100_q1, interval(y -100  0) by(c)
rename m_count m_count_w100_q1
gen ES_w100_q1=rmdreal_sum_w100_q1/m_count_w100_q1

drop rmdreal_sum* m_count*

*** Run quantiles

foreach y in ES_w1 ES_w5 ES_w20 ES_w50 ES_w100 ES_w1_q1 ES_w5_q1 ES_w20_q1 ES_w50_q1 ES_w100_q1{
	gen novol_`y' = rmdreal if rmdreal >= `y'
	replace novol_`y' = rmdreal if `y'==.
	replace novol_`y' = `y' if novol_`y'==.
}
	 mata:
				mata clear
				real rowvector ESquantile(real colvector X) {
					 return(mm_quantile(X, 1, .05))
				}
			end 
			
foreach y of varlist ES_w1 ES_w5 ES_w20 ES_w50 ES_w100 ES_w1_q1 ES_w5_q1 ES_w20_q1 ES_w50_q1 ES_w100_q1 {		
	rangestat (min) novol_`y', interval(y -1  0) by(c)
		rename novol_`y'_min ES_HS_`y'
	drop `y' novol_`y'
}
rename ES_HS_ES_w1 ES_HS_w1
rename ES_HS_ES_w5 ES_HS_w5
rename ES_HS_ES_w20 ES_HS_w20
rename ES_HS_ES_w50 ES_HS_w50
rename ES_HS_ES_w100 ES_HS_w100
rename ES_HS_ES_w1_q1 ES_HS_w1_q1
rename ES_HS_ES_w5_q1 ES_HS_w5_q1
rename ES_HS_ES_w20_q1 ES_HS_w20_q1
rename ES_HS_ES_w50_q1 ES_HS_w50_q1
rename ES_HS_ES_w100_q1 ES_HS_w100_q1


*============= GARCH(1,1) ===============
* Normal distribution
tsset ID tm
quietly summ rmdreal
local n = r(N)
scalar mean = r(mean)
gmm (rmdreal-{mu})((rmdreal-{mu})^2-(`n'-1)/(`n')*{v}) onestep winitial(identity) vce(robust)
nlcom (VaR95: _b[mu:_cons]+sqrt(_b[v:_cons])*invnormal(0.05)) (VaR99: _b[mu:_cons]+sqrt(_b[v:_cons])*invnormal(0.01)), noheader
* Normal distribution
gen ES95_GARCH_Norm=-(-mean+variance_norm^0.5*normalden(invnormal(1-0.05))/0.05)
gen ES99_GARCH_Norm=-(-mean+variance_norm^0.5*normalden(invnormal(1-0.01))/0.05)
* t-distribution
gen ES95_GARCH_t5=-(-mean+variance_t5^0.5*sqrt((5-2)/2)*normalden(invt(5,(1-0.05)))/0.05*(5+t(5,(1-0.05))^2)/(5-1))
gen ES99_GARCH_t5=-(-mean+variance_t5^0.5*sqrt((5-2)/2)*normalden(invt(5,(1-0.01)))/0.01*(5+t(5,(1-0.01))^2)/(5-1))

save "E:\Kiel\Thesis\Estimation\Methodology\Expected Shortfall\ES.dta", replace

*======================================================
*======================= GRAPHICS =====================
*======================================================
***** HS
order rmdreal myquantile* VaRGARCH* ES*
collapse  rmdreal myquantile* VaRGARCH* ES*, by(c tm y m)
egen ID=group(c)
drop if ID==.
drop if rmdreal==.
label var rmdreal "Monthly Return"
label var VaRGARCH95_Norm "VaR GARCH Norm, q5"
label var VaRGARCH99_Norm "VaR GARCH Norm, q1"
label var VaRGARCH95_t5 "VaR GARCH t(5), q5"
label var VaRGARCH99_t5 "VaR GARCH t(5), q1"
label var ES95_GARCH_Norm "ES GARCH Norm, q5"
label var ES99_GARCH_Norm "ES GARCH Norm, q1"
label var ES95_GARCH_t5 "ES GARCH t(5), q5"
label var ES99_GARCH_t5 "ES GARCH t(5), q1"
label var ES_HS_w1 "ES window 1 year, q5"
label var ES_HS_w5 "ES window 5 years, q5"
label var ES_HS_w20 "ES window 20 years, q5"
label var ES_HS_w50 "ES window 50 years, q5"
label var ES_HS_w100 "ES window 100 years, q5"
label var ES_HS_w1_q1 "ES window 1 year, q1"
label var ES_HS_w5_q1 "ES window 5 years, q1"
label var ES_HS_w20_q1 "ES window 20 years, q1"
label var ES_HS_w50_q1 "ES window 50 years, q1"
label var ES_HS_w100_q1 "ES window 100 years, q1"
label var myquantile_w1 "HS window 1 year, q5"
label var myquantile_w5 "HS window 5 years, q5"
label var myquantile_w20 "HS window 20 years, q5"
label var myquantile_w50 "HS window 50 years, q5"
label var myquantile_w100 "HS window 100 years, q5"
label var myquantile_w1_q1 "HS window 1 year, q1"
label var myquantile_w5_q1 "HS window 5 years, q1"
label var myquantile_w20_q1 "HS window 20 years, q1"
label var myquantile_w50_q1 "HS window 50 years, q1"
label var myquantile_w100_q1 "HS window 100 years, q1"
save "E:\Kiel\Thesis\Estimation\Methodology\Expected Shortfall\ES.dta", replace

*============================
*=======      HS      =======
*============================
* 5 years
tsset ID tm
tsfill
 
   
levelsof ID, local(ID)
foreach ID in `r(levels)'{

		#delimit;

			twoway (line rmdreal tm if  ID==`ID', cmissing(n))
					(line myquantile_w5 tm if ID==`ID', cmissing(n)lwidth(medthick))
					(line myquantile_w5_q1 tm if ID==`ID', cmissing(n))
					(line ES_HS_w5 tm if ID==`ID', cmissing(n)lwidth(medthick))
					(line ES_HS_w5_q1 tm if ID==`ID', cmissing(n))
			 , 
			 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
			 title("VaR_HS and ES_HS window 5 years at percentile 5% (q5) and 1% (q1)") 
			 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
			  
		;
		#delimit cr

graph export "E:\Kiel\Thesis\Estimation\Methodology\Expected Shortfall\Graphics\ES-VaR_HS_`ID'.png", as(png) replace

} 





* 50 years
tsset ID tm
tsfill

   
levelsof ID, local(ID)
foreach ID in `r(levels)'{

		#delimit;

			twoway (line rmdreal tm if  ID==`ID', cmissing(n))
					(line myquantile_w50 tm if ID==`ID', cmissing(n)lwidth(medthick))
					(line myquantile_w50_q1 tm if ID==`ID', cmissing(n))
					(line ES_HS_w50 tm if ID==`ID', cmissing(n)lwidth(medthick))
					(line ES_HS_w50_q1 tm if ID==`ID', cmissing(n))
			 , 
			 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
			 title("VaR_HS and ES_HS window 50 years at percentile 5% (q5) and 1% (q1)") 
			 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
			  
		;
		#delimit cr

graph export "E:\Kiel\Thesis\Estimation\Methodology\Expected Shortfall\Graphics\ES-VaR_HS50_`ID'.png", as(png) replace

} 




*========================
*===== Normal GARCH ===== 
*========================
tsset ID tm
tsfill

levelsof ID, local(ID)
foreach ID in `r(levels)'{

		#delimit;

			twoway (line rmdreal tm if  ID==`ID', cmissing(n))
					(line VaRGARCH95_Norm tm if ID==`ID', cmissing(n)lwidth(medthick))
					(line VaRGARCH99_Norm tm if ID==`ID', cmissing(n))
					(line ES95_GARCH_Norm tm if ID==`ID', cmissing(n)lwidth(medthick))
					(line ES99_GARCH_Norm tm if ID==`ID', cmissing(n))
			 , 
			 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
			 title("ES GARCH Norm and VaR GARCH Norm_percentile 5% (q5) and 1% (q1)") 
			 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
			  
		;
		#delimit cr

graph export "E:\Kiel\Thesis\Estimation\Methodology\Expected Shortfall\Graphics\ES-VaR_GARCHNorm_`ID'.png", as(png) replace

} 


** Hungary case
tsfill

#delimit;

	twoway (line rmdreal tm if ID==12, cmissing(n))
			(line VaRGARCH95_Norm tm if ID==12, cmissing(n)lwidth(medthick))
			(line VaRGARCH99_Norm tm if ID==12, cmissing(n))
			(line ES95_GARCH_Norm tm if ID==12, cmissing(n)lwidth(medthick))
			(line ES99_GARCH_Norm tm if ID==12, cmissing(n))

	, 
	 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
	 title("Hungary, ES GARCH and VaR GARCH under normality_percentile 5% (q5) and 1% (q1)") 
	 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
	  
 ;
 #delimit cr
 
 *** Restricted time
 tsfill

#delimit;

	twoway (line rmdreal tm if ID==12 & inrange(y,1930,1970), cmissing(n))
			(line VaRGARCH95_Norm tm if ID==12 & inrange(y,1930,1970), cmissing(n)lwidth(medthick))
			(line VaRGARCH99_Norm tm if ID==12 & inrange(y,1930,1970), cmissing(n))
			(line ES95_GARCH_Norm tm if ID==12 & inrange(y,1930,1970), cmissing(n)lwidth(medthick))
			(line ES99_GARCH_Norm tm if ID==12 & inrange(y,1930,1970), cmissing(n))

	, 
	 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
	 title("Hungary, ES GARCH and VaR GARCH under normality at q5 and q1 in 1930-1970") 
	 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
	  
 ;
 #delimit cr	
 
 *==================================
 *========== t(5) - GARCH ==========
 *==================================
 
tsfill

levelsof ID, local(ID)
foreach ID in `r(levels)'{

		#delimit;

			twoway (line rmdreal tm if  ID==`ID', cmissing(n))
					(line VaRGARCH95_t5 tm if ID==`ID', cmissing(n)lwidth(medthick))
					(line VaRGARCH99_t5 tm if ID==`ID', cmissing(n))
					(line ES95_GARCH_t5 tm if ID==`ID', cmissing(n)lwidth(medthick))
					(line ES99_GARCH_t5 tm if ID==`ID', cmissing(n))
			 , 
			 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
			 title("ES GARCH t(5)_VaR GARCH t(5)_percentile 5% (q5) and 1% (q1)") 
			 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
			  
		;
		#delimit cr

graph export "E:\Kiel\Thesis\Estimation\Methodology\Expected Shortfall\Graphics\ES-VaR_GARCHt5_`ID'.png", as(png) replace

} 


 
 ** Hungary case in 1930-1970
tsfill

#delimit;

	twoway (line rmdreal tm if ID==12 & inrange(y,1930,1970), cmissing(n))
			(line VaRGARCH95_t5 tm if ID==12 & inrange(y,1930,1970), cmissing(n)lwidth(medthick))
			(line VaRGARCH99_t5 tm if ID==12 & inrange(y,1930,1970), cmissing(n))
			(line ES95_GARCH_t5 tm if ID==12 & inrange(y,1930,1970), cmissing(n)lwidth(medthick))
			(line ES99_GARCH_t5 tm if ID==12 & inrange(y,1930,1970), cmissing(n))
	, 
	 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
	 title("Hungary, ES GARCH and VaR GARCH under t-distribution at q5 and q1 in 1930-1970") 
	 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
	  
 ;
 #delimit cr
 
 
 *====== Argentina case ========
 * GARCH Norm
 tsfill

#delimit;

	twoway (line rmdreal tm if ID==1, cmissing(n))
			(line VaRGARCH95_Norm tm if ID==1, cmissing(n)lwidth(medthick))
			(line VaRGARCH99_Norm tm if ID==1, cmissing(n))
			(line ES95_GARCH_Norm tm if ID==1, cmissing(n)lwidth(medthick))
			(line ES99_GARCH_Norm tm if ID==1, cmissing(n))

	, 
	 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
	 title("Argentina, ES GARCH and VaR GARCH under normality_percentile 5% (q5) and 1% (q1)") 
	 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
	  
 ;
 #delimit cr
 
 *** 1930-1970
 tsfill

#delimit;

	twoway (line rmdreal tm if ID==1 & inrange(y,1930,1970), cmissing(n))
			(line VaRGARCH95_Norm tm if ID==1 & inrange(y,1930,1970), cmissing(n)lwidth(medthick))
			(line VaRGARCH99_Norm tm if ID==1 & inrange(y,1930,1970), cmissing(n))
			(line ES95_GARCH_Norm tm if ID==1 & inrange(y,1930,1970), cmissing(n)lwidth(medthick))
			(line ES99_GARCH_Norm tm if ID==1 & inrange(y,1930,1970), cmissing(n))

	, 
	 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
	 title("Argentina, ES GARCH and VaR GARCH under normality at q5 and q1 in 1930-1970") 
	 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
	  
 ;
 #delimit cr
 
 * t-GARCH
tsfill

#delimit;

	twoway (line rmdreal tm if ID==1 & inrange(y,1930,1970), cmissing(n))
			(line VaRGARCH95_t5 tm if ID==1 & inrange(y,1930,1970), cmissing(n)lwidth(medthick))
			(line VaRGARCH99_t5 tm if ID==1 & inrange(y,1930,1970), cmissing(n))
			(line ES95_GARCH_t5 tm if ID==1 & inrange(y,1930,1970), cmissing(n)lwidth(medthick))
			(line ES99_GARCH_t5 tm if ID==1 & inrange(y,1930,1970), cmissing(n))
	, 
	 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
	 title("Argentina, ES GARCH and VaR GARCH under t-distribution at q5 and q1 in 1930-1970") 
	 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
	  
 ;
 #delimit cr


save "E:\Kiel\Thesis\Estimation\Methodology\Expected Shortfall\ES_Graphics.dta", replace















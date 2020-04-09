clear
use "E:\Kiel\Thesis\Estimation\Methodology\Realization\Realization.dta"

*===================== HISTORICAL SIMULATION ============================
**** Portfolio by country
 mata:
			mata clear
            real rowvector myquantile(real colvector X) {
                 return(mm_quantile(X, 1, .05))
            }
        end 
		
	rangestat (myquantile) rmdreal, interval(y -1  0) by(c)
	rename myquantile1 myquantile_w1
    rangestat (myquantile) rmdreal, interval(y -5  0) by(c)
	rename myquantile1 myquantile_w5
	rangestat (myquantile) rmdreal, interval(y -20  0) by(c)
	rename myquantile1 myquantile_w20
	rangestat (myquantile) rmdreal, interval(y -50  0) by(c)
	rename myquantile1 myquantile_w50
	rangestat (myquantile) rmdreal, interval(y -100  0) by(c)
	rename myquantile1 myquantile_w100

label var myquantile_w1 "window 1 year, q5"
label var myquantile_w5 "window 5 years, q5"
label var myquantile_w20 "window 20 years, q5"
label var myquantile_w50 "window 50 years, q5"
label var myquantile_w100 "window 100 years, q5"

	rangestat (myquantile) rmdreal_sa, interval(y -1  0) 
	rename myquantile1 myquantile_sa_w1
    rangestat (myquantile) rmdreal_sa, interval(y -5  0) 
	rename myquantile1 myquantile_sa_w5
	rangestat (myquantile) rmdreal_sa, interval(y -20  0) 
	rename myquantile1 myquantile_sa_w20
	rangestat (myquantile) rmdreal_sa, interval(y -50  0) 
	rename myquantile1 myquantile_sa_w50
	rangestat (myquantile) rmdreal_sa, interval(y -100  0) 
	rename myquantile1 myquantile_sa_w100

label var myquantile_sa_w1 "window 1 year, q5"
label var myquantile_sa_w5 "window 5 years, q5"
label var myquantile_sa_w20 "window 20 years, q5"
label var myquantile_sa_w50 "window 50 years, q5"
label var myquantile_sa_w100 "window 100 years, q5"


* pctile(1)
 mata:
			mata clear
            real rowvector myquantile(real colvector X) {
                return(mm_quantile(X, 1, .01))
            }
        end 
		
	rangestat (myquantile) rmdreal, interval(y -1  0) by(c)
	rename myquantile1 myquantile_w1_q1
    rangestat (myquantile) rmdreal, interval(y -5  0) by(c)
	rename myquantile1 myquantile_w5_q1
	rangestat (myquantile) rmdreal, interval(y -20  0) by(c)
	rename myquantile1 myquantile_w20_q1
	rangestat (myquantile) rmdreal, interval(y -50  0) by(c)
	rename myquantile1 myquantile_w50_q1
	rangestat (myquantile) rmdreal, interval(y -100  0) by(c)
	rename myquantile1 myquantile_w100_q1

label var myquantile_w1_q1 "window 1 year, q1"
label var myquantile_w5_q1 "window 5 years, q1"
label var myquantile_w20_q1 "window 20 years, q1"
label var myquantile_w50_q1 "window 50 years, q1"
label var myquantile_w100_q1 "window 100 years, q1"

	rangestat (myquantile) rmdreal_sa, interval(y -1  0) 
	rename myquantile1 myquantile_sa_w1_q1
    rangestat (myquantile) rmdreal_sa, interval(y -5  0) 
	rename myquantile1 myquantile_sa_w5_q1
	rangestat (myquantile) rmdreal_sa, interval(y -20  0) 
	rename myquantile1 myquantile_sa_w20_q1
	rangestat (myquantile) rmdreal_sa, interval(y -50  0) 
	rename myquantile1 myquantile_sa_w50_q1
	rangestat (myquantile) rmdreal_sa, interval(y -100  0) 
	rename myquantile1 myquantile_sa_w100_q1

label var myquantile_sa_w1_q1 "window 1 year, q1"
label var myquantile_sa_w5_q1 "window 5 year, q1"
label var myquantile_sa_w20_q1 "window 20 year, q1"
label var myquantile_sa_w50_q1 "window 50 year, q1"
label var myquantile_sa_w100_q1 "window 100 year, q1"

save "E:\Kiel\Thesis\Estimation\Methodology\HistSim\VaR_HistSim.dta", replace
*====================================================
*=						STATISTICS					=
*====================================================
cd"E:\Kiel\Thesis\Estimation\Methodology\HistSim"
bys c: asdoc tabstat myquantile*,  stat(skewness kurtosis) dec(5) save(HS) replace 
bys c: asdoc summ myquantile*, save(HS_sum) dec(5) detail replace

*====================================================
*=						GRAPHICS 					=
*====================================================
cd "E:\Kiel\Thesis\Estimation\Methodology\HistSim\Graphics"

order rmdreal myquantile*
collapse  rmdreal myquantile*, by(c tm y m)
egen ID=group(c)
drop if ID==.
drop if rmdreal==.

label var rmdreal "Monthly Return"
label var myquantile_w1 "Window 1 year, q5"
label var myquantile_w5 "Window 5 years, q5"
label var myquantile_w20 "Window 20 years, q5"
label var myquantile_w50 "Window 50 years, q5"
label var myquantile_w100 "Window 100 years, q5"

label var myquantile_sa_w1 "Window 1 year, q5"
label var myquantile_sa_w5 "Window 5 years, q5"
label var myquantile_sa_w20 "Window 20 years, q5"
label var myquantile_sa_w50 "Window 50 years, q5"
label var myquantile_sa_w100 "Window 100 years, q5"

label var myquantile_w1_q1 "Window 1 year, q1"
label var myquantile_w5_q1 "Window 5 years, q1"
label var myquantile_w20_q1 "Window 20 years, q1"
label var myquantile_w50_q1 "Window 50 years, q1"
label var myquantile_w100_q1 "Window 100 years, q1"

label var myquantile_sa_w1_q1 "Window 1 year, q1"
label var myquantile_sa_w5_q1 "Window 5 years, q1"
label var myquantile_sa_w20_q1 "Window 20 years, q1"
label var myquantile_sa_w50_q1 "Window 50 years, q1"
label var myquantile_sa_w100_q1 "Window 100 years, q1"

label var rmdreal "Monthly return"

* Whole time series
drop if ID==.
drop if rmdreal==.

***** Portfolio by country
tsset ID tm
tsfill
bys ID (tm): carryforward c, replace
gsort ID -tm
levelsof ID, local(ID)
foreach ID in `r(levels)'{

		#delimit;

			twoway (line rmdreal tm if  ID==`ID', cmissing(n))
					(line myquantile_w1 tm if  ID==`ID', cmissing(n)lwidth(medthick))
					(line myquantile_w5 tm if ID==`ID', cmissing(n))
					(line myquantile_w1_q1 tm if ID==`ID', cmissing(n)lwidth(medthick))
					(line myquantile_w5_q1 tm if ID==`ID', cmissing(n))
			 , 
			 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
			 title("VaR HS_percentile 5% (q5) and 1% (q1)") 
			 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
			  
		;
		#delimit cr

graph export "E:\Kiel\Thesis\Estimation\Methodology\HistSim\Graphics\VaR_HistSim_`ID'.png", as(png) replace

} 


levelsof ID, local(ID)
foreach ID in `r(levels)'{

		#delimit;

			twoway (line rmdreal tm if  ID==`ID', cmissing(n))
					(line myquantile_w5 tm if  ID==`ID', cmissing(n)lwidth(medthick))
					(line myquantile_w50 tm if ID==`ID', cmissing(n))
					(line myquantile_w5_q1 tm if ID==`ID', cmissing(n)lwidth(medthick))
					(line myquantile_w50_q1 tm if ID==`ID', cmissing(n))
			 , 
			 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
			 title("VaR HS_percentile 5% (q5) and 1% (q1)") 
			 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
			  
		;
		#delimit cr

graph export "E:\Kiel\Thesis\Estimation\Methodology\HistSim\Graphics\VaR_HistSim50_`ID'.png", as(png) replace

} 


*** Argentina case - sample in paper
tsset ID tm
tsfill

#delimit;

	twoway (line rmdreal tm if ID==1, cmissing(n))
			(line myquantile_w1 tm if ID==1, cmissing(n)lwidth(medthick))
			(line myquantile_w5 tm if ID==1, cmissing(n))
			(line myquantile_w1_q1 tm if ID==1, cmissing(n)lwidth(medthick))
			(line myquantile_w5_q1 tm if ID==1, cmissing(n))

	, 
	 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
	 title("Argentina, HS VaR_percentile 5% (q5) and 1% (q1)") 
	 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
	  
 ;
 #delimit cr
 
 *** Argentina case - sample in paper 1920-1950
 ** Window 1 year and 5 years
tsset ID tm
tsfill

#delimit;

	twoway (line rmdreal tm if ID==1 & inrange(y,1920,1950), cmissing(n))
			(line myquantile_w1 tm if ID==1 & inrange(y,1920,1950), cmissing(n)lwidth(medthick))
			(line myquantile_w5 tm if ID==1 & inrange(y,1920,1950), cmissing(n))
			(line myquantile_w1_q1 tm if ID==1 & inrange(y,1920,1950), cmissing(n)lwidth(medthick))
			(line myquantile_w5_q1 tm if ID==1 & inrange(y,1920,1950), cmissing(n))

	, 
	 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
	 title("Argentina, HS VaR_percentile 5% (q5) and 1% (q1) in 1920-1950") 
	 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
	  
 ;
 #delimit cr

** Window 5 years and 50 years
tsset ID tm
tsfill

#delimit;

	twoway (line rmdreal tm if ID==1 & inrange(y,1920,1950), cmissing(n))
			(line myquantile_w5 tm if ID==1 & inrange(y,1920,1950), cmissing(n)lwidth(medthick))
			(line myquantile_w50 tm if ID==1 & inrange(y,1920,1950), cmissing(n))
			(line myquantile_w5_q1 tm if ID==1 & inrange(y,1920,1950), cmissing(n)lwidth(medthick))
			(line myquantile_w50_q1 tm if ID==1 & inrange(y,1920,1950), cmissing(n))

	, 
	 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
	 title("Argentina, HS VaR_percentile 5% (q5) and 1% (q1) in 1920-1950") 
	 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
	  
 ;
 #delimit cr

			

save "E:\Kiel\Thesis\Estimation\Methodology\HistSim\VaR_HistSim_graphics.dta", replace

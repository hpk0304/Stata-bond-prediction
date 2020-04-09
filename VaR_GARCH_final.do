clear
use "E:\Kiel\Thesis\Estimation\Methodology\Realization\Realization.dta"

*====================== VARGARCH ========================
*============= variance and mean ==========
** Normal - GARCH(1,1) model (univariate theme) 
tsset ID tm
quietly summ rmdreal
local n = r(N)
scalar mean = r(mean)
gmm (rmdreal-{mu})((rmdreal-{mu})^2-(`n'-1)/(`n')*{v}) onestep winitial(identity) vce(robust)
nlcom (VaR95: _b[mu:_cons]+sqrt(_b[v:_cons])*invnormal(0.05)) (VaR99: _b[mu:_cons]+sqrt(_b[v:_cons])*invnormal(0.01)), noheader
arch rmdreal, arch(1) garch(1) 
predict variance, variance
gen VaRGARCH95_Norm = -mean+variance^0.5*invnormal(0.05)
gen VaRGARCH99_Norm = -mean+variance^0.5*invnormal(0.01)
rename variance variance_norm

label var VaRGARCH95_Norm "VaR GARCH 5%"
label var VaRGARCH99_Norm "VaR GARCH 1%"

** t-distribution with degree of freedom v=5   
quietly summ rmdreal
local n = r(N)
scalar mean = r(mean)
gmm (rmdreal-{mu})((rmdreal-{mu})^2-(`n'-1)/(`n')*{v}) onestep winitial(identity) vce(robust)
nlcom (VaR95: _b[mu:_cons]+sqrt(_b[v:_cons])*invt(5,0.05)) (VaR99: _b[mu:_cons]+sqrt(_b[v:_cons])*invt(5,0.01)), noheader
arch rmdreal, arch(1) garch(1) distribution(t) nolog
predict variance, variance
gen VaRGARCH95_t5 = -mean+variance^0.5*invt(5,0.05)*sqrt((5-2)/2) 
gen VaRGARCH99_t5 = -mean+variance^0.5*invt(5,0.01)*sqrt((5-2)/2)
rename variance variance_t5

save "E:\Kiel\Thesis\Estimation\Methodology\VaRGARCH\VaR_GARCH.dta", replace

*============= GRAPHICS ===============
order  rmdreal VaRGARCH95_Norm VaRGARCH99_Norm VaRGARCH95_t5 VaRGARCH99_t5
collapse  rmdreal VaRGARCH95_Norm VaRGARCH99_Norm VaRGARCH95_t5 VaRGARCH99_t5, by(c tm y m)
egen ID=group(c)
ed if ID==.
drop if ID==.
drop if rmdreal==.

label var rmdreal "Monthly return"
label var VaRGARCH95_Norm "VaR GARCH Norm, q5"
label var VaRGARCH99_Norm "VaR GARCH Norm, q1"
label var VaRGARCH95_t5 "VaR GARCH t(5), q5"
label var VaRGARCH99_t5 "VaR GARCH t(5), q1"

bys ID (tm): carryforward c, replace
gsort ID -tm

***** Portfolio by country
tsset ID tm
bys ID (tm): carryforward c, replace
gsort ID -tm
tsfill

levelsof ID, local(ID)
foreach ID in `r(levels)'{

		#delimit;

			twoway (line rmdreal tm if  ID==`ID', cmissing(n))
					(line VaRGARCH95_Norm tm if  ID==`ID', cmissing(n)lwidth(medthick))
					(line VaRGARCH99_Norm tm if ID==`ID', cmissing(n))
					(line VaRGARCH95_t5 tm if ID==`ID', cmissing(n)lwidth(medthick))
					(line VaRGARCH99_t5 tm if ID==`ID', cmissing(n))
			 , 
			 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) xtitle("")
			 title("VaR GARCH_percentile 5% (q5) and 1% (q1)") 
			 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
			  
		;
		#delimit cr

graph export "E:\Kiel\Thesis\Estimation\Methodology\VaRGARCH\Graphics\VaR_GARCH_`ID'.png", as(png) replace

} 


*** Hungary case - sample in paper
tsset ID tm
tsfill
bys ID (tm): carryforward c, replace
gsort ID -tm

 #delimit;

	twoway (line rmdreal tm if  ID==12 & inrange(y,1930,1970), cmissing(n))
			(line VaRGARCH95_Norm tm if  ID==12, cmissing(n)lwidth(medthick))
			(line VaRGARCH99_Norm tm if ID==12, cmissing(n))
			(line VaRGARCH95_t5 tm if ID==12, cmissing(n)lwidth(medthick))
			(line VaRGARCH99_t5 tm if ID==12, cmissing(n))
	 , 
	 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) 
	 title("Hungary, VaR GARCH t(5)_percentile 5% (q5) and 1% (q1) in 1930-1970") 
	 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
  
;
#delimit cr 

*** Hungary case - sample in paper in 1930-1970
** Normal distribution
 #delimit;

	twoway (line rmdreal tm if  ID==12 & inrange(y,1930,1970), cmissing(n))
			(line VaRGARCH95_Norm tm if  ID==12 & inrange(y,1930,1970), cmissing(n)lwidth(medthick))
			(line VaRGARCH99_Norm tm if ID==12 & inrange(y,1930,1970), cmissing(n))
	 , 
	 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) 
	 title("Hungary, VaR GARCH_percentile 5% (q5) and 1% (q1) in 1930-1970") 
	 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
  
;
#delimit cr 

** t(5) distribution
 #delimit;

	twoway (line rmdreal tm if  ID==12 & inrange(y,1930,1970), cmissing(n))
			(line VaRGARCH95_t5 tm if ID==12 & inrange(y,1930,1970), cmissing(n)lwidth(medthick))
			(line VaRGARCH99_t5 tm if ID==12 & inrange(y,1930,1970), cmissing(n))
	 , 
	 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) 
	 title("Hungary, VaR GARCH_percentile 5% (q5) and 1% (q1) in 1930-1970") 
	 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
  
;
#delimit cr

** Comparison Normal and t-distribution
 #delimit;

	twoway (line rmdreal tm if  ID==12 & inrange(y,1930,1970), cmissing(n))
			(line VaRGARCH95_Norm tm if  ID==12 & inrange(y,1930,1970), cmissing(n)lwidth(medthick))
			(line VaRGARCH99_Norm tm if ID==12 & inrange(y,1930,1970), cmissing(n))
			(line VaRGARCH95_t5 tm if ID==12 & inrange(y,1930,1970), cmissing(n)lwidth(medthick))
			(line VaRGARCH99_t5 tm if ID==12 & inrange(y,1930,1970), cmissing(n))
	 , 
	 xsize(20.000) xlabel(#5,format(%tmCY )) ysize(10.000) 
	 title("Hungary, VaR GARCH_percentile 5% (q5) and 1% (q1) in 1930-1970") 
	 legend(rows(3) rowgap(*0.0001) bmargin(tiny) size(medlarge) symysize(*.5) symxsize(*.5) region(color(white)))
  
;
#delimit cr 


save "E:\Kiel\Thesis\Estimation\Methodology\VaRGARCH\VaR_GARCH_graphics.dta", replace

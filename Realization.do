clear
use "E:\Kiel\Thesis\Estimation\master sample stat13_Origin.dta"

*=========================================================
*============= CONSTRUCT PORTFOLIO RETURNS ===============
*=========================================================
drop if c=="safe asset"
format ID %-9.0g
format c %-25s
keep c ID tm rdreal rdrealy name desc1 DebtName issuey maturityy amtISS* currency y m 
label var m "month"
label var y "year"
label var c "country"
label var rdrealy "Annual Return"
replace c="NewZealand" if c=="New Zealand"

**********************************
**       SELECT COUNTRIES       **
**********************************
bysort c: gen freq=_N
drop if freq < 2496

*Seperate default and not-defaulted
gen default=.
replace default=0 if c=="Australia"|c== "Belgium"|c=="Canada"|c=="New Zealand"| c=="Sweden"
replace default=1 if default==.

* Annual returns
tsset ID tm
sort ID tm  
bys ID y: egen lrdrealy = sum( ln( rdreal + 1 ) )
replace rdrealy = exp( lrdrealy ) - 1

**************************************
**       PORTFOLIO BY COUNTRY       **
**************************************
* Weights
bys c y m: egen totalweight=sum(amtISSUSD) 
gen weight_per_bond = amtISSUSD / totalweight

* Weighted returns
gen rmdreal_weighted_bond = rdreal * weight_per_bond 
gen rydreal_weighted_bond = rdrealy * weight_per_bond 

* Portfolio returns
bys c y m: egen rmdreal = total(rmdreal_weighted_bond), missing 
bys c y m: egen rydreal= total(rydreal_weighted_bond), missing 

*cd"E:\Kiel\Thesis\Estimation\Methodology\Realization\Statistics"
*bys c: asdoc tabstat rmdreal ,  stat(skewness kurtosis) dec(5) save(ske_kur_po)
*bys c: asdoc summ rmdreal, save(Statistics_po) dec(5) detail 

*************************************
**       PORTFOLIO BY GLOBAL       **
*************************************
* Weights
bys y m: egen totalweight_c = sum(amtISSUSD) 
gen weight_per_c = amtISSUSD / totalweight_c

* Weighted returns
gen rmdreal_weighted_c = rdreal * weight_per_c
gen rydreal_weighted_c = rdrealy * weight_per_c
bys y m: egen rmdreal_sa = total(rmdreal_weighted_c), missing
bys y m: egen  rydreal_sa = total(rydreal_weighted_c), missing

bys c: asdoc tabstat rmdreal,  stat(skewness kurtosis) dec(5) save(ske_kur_po) replace 
bys c: asdoc summ rmdreal, save(Statistics_po) dec(5) detail replace

*cd"E:\Kiel\Thesis\Estimation\Methodology\Realization\Statistics"
*asdoc tabstat rmdreal_sa rydreal_sa,  stat(skewness kurtosis) dec(5) save(ske_kur_sapo) replace 
*asdoc summ rmdreal_sa rydreal_sa, save(Statistics_sapo) dec(5) detail replace

label var rmdreal_sa "Monthly Sample Portfolio"
label var rydreal_sa "Yearly Sample Portfolio"
label var rmdreal "Monthly Portfolio"
label var rydreal "Yearly Portfolio"


***=======Graphs============
cd"E:\Kiel\Thesis\Estimation\Methodology\Realization\Graphics"	
histogram rmdreal_sa, normal normopts(lcolor(red)) kdensity kdenopts(lcolor(navy) width(0.001)) name(Monthly_Portfolio)	
histogram rydreal_sa, normal normopts(lcolor(red)) kdensity kdenopts(lcolor(black) width(0.01)) name(Yearly_Portfolio)
graph combine Monthly_Portfolio.gph Yearly_Portfolio.gph, xsize(20.000) ysize(10.000) title("Returns")

quantile rmdreal_sa
quantile rydreal_sa
graph combine quantile_monthly.gph quantile_yearly.gph, xsize(20.000) ysize(10.000) title("Quantiles")


twoway (tsline rmdreal_sa), xsize(20.000) xlabel(#5,format(%tmCY )) ysize(8.000) ytitle("Monthly Sample Portfolio Return", size(large))
twoway (tsline rydreal_sa), xsize(20.000) xlabel(#5,format(%tmCY )) ysize(8.000) ytitle("Monthly Sample Portfolio Return", size(large))



save"E:\Kiel\Thesis\Estimation\Methodology\Realization\Realization.dta", replace







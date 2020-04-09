# Stata-Check the outliers with Value-at-Risk (VaR) models
## Thesis: Testing VaR models on long-run Sovereign bond data
In the face of current chaos in finance, risk management is an urgent requirement in controlling losses. This thesis shed light on testing VaR model on monthly Sovereign bond data over 200 years. The main contents compare performance of one-day prediction of 25 selected portfolios via three methods – Historical Simulation (Engle and Manganelli (2001)), GARCH(1,1) (Robert Eagle (1982)) and Expected Shortfall (Artzner et al. (1997)). Remarkably, performance is evaluated by Kupiec test, Independence test and Conditional Coverage test, named shortly as Back-testing. After testing, Historical Simulation and Expected Shortfall of Historical Simulation are most effective. Besides, Normal GARCH(1,1) and ES Normal GARCH(1,1) are also potential. However, a persistent model applied throughout time should be carefully considered, especially in crisis. As regards GARCH(1,1), tested normal distribution works surprisingly better than Student-t. Last but not least, 1% percentile is more effective than 5% percentile in most approaches.

**Keywords:** Value-at-Risk; Sovereign bond; long-run; Historical Simulation; GARCH(1,1); Expected Shortfall; Back-testing

**Support:** risk management, portfolio optimization

### Data source: 
Meyer et. al (2018) with project "200 years of Sovereign Haircuts and Bond Returns", solve 25/91 single portfolios

Excel and Stata files contain the bondId (ID), Name, Country (c), issue date (issuey), maturity date (maturityy), monthly return (rdrealy), amount of issue (amtISS), currency, year y and month m

## EDA (Explore Data Analysis) and Data Wrangling
clear
use "E:\Kiel\Thesis\Estimation\master sample stat13_Origin.dta"

####CONSTRUCT PORTFOLIO RETURNS
**Clean the data

_The target to get the countries to build up the portfolio; therefore, the safe asset should be removed_
drop if c=="safe asset" 
format ID %-9.0g
format c %-25s
_Keep the useful variables and delete all irrelevant variables_
keep c ID tm rdreal rdrealy name desc1 DebtName issuey maturityy amtISS* currency y m 
_label the variables and correct some spelling mistakes in original files
label var m "month"
label var y "year"
label var c "country"
label var rdrealy "Annual Return"
replace c="NewZealand" if c=="New Zealand"

**Select the countries **

*_Choose the countries with high frequencies in returns_*
bysort c: gen freq=_N
drop if freq < 2496

_Seperate default and not-defaulted_
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

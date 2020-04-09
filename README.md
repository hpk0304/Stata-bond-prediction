# Stata-Check the outliers with Value-at-Risk (VaR) models
## Thesis: Testing VaR models on long-run Sovereign bond data
In the face of current chaos in finance, risk management is an urgent requirement in controlling losses. This thesis shed light on testing VaR model on monthly Sovereign bond data over 200 years. The main contents compare performance of one-day prediction of 25 selected portfolios via three methods – Historical Simulation (Engle and Manganelli (2001)), GARCH(1,1) (Robert Eagle (1982)) and Expected Shortfall (Artzner et al. (1997)). Remarkably, performance is evaluated by Kupiec test, Independence test and Conditional Coverage test, named shortly as Back-testing. After testing, Historical Simulation and Expected Shortfall of Historical Simulation are most effective. Besides, Normal GARCH(1,1) and ES Normal GARCH(1,1) are also potential. However, a persistent model applied throughout time should be carefully considered, especially in crisis. As regards GARCH(1,1), tested normal distribution works surprisingly better than Student-t. Last but not least, 1% percentile is more effective than 5% percentile in most approaches.

**Keywords:** Value-at-Risk; Sovereign bond; long-run; Historical Simulation; GARCH(1,1); Expected Shortfall; Back-testing

**Support:** risk management, portfolio optimization

### Data source: 
Meyer et. al (2018) with project "200 years of Sovereign Haircuts and Bond Returns", solve 25/91 single portfolios

Excel and Stata files contain the bondId (ID), Name, Country (c), issue date (issuey), maturity date (maturityy), monthly return (rdrealy), amount of issue (amtISS), currency, year y and month m

## EDA (Explore Data Analysis) and Data Wrangling
#### 1. CONSTRUCT PORTFOLIO RETURNS

**Clean the data (details in Realization.do file)**

**Contruct portfolio by country (Examples)**
```
# Weights are calculated by division between the amount of each bond and the total amount of a country
bys c y m: egen totalweight=sum(amtISSUSD) 
gen weight_per_bond = amtISSUSD / totalweight

# Weighted returns
gen rmdreal_weighted_bond = rdreal * weight_per_bond 
gen rydreal_weighted_bond = rdrealy * weight_per_bond 

# Portfolio returns
bys c y m: egen rmdreal = total(rmdreal_weighted_bond), missing 
bys c y m: egen rydreal= total(rydreal_weighted_bond), missing 
```

**Visualization (Examples)**
```
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
```

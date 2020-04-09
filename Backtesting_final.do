clear
use "E:\Kiel\Thesis\Estimation\Methodology\Expected Shortfall\ES.dta"


* UNCONDITIONAL COVERAGE TEST
** Bernoulli test: Ho: alpha = VaR with p = VaR, 1-p = confidence interval
*===============================================
*=========== HISTORICAL SIMULATION =============
*===============================================
cd"E:\Kiel\Thesis\Estimation\Methodology\Backtesting"
* Generate violation
quietly summ rmdreal
gen HS95_w1 = rmdreal  < myquantile_w1
gen HS99_w1 = rmdreal  < myquantile_w1_q1
gen HS95_w5 = rmdreal  < myquantile_w5
gen HS99_w5 = rmdreal  < myquantile_w5_q1
gen HS95_w20 = rmdreal  < myquantile_w20
gen HS99_w20 = rmdreal  < myquantile_w20_q1
gen HS95_w50 = rmdreal  < myquantile_w50
gen HS99_w50 = rmdreal  < myquantile_w50_q1
gen HS95_w100 = rmdreal  < myquantile_w100
gen HS99_w100 = rmdreal  < myquantile_w100_q1

gen GA_n95 = rmdreal  < VaRGARCH95_Norm
gen GA_n99 = rmdreal  < VaRGARCH99_Norm
gen GA_t95 = rmdreal  < VaRGARCH95_t5
gen GA_t99 = rmdreal  < VaRGARCH99_t5

gen ES_HS95_w1 = rmdreal  < myquantile_w1
gen ES_HS99_w1 = rmdreal  < myquantile_w1_q1
gen ES_HS95_w5 = rmdreal  < myquantile_w5
gen ES_HS99_w5 = rmdreal  < myquantile_w5_q1
gen ES_HS95_w20 = rmdreal  < myquantile_w20
gen ES_HS99_w20 = rmdreal  < myquantile_w20_q1
gen ES_HS95_w50 = rmdreal  < myquantile_w50
gen ES_HS99_w50 = rmdreal  < myquantile_w50_q1
gen ES_HS95_w100 = rmdreal  < myquantile_w100
gen ES_HS99_w100 = rmdreal  < myquantile_w100_q1

gen ES_GA_n95 = rmdreal  < VaRGARCH95_Norm
gen ES_GA_n99 = rmdreal  < VaRGARCH99_Norm
gen ES_GA_t95 = rmdreal  < VaRGARCH95_t5
gen ES_GA_t99 = rmdreal  < VaRGARCH99_t5
*asdoc summ rmdreal HS95* HS99*, save(TestHist) dec(5) replace
save "E:\Kiel\Thesis\Estimation\Methodology\Backtesting\Backtesting.dta", replace

order rmdreal HS* GA* ES*
collapse  rmdreal HS* GA* ES*, by(c tm y m)
egen ID=group(c)
drop if ID==.
drop if rmdreal==.

save "E:\Kiel\Thesis\Estimation\Methodology\Backtesting\Backtesting_UC.dta", replace

gen interval = 1-0.95
levelsof ID, local(ID)
foreach var of varlist HS95* GA_n95 GA_t95 ES_HS95* ES_GA_n95 ES_GA_t95 {
	bys ID: egen T1_`var' = total(`var')
	bys ID: egen T_`var' = count(`var') 
	gen ratio_`var' = T1_`var'/T_`var' 
	gen lluc_emp_`var' = (T_`var'-T1_`var')*log(1-ratio_`var')+T1_`var'*log(ratio_`var')
	gen lluc_theo_`var' = (T_`var'-T1_`var')*log(1-interval)+T1_`var'*log(interval) 
	gen LRuc_`var' = -2*(lluc_theo_`var' - lluc_emp_`var')
	}
	
bysort c: gen a=_n
drop if a>1
export excel c T_HS95_w1 T1_HS95_w1 ratio_HS95_w1 LRuc_HS95_w1 T1_HS95_w5 ratio_HS95_w5 LRuc_HS95_w5 T1_HS95_w20 ratio_HS95_w20 LRuc_HS95_w20 T1_HS95_w50 ratio_HS95_w50 LRuc_HS95_w50 T1_HS95_w100 ratio_HS95_w100 LRuc_HS95_w100 T1_GA_n95 ratio_GA_n95 LRuc_GA_n95 T1_GA_t95 ratio_GA_t95 LRuc_GA_t95 T1_ES_HS95_w1 ratio_ES_HS95_w1 LRuc_ES_HS95_w1 T1_ES_HS95_w5 ratio_ES_HS95_w5 LRuc_ES_HS95_w5 T1_ES_HS95_w20 ratio_ES_HS95_w20 LRuc_ES_HS95_w20 T1_ES_HS95_w50 ratio_ES_HS95_w50 LRuc_ES_HS95_w50 T1_ES_HS95_w100 ratio_ES_HS95_w100 LRuc_ES_HS95_w100 T1_ES_GA_n95 ratio_ES_GA_n95 LRuc_ES_GA_n95 T1_ES_GA_t95 ratio_ES_GA_t95 LRuc_ES_GA_t95 using "E:\Kiel\Thesis\Estimation\Methodology\Backtesting\Backtesting_Kupiec95.xlsx", firstrow(variables)

clear 
use "E:\Kiel\Thesis\Estimation\Methodology\Backtesting\Backtesting_UC.dta"
gen interval_1 = 1-0.99
levelsof ID, local(ID)
foreach var of varlist HS99* GA_n99 GA_t99 ES_HS99* ES_GA_n99 ES_GA_t99 {
	bys ID: egen T1_`var' = total(`var')
	bys ID: egen T_`var' = count(`var') 
	gen ratio_`var' = T1_`var'/T_`var' 
	gen lluc_emp_`var' = (T_`var'-T1_`var')*log(1-ratio_`var')+T1_`var'*log(ratio_`var')
	gen lluc_theo_`var' = (T_`var'-T1_`var')*log(1-interval_1)+T1_`var'*log(interval_1) 
	gen LRuc_`var' = -2*(lluc_theo_`var' - lluc_emp_`var')
	}
	
bysort c: gen b=_n
drop if b>1
export excel c T_HS99_w1 T1_HS99_w1 ratio_HS99_w1 LRuc_HS99_w1 T1_HS99_w5 ratio_HS99_w5 LRuc_HS99_w5 T1_HS99_w20 ratio_HS99_w20 LRuc_HS99_w20 T1_HS99_w50 ratio_HS99_w50 LRuc_HS99_w50 T1_HS99_w100 ratio_HS99_w100 LRuc_HS99_w100 T1_GA_n99 ratio_GA_n99 LRuc_GA_n99 T1_GA_t99 ratio_GA_t99 LRuc_GA_t99 T1_ES_HS99_w1 ratio_ES_HS99_w1 LRuc_ES_HS99_w1 T1_ES_HS99_w5 ratio_ES_HS99_w5 LRuc_ES_HS99_w5 T1_ES_HS99_w20 ratio_ES_HS99_w20 LRuc_ES_HS99_w20 T1_ES_HS99_w50 ratio_ES_HS99_w50 LRuc_ES_HS99_w50 T1_ES_HS99_w100 ratio_ES_HS99_w100 LRuc_ES_HS99_w100 T1_ES_GA_n99 ratio_ES_GA_n99 LRuc_ES_GA_n99 T1_ES_GA_t99 ratio_ES_GA_t99 LRuc_ES_GA_t99 using "E:\Kiel\Thesis\Estimation\Methodology\Backtesting\Backtesting_Kupiec99.xlsx", firstrow(variables)

*summ vio* 
*asdoc summ vio*

*=================================
* 		INDEPENDENCE TEST		 *
*=================================
clear 
use "E:\Kiel\Thesis\Estimation\Methodology\Backtesting\Backtesting.dta"

gen HS9501_w1=(HS95_w1[_n-1]==0 & HS95_w1==1)
gen HS9511_w1=(HS95_w1[_n-1]==1 & HS95_w1==1)
gen HS9901_w1=(HS99_w1[_n-1]==0 & HS99_w1==1)
gen HS9911_w1=(HS99_w1[_n-1]==1 & HS99_w1==1)

gen HS9501_w5=(HS95_w5[_n-1]==0 & HS95_w5==1)
gen HS9511_w5=(HS95_w5[_n-1]==1 & HS95_w5==1)
gen HS9901_w5=(HS99_w5[_n-1]==0 & HS99_w5==1)
gen HS9911_w5=(HS99_w5[_n-1]==1 & HS99_w5==1)

gen HS9501_w20=(HS95_w20[_n-1]==0 & HS95_w20==1)
gen HS9511_w20=(HS95_w20[_n-1]==1 & HS95_w20==1)
gen HS9901_w20=(HS99_w20[_n-1]==0 & HS99_w20==1)
gen HS9911_w20=(HS99_w20[_n-1]==1 & HS99_w20==1)

gen HS9501_w50=(HS95_w50[_n-1]==0 & HS95_w50==1)
gen HS9511_w50=(HS95_w50[_n-1]==1 & HS95_w50==1)
gen HS9901_w50=(HS99_w50[_n-1]==0 & HS99_w50==1)
gen HS9911_w50=(HS99_w50[_n-1]==1 & HS99_w50==1)

gen HS9501_w100=(HS95_w100[_n-1]==0 & HS95_w100==1)
gen HS9511_w100=(HS95_w100[_n-1]==1 & HS95_w100==1)
gen HS9901_w100=(HS99_w100[_n-1]==0 & HS99_w100==1)
gen HS9911_w100=(HS99_w100[_n-1]==1 & HS99_w100==1)

gen GA01_n95=(GA_n95[_n-1]==0 & GA_n95==1)
gen GA11_n95=(GA_n95[_n-1]==1 & GA_n95==1)
gen GA01_n99=(GA_n99[_n-1]==0 & GA_n99==1)
gen GA11_n99=(GA_n99[_n-1]==1 & GA_n99==1)

gen GA01_t95=(GA_t95[_n-1]==0 & GA_t95==1)
gen GA11_t95=(GA_t95[_n-1]==1 & GA_t95==1)
gen GA01_t99=(GA_t99[_n-1]==0 & GA_t99==1)
gen GA11_t99=(GA_t99[_n-1]==1 & GA_t99==1)

*ES 
gen ES01_HS95_w1=(ES_HS95_w1[_n-1]==0 & ES_HS95_w1==1)
gen ES11_HS95_w1=(ES_HS95_w1[_n-1]==1 & ES_HS95_w1==1)
gen ES01_HS99_w1=(ES_HS99_w1[_n-1]==0 & ES_HS99_w1==1)
gen ES11_HS99_w1=(ES_HS99_w1[_n-1]==1 & ES_HS99_w1==1)

gen ES01_HS95_w5=(ES_HS95_w5[_n-1]==0 & ES_HS95_w5==1)
gen ES11_HS95_w5=(ES_HS95_w5[_n-1]==1 & ES_HS95_w5==1)
gen ES01_HS99_w5=(ES_HS99_w5[_n-1]==0 & ES_HS99_w5==1)
gen ES11_HS99_w5=(ES_HS99_w5[_n-1]==1 & ES_HS99_w5==1)

gen ES01_HS95_w20=(ES_HS95_w20[_n-1]==0 & ES_HS95_w20==1)
gen ES11_HS95_w20=(ES_HS95_w20[_n-1]==1 & ES_HS95_w20==1)
gen ES01_HS99_w20=(ES_HS99_w20[_n-1]==0 & ES_HS99_w20==1)
gen ES11_HS99_w20=(ES_HS99_w20[_n-1]==1 & ES_HS99_w20==1)

gen ES01_HS95_w50=(ES_HS95_w50[_n-1]==0 & ES_HS95_w50==1)
gen ES11_HS95_w50=(ES_HS95_w50[_n-1]==1 & ES_HS95_w50==1)
gen ES01_HS99_w50=(ES_HS99_w50[_n-1]==0 & ES_HS99_w50==1)
gen ES11_HS99_w50=(ES_HS99_w50[_n-1]==1 & ES_HS99_w50==1)

gen ES01_HS95_w100=(ES_HS95_w100[_n-1]==0 & ES_HS95_w100==1)
gen ES11_HS95_w100=(ES_HS95_w100[_n-1]==1 & ES_HS95_w100==1)
gen ES01_HS99_w100=(ES_HS99_w100[_n-1]==0 & ES_HS99_w100==1)
gen ES11_HS99_w100=(ES_HS99_w100[_n-1]==1 & ES_HS99_w100==1)

gen ES01_GA_n95=(ES_GA_n95[_n-1]==0 & ES_GA_n95==1)
gen ES11_GA_n95=(ES_GA_n95[_n-1]==1 & ES_GA_n95==1)
gen ES01_GA_n99=(ES_GA_n99[_n-1]==0 & ES_GA_n99==1)
gen ES11_GA_n99=(ES_GA_n99[_n-1]==1 & ES_GA_n99==1)

gen ES01_GA_t95=(ES_GA_t95[_n-1]==0 & ES_GA_t95==1)
gen ES11_GA_t95=(ES_GA_t95[_n-1]==1 & ES_GA_t95==1)
gen ES01_GA_t99=(ES_GA_t99[_n-1]==0 & ES_GA_t99==1)
gen ES11_GA_t99=(ES_GA_t99[_n-1]==1 & ES_GA_t99==1)

order rmdreal HS9501* HS9511* HS9901* HS9911* GA01* GA11* ES01* ES11*
collapse  rmdreal HS9501* HS9511* HS9901* HS9911* GA01* GA11* ES01* ES11*, by(c tm y m)
egen ID=group(c)
drop if ID==.
drop if rmdreal==.
save "E:\Kiel\Thesis\Estimation\Methodology\Backtesting\Backtesting_ID.dta", replace

*HS9501* HS9901* GA01* ES01*{ 
*HS9511* HS9911* GA11* ES11*{	

foreach y of varlist HS9511* HS9911* GA11* ES11*{
	bys ID: egen T11_`y'=total(`y') 
}

levelsof ID, local(ID)
foreach x of varlist HS9501* { 
		bys ID: egen T01_`x' = total(`x')
		bys ID: egen T_`x' = count(`x')
	foreach y of varlist HS9511* {	
		gen T1_`x'`y'=T01_`x'+T11_`y'
		gen T0_`x'`y'=T_`x'-T1_`x'`y'
		gen pi01_`x'`y'=T01_`x'/T0_`x'`y'
		gen pi11_`x'`y'=T11_`y'/T1_`x'`y'
		gen pi1_`x'`y'=T1_`x'`y'/T_`x'
	
	gen Emp_`x'`y' = (T0_`x'`y'-T01_`x')*log(1-pi01_`x'`y')+T01_`x'*log(pi01_`x'`y')+(T1_`x'`y'-T11_`y')*log(1-pi11_`x'`y')+T11_`y'*log(pi11_`x'`y')
	gen Theo_`x'`y' = (T_`x'-T1_`x'`y')*log(1-pi1_`x'`y')+T1_`x'`y'*log(pi1_`x'`y')
	gen LRIn_`x'`y' = -2*(Theo_`x'`y' - Emp_`x'`y')
	display LRIn_`x'`y'
	}
}
drop T1_HS9501_w1HS9511_w5 T0_HS9501_w1HS9511_w5 pi01_HS9501_w1HS9511_w5 pi11_HS9501_w1HS9511_w5 pi1_HS9501_w1HS9511_w5 Emp_HS9501_w1HS9511_w5 Theo_HS9501_w1HS9511_w5 LRIn_HS9501_w1HS9511_w5
drop T1_HS9501_w1HS9511_w20 T0_HS9501_w1HS9511_w20 pi01_HS9501_w1HS9511_w20 pi11_HS9501_w1HS9511_w20 pi1_HS9501_w1HS9511_w20 Emp_HS9501_w1HS9511_w20 Theo_HS9501_w1HS9511_w20 LRIn_HS9501_w1HS9511_w20
drop T1_HS9501_w1HS9511_w50 T0_HS9501_w1HS9511_w50 pi01_HS9501_w1HS9511_w50 pi11_HS9501_w1HS9511_w50 pi1_HS9501_w1HS9511_w50 Emp_HS9501_w1HS9511_w50 Theo_HS9501_w1HS9511_w50 LRIn_HS9501_w1HS9511_w50
drop T1_HS9501_w1HS9511_w100 T0_HS9501_w1HS9511_w100 pi01_HS9501_w1HS9511_w100 pi11_HS9501_w1HS9511_w100 pi1_HS9501_w1HS9511_w100 Emp_HS9501_w1HS9511_w100 Theo_HS9501_w1HS9511_w100 LRIn_HS9501_w1HS9511_w100

drop T1_HS9501_w5HS9511_w1 T0_HS9501_w5HS9511_w1 pi01_HS9501_w5HS9511_w1 pi11_HS9501_w5HS9511_w1 pi1_HS9501_w5HS9511_w1 Emp_HS9501_w5HS9511_w1 Theo_HS9501_w5HS9511_w1 LRIn_HS9501_w5HS9511_w1
drop T1_HS9501_w5HS9511_w20 T0_HS9501_w5HS9511_w20 pi01_HS9501_w5HS9511_w20 pi11_HS9501_w5HS9511_w20 pi1_HS9501_w5HS9511_w20 Emp_HS9501_w5HS9511_w20 Theo_HS9501_w5HS9511_w20 LRIn_HS9501_w5HS9511_w20
drop T1_HS9501_w5HS9511_w50 T0_HS9501_w5HS9511_w50 pi01_HS9501_w5HS9511_w50 pi11_HS9501_w5HS9511_w50 pi1_HS9501_w5HS9511_w50 Emp_HS9501_w5HS9511_w50 Theo_HS9501_w5HS9511_w50 LRIn_HS9501_w5HS9511_w50
drop T1_HS9501_w5HS9511_w100 T0_HS9501_w5HS9511_w100 pi01_HS9501_w5HS9511_w100 pi11_HS9501_w5HS9511_w100 pi1_HS9501_w5HS9511_w100 Emp_HS9501_w5HS9511_w100 Theo_HS9501_w5HS9511_w100 LRIn_HS9501_w5HS9511_w100

drop T1_HS9501_w20HS9511_w5 T0_HS9501_w20HS9511_w5 pi01_HS9501_w20HS9511_w5 pi11_HS9501_w20HS9511_w5 pi1_HS9501_w20HS9511_w5 Emp_HS9501_w20HS9511_w5 Theo_HS9501_w20HS9511_w5 LRIn_HS9501_w20HS9511_w5
drop T1_HS9501_w20HS9511_w1 T0_HS9501_w20HS9511_w1 pi01_HS9501_w20HS9511_w1 pi11_HS9501_w20HS9511_w1 pi1_HS9501_w20HS9511_w1 Emp_HS9501_w20HS9511_w1 Theo_HS9501_w20HS9511_w1 LRIn_HS9501_w20HS9511_w1
drop T1_HS9501_w20HS9511_w50 T0_HS9501_w20HS9511_w50 pi01_HS9501_w20HS9511_w50 pi11_HS9501_w20HS9511_w50 pi1_HS9501_w20HS9511_w50 Emp_HS9501_w20HS9511_w50 Theo_HS9501_w20HS9511_w50 LRIn_HS9501_w20HS9511_w50
drop T1_HS9501_w20HS9511_w100 T0_HS9501_w20HS9511_w100 pi01_HS9501_w20HS9511_w100 pi11_HS9501_w20HS9511_w100 pi1_HS9501_w20HS9511_w100 Emp_HS9501_w20HS9511_w100 Theo_HS9501_w20HS9511_w100 LRIn_HS9501_w20HS9511_w100

drop T1_HS9501_w50HS9511_w5 T0_HS9501_w50HS9511_w5 pi01_HS9501_w50HS9511_w5 pi11_HS9501_w50HS9511_w5 pi1_HS9501_w50HS9511_w5 Emp_HS9501_w50HS9511_w5 Theo_HS9501_w50HS9511_w5 LRIn_HS9501_w50HS9511_w5
drop T1_HS9501_w50HS9511_w1 T0_HS9501_w50HS9511_w1 pi01_HS9501_w50HS9511_w1 pi11_HS9501_w50HS9511_w1 pi1_HS9501_w50HS9511_w1 Emp_HS9501_w50HS9511_w1 Theo_HS9501_w50HS9511_w1 LRIn_HS9501_w50HS9511_w1
drop T1_HS9501_w50HS9511_w20 T0_HS9501_w50HS9511_w20 pi01_HS9501_w50HS9511_w20 pi11_HS9501_w50HS9511_w20 pi1_HS9501_w50HS9511_w20 Emp_HS9501_w50HS9511_w20 Theo_HS9501_w50HS9511_w20 LRIn_HS9501_w50HS9511_w20
drop T1_HS9501_w50HS9511_w100 T0_HS9501_w50HS9511_w100 pi01_HS9501_w50HS9511_w100 pi11_HS9501_w50HS9511_w100 pi1_HS9501_w50HS9511_w100 Emp_HS9501_w50HS9511_w100 Theo_HS9501_w50HS9511_w100 LRIn_HS9501_w50HS9511_w100

drop T1_HS9501_w100HS9511_w5 T0_HS9501_w100HS9511_w5 pi01_HS9501_w100HS9511_w5 pi11_HS9501_w100HS9511_w5 pi1_HS9501_w100HS9511_w5 Emp_HS9501_w100HS9511_w5 Theo_HS9501_w100HS9511_w5 LRIn_HS9501_w100HS9511_w5
drop T1_HS9501_w100HS9511_w20 T0_HS9501_w100HS9511_w20 pi01_HS9501_w100HS9511_w20 pi11_HS9501_w100HS9511_w20 pi1_HS9501_w100HS9511_w20 Emp_HS9501_w100HS9511_w20 Theo_HS9501_w100HS9511_w20 LRIn_HS9501_w100HS9511_w20
drop T1_HS9501_w100HS9511_w50 T0_HS9501_w100HS9511_w50 pi01_HS9501_w100HS9511_w50 pi11_HS9501_w100HS9511_w50 pi1_HS9501_w100HS9511_w50 Emp_HS9501_w100HS9511_w50 Theo_HS9501_w100HS9511_w50 LRIn_HS9501_w100HS9511_w50
drop T1_HS9501_w100HS9511_w1 T0_HS9501_w100HS9511_w1 pi01_HS9501_w100HS9511_w1 pi11_HS9501_w100HS9511_w1 pi1_HS9501_w100HS9511_w1 Emp_HS9501_w100HS9511_w1 Theo_HS9501_w100HS9511_w1 LRIn_HS9501_w100HS9511_w1

levelsof ID, local(ID)
foreach x of varlist HS9901* { 
		bys ID: egen T01_`x' = total(`x')
		bys ID: egen T_`x' = count(`x')
	foreach y of varlist HS9911* {	
		gen T1_`x'`y'=T01_`x'+T11_`y'
		gen T0_`x'`y'=T_`x'-T1_`x'`y'
		gen pi01_`x'`y'=T01_`x'/T0_`x'`y'
		gen pi11_`x'`y'=T11_`y'/T1_`x'`y'
		gen pi1_`x'`y'=T1_`x'`y'/T_`x'
	
	gen Emp_`x'`y' = (T0_`x'`y'-T01_`x')*log(1-pi01_`x'`y')+T01_`x'*log(pi01_`x'`y')+(T1_`x'`y'-T11_`y')*log(1-pi11_`x'`y')+T11_`y'*log(pi11_`x'`y')
	gen Theo_`x'`y' = (T_`x'-T1_`x'`y')*log(1-pi1_`x'`y')+T1_`x'`y'*log(pi1_`x'`y')
	gen LRIn_`x'`y' = -2*(Theo_`x'`y' - Emp_`x'`y')
	display LRIn_`x'`y'
	}
}
drop T1_HS9901_w1HS9911_w5 T0_HS9901_w1HS9911_w5 pi01_HS9901_w1HS9911_w5 pi11_HS9901_w1HS9911_w5 pi1_HS9901_w1HS9911_w5 Emp_HS9901_w1HS9911_w5 Theo_HS9901_w1HS9911_w5 LRIn_HS9901_w1HS9911_w5
drop T1_HS9901_w1HS9911_w20 T0_HS9901_w1HS9911_w20 pi01_HS9901_w1HS9911_w20 pi11_HS9901_w1HS9911_w20 pi1_HS9901_w1HS9911_w20 Emp_HS9901_w1HS9911_w20 Theo_HS9901_w1HS9911_w20 LRIn_HS9901_w1HS9911_w20
drop T1_HS9901_w1HS9911_w50 T0_HS9901_w1HS9911_w50 pi01_HS9901_w1HS9911_w50 pi11_HS9901_w1HS9911_w50 pi1_HS9901_w1HS9911_w50 Emp_HS9901_w1HS9911_w50 Theo_HS9901_w1HS9911_w50 LRIn_HS9901_w1HS9911_w50
drop T1_HS9901_w1HS9911_w100 T0_HS9901_w1HS9911_w100 pi01_HS9901_w1HS9911_w100 pi11_HS9901_w1HS9911_w100 pi1_HS9901_w1HS9911_w100 Emp_HS9901_w1HS9911_w100 Theo_HS9901_w1HS9911_w100 LRIn_HS9901_w1HS9911_w100

drop T1_HS9901_w5HS9911_w1 T0_HS9901_w5HS9911_w1 pi01_HS9901_w5HS9911_w1 pi11_HS9901_w5HS9911_w1 pi1_HS9901_w5HS9911_w1 Emp_HS9901_w5HS9911_w1 Theo_HS9901_w5HS9911_w1 LRIn_HS9901_w5HS9911_w1
drop T1_HS9901_w5HS9911_w20 T0_HS9901_w5HS9911_w20 pi01_HS9901_w5HS9911_w20 pi11_HS9901_w5HS9911_w20 pi1_HS9901_w5HS9911_w20 Emp_HS9901_w5HS9911_w20 Theo_HS9901_w5HS9911_w20 LRIn_HS9901_w5HS9911_w20
drop T1_HS9901_w5HS9911_w50 T0_HS9901_w5HS9911_w50 pi01_HS9901_w5HS9911_w50 pi11_HS9901_w5HS9911_w50 pi1_HS9901_w5HS9911_w50 Emp_HS9901_w5HS9911_w50 Theo_HS9901_w5HS9911_w50 LRIn_HS9901_w5HS9911_w50
drop T1_HS9901_w5HS9911_w100 T0_HS9901_w5HS9911_w100 pi01_HS9901_w5HS9911_w100 pi11_HS9901_w5HS9911_w100 pi1_HS9901_w5HS9911_w100 Emp_HS9901_w5HS9911_w100 Theo_HS9901_w5HS9911_w100 LRIn_HS9901_w5HS9911_w100

drop T1_HS9901_w20HS9911_w5 T0_HS9901_w20HS9911_w5 pi01_HS9901_w20HS9911_w5 pi11_HS9901_w20HS9911_w5 pi1_HS9901_w20HS9911_w5 Emp_HS9901_w20HS9911_w5 Theo_HS9901_w20HS9911_w5 LRIn_HS9901_w20HS9911_w5
drop T1_HS9901_w20HS9911_w1 T0_HS9901_w20HS9911_w1 pi01_HS9901_w20HS9911_w1 pi11_HS9901_w20HS9911_w1 pi1_HS9901_w20HS9911_w1 Emp_HS9901_w20HS9911_w1 Theo_HS9901_w20HS9911_w1 LRIn_HS9901_w20HS9911_w1
drop T1_HS9901_w20HS9911_w50 T0_HS9901_w20HS9911_w50 pi01_HS9901_w20HS9911_w50 pi11_HS9901_w20HS9911_w50 pi1_HS9901_w20HS9911_w50 Emp_HS9901_w20HS9911_w50 Theo_HS9901_w20HS9911_w50 LRIn_HS9901_w20HS9911_w50
drop T1_HS9901_w20HS9911_w100 T0_HS9901_w20HS9911_w100 pi01_HS9901_w20HS9911_w100 pi11_HS9901_w20HS9911_w100 pi1_HS9901_w20HS9911_w100 Emp_HS9901_w20HS9911_w100 Theo_HS9901_w20HS9911_w100 LRIn_HS9901_w20HS9911_w100

drop T1_HS9901_w50HS9911_w5 T0_HS9901_w50HS9911_w5 pi01_HS9901_w50HS9911_w5 pi11_HS9901_w50HS9911_w5 pi1_HS9901_w50HS9911_w5 Emp_HS9901_w50HS9911_w5 Theo_HS9901_w50HS9911_w5 LRIn_HS9901_w50HS9911_w5
drop T1_HS9901_w50HS9911_w20 T0_HS9901_w50HS9911_w20 pi01_HS9901_w50HS9911_w20 pi11_HS9901_w50HS9911_w20 pi1_HS9901_w50HS9911_w20 Emp_HS9901_w50HS9911_w20 Theo_HS9901_w50HS9911_w20 LRIn_HS9901_w50HS9911_w20
drop T1_HS9901_w50HS9911_w1 T0_HS9901_w50HS9911_w1 pi01_HS9901_w50HS9911_w1 pi11_HS9901_w50HS9911_w1 pi1_HS9901_w50HS9911_w1 Emp_HS9901_w50HS9911_w1 Theo_HS9901_w50HS9911_w1 LRIn_HS9901_w50HS9911_w1
drop T1_HS9901_w50HS9911_w100 T0_HS9901_w50HS9911_w100 pi01_HS9901_w50HS9911_w100 pi11_HS9901_w50HS9911_w100 pi1_HS9901_w50HS9911_w100 Emp_HS9901_w50HS9911_w100 Theo_HS9901_w50HS9911_w100 LRIn_HS9901_w50HS9911_w100

drop T1_HS9901_w100HS9911_w5 T0_HS9901_w100HS9911_w5 pi01_HS9901_w100HS9911_w5 pi11_HS9901_w100HS9911_w5 pi1_HS9901_w100HS9911_w5 Emp_HS9901_w100HS9911_w5 Theo_HS9901_w100HS9911_w5 LRIn_HS9901_w100HS9911_w5
drop T1_HS9901_w100HS9911_w20 T0_HS9901_w100HS9911_w20 pi01_HS9901_w100HS9911_w20 pi11_HS9901_w100HS9911_w20 pi1_HS9901_w100HS9911_w20 Emp_HS9901_w100HS9911_w20 Theo_HS9901_w100HS9911_w20 LRIn_HS9901_w100HS9911_w20
drop T1_HS9901_w100HS9911_w50 T0_HS9901_w100HS9911_w50 pi01_HS9901_w100HS9911_w50 pi11_HS9901_w100HS9911_w50 pi1_HS9901_w100HS9911_w50 Emp_HS9901_w100HS9911_w50 Theo_HS9901_w100HS9911_w50 LRIn_HS9901_w100HS9911_w50
drop T1_HS9901_w100HS9911_w1 T0_HS9901_w100HS9911_w1 pi01_HS9901_w100HS9911_w1 pi11_HS9901_w100HS9911_w1 pi1_HS9901_w100HS9911_w1 Emp_HS9901_w100HS9911_w1 Theo_HS9901_w100HS9911_w1 LRIn_HS9901_w100HS9911_w1

*GARCH(1,1)
levelsof ID, local(ID)
foreach x of varlist GA01* { 
		bys ID: egen T01_`x' = total(`x')
		bys ID: egen T_`x' = count(`x')
	foreach y of varlist GA11* {	
		gen T1_`x'`y'=T01_`x'+T11_`y'
		gen T0_`x'`y'=T_`x'-T1_`x'`y'
		gen pi01_`x'`y'=T01_`x'/T0_`x'`y'
		gen pi11_`x'`y'=T11_`y'/T1_`x'`y'
		gen pi1_`x'`y'=T1_`x'`y'/T_`x'
	
	gen Emp_`x'`y' = (T0_`x'`y'-T01_`x')*log(1-pi01_`x'`y')+T01_`x'*log(pi01_`x'`y')+(T1_`x'`y'-T11_`y')*log(1-pi11_`x'`y')+T11_`y'*log(pi11_`x'`y')
	gen Theo_`x'`y' = (T_`x'-T1_`x'`y')*log(1-pi1_`x'`y')+T1_`x'`y'*log(pi1_`x'`y')
	gen LRIn_`x'`y' = -2*(Theo_`x'`y' - Emp_`x'`y')
	display LRIn_`x'`y'
	}
}

drop T1_GA01_n95GA11_n99 T0_GA01_n95GA11_n99 pi01_GA01_n95GA11_n99 pi11_GA01_n95GA11_n99 pi1_GA01_n95GA11_n99 Emp_GA01_n95GA11_n99 Theo_GA01_n95GA11_n99 LRIn_GA01_n95GA11_n99 
drop T1_GA01_n95GA11_t* T0_GA01_n95GA11_t* pi01_GA01_n95GA11_t* pi11_GA01_n95GA11_t* pi1_GA01_n95GA11_t* Emp_GA01_n95GA11_t* Theo_GA01_n95GA11_t* LRIn_GA01_n95GA11_t*

drop T1_GA01_n99GA11_n95 T0_GA01_n99GA11_n95 pi01_GA01_n99GA11_n95 pi11_GA01_n99GA11_n95 pi1_GA01_n99GA11_n95 Emp_GA01_n99GA11_n95 Theo_GA01_n99GA11_n95 LRIn_GA01_n99GA11_n95 
drop T1_GA01_n99GA11_t* T0_GA01_n99GA11_t* pi01_GA01_n99GA11_t* pi11_GA01_n99GA11_t* pi1_GA01_n99GA11_t* Emp_GA01_n99GA11_t* Theo_GA01_n99GA11_t* LRIn_GA01_n99GA11_t*

drop T1_GA01_t95GA11_t99 T0_GA01_t95GA11_t99 pi01_GA01_t95GA11_t99 pi11_GA01_t95GA11_t99 pi1_GA01_t95GA11_t99 Emp_GA01_t95GA11_t99 Theo_GA01_t95GA11_t99 LRIn_GA01_t95GA11_t99 
drop T1_GA01_t95GA11_n* T0_GA01_t95GA11_n* pi01_GA01_t95GA11_n* pi11_GA01_t95GA11_n* pi1_GA01_t95GA11_n* Emp_GA01_t95GA11_n* Theo_GA01_t95GA11_n* LRIn_GA01_t95GA11_n*

drop T1_GA01_t99GA11_t95 T0_GA01_t99GA11_t95 pi01_GA01_t99GA11_t95 pi11_GA01_t99GA11_t95 pi1_GA01_t99GA11_t95 Emp_GA01_t99GA11_t95 Theo_GA01_t99GA11_t95 LRIn_GA01_t99GA11_t95
drop T1_GA01_t99GA11_n* T0_GA01_t99GA11_n* pi01_GA01_t99GA11_n* pi11_GA01_t99GA11_n* pi1_GA01_t99GA11_n* Emp_GA01_t99GA11_n* Theo_GA01_t99GA11_n* LRIn_GA01_t99GA11_n*

save "E:\Kiel\Thesis\Estimation\Methodology\Backtesting\Backtesting_ID.dta", replace

* ES
rename ES01_HS95_w1 ES01_95w1
rename ES01_HS99_w1 ES01_99w1
rename ES01_HS95_w5 ES01_95w5
rename ES01_HS99_w5 ES01_99w5
rename ES01_HS95_w20 ES01_95w20
rename ES01_HS99_w20 ES01_99w20
rename ES01_HS95_w50 ES01_95w50
rename ES01_HS99_w50 ES01_99w50
rename ES01_HS95_w100 ES01_95w100
rename ES01_HS99_w100 ES01_99w100
rename ES01_GA_n95 ES01_n95
rename ES01_GA_n99 ES01_n99
rename ES01_GA_t95 ES01_t95
rename ES01_GA_t99 ES01_t99

rename ES11_HS95_w1 ES11_95w1
rename ES11_HS99_w1 ES11_99w1
rename ES11_HS95_w5 ES11_95w5
rename ES11_HS99_w5 ES11_99w5
rename ES11_HS95_w20 ES11_95w20
rename ES11_HS99_w20 ES11_99w20
rename ES11_HS95_w50 ES11_95w50
rename ES11_HS99_w50 ES11_99w50
rename ES11_HS95_w100 ES11_95w100
rename ES11_HS99_w100 ES11_99w100
rename ES11_GA_n95 ES11_n95
rename ES11_GA_n99 ES11_n99
rename ES11_GA_t95 ES11_t95
rename ES11_GA_t99 ES11_t99

rename T11_ES11_HS95_w1 T11_ES11_95w1 
rename T11_ES11_HS99_w1 T11_ES11_99w1 
rename T11_ES11_HS95_w5 T11_ES11_95w5
rename T11_ES11_HS99_w5 T11_ES11_99w5
rename T11_ES11_HS95_w20 T11_ES11_95w20
rename T11_ES11_HS99_w20 T11_ES11_99w20
rename T11_ES11_HS95_w50 T11_ES11_95w50
rename T11_ES11_HS99_w50 T11_ES11_99w50
rename T11_ES11_HS95_w100 T11_ES11_95w100
rename T11_ES11_HS99_w100 T11_ES11_99w100
rename T11_ES11_GA_n95 T11_ES11_n95
rename T11_ES11_GA_n99 T11_ES11_n99
rename T11_ES11_GA_t95 T11_ES11_t95
rename T11_ES11_GA_t99 T11_ES11_t99

levelsof ID, local(ID)
foreach x of varlist ES01_95* { 
		bys ID: egen T01_`x' = total(`x')
		bys ID: egen T_`x' = count(`x')
	foreach y of varlist ES11_95* {	
		gen T1_`x'`y'=T01_`x'+T11_`y'
		gen T0_`x'`y'=T_`x'-T1_`x'`y'
		gen pi01_`x'`y'=T01_`x'/T0_`x'`y'
		gen pi11_`x'`y'=T11_`y'/T1_`x'`y'
		gen pi1_`x'`y'=T1_`x'`y'/T_`x'
	
	gen Emp_`x'`y' = (T0_`x'`y'-T01_`x')*log(1-pi01_`x'`y')+T01_`x'*log(pi01_`x'`y')+(T1_`x'`y'-T11_`y')*log(1-pi11_`x'`y')+T11_`y'*log(pi11_`x'`y')
	gen Theo_`x'`y' = (T_`x'-T1_`x'`y')*log(1-pi1_`x'`y')+T1_`x'`y'*log(pi1_`x'`y')
	gen LRIn_`x'`y' = -2*(Theo_`x'`y' - Emp_`x'`y')
	display LRIn_`x'`y'
	}
}
drop T1_ES01_95w1ES11_95w5 T0_ES01_95w1ES11_95w5 pi01_ES01_95w1ES11_95w5 pi11_ES01_95w1ES11_95w5 pi1_ES01_95w1ES11_95w5 Emp_ES01_95w1ES11_95w5 Theo_ES01_95w1ES11_95w5 LRIn_ES01_95w1ES11_95w5
drop T1_ES01_95w1ES11_95w20 T0_ES01_95w1ES11_95w20 pi01_ES01_95w1ES11_95w20 pi11_ES01_95w1ES11_95w20 pi1_ES01_95w1ES11_95w20 Emp_ES01_95w1ES11_95w20 Theo_ES01_95w1ES11_95w20 LRIn_ES01_95w1ES11_95w20
drop T1_ES01_95w1ES11_95w50 T0_ES01_95w1ES11_95w50 pi01_ES01_95w1ES11_95w50 pi11_ES01_95w1ES11_95w50 pi1_ES01_95w1ES11_95w50 Emp_ES01_95w1ES11_95w50 Theo_ES01_95w1ES11_95w50 LRIn_ES01_95w1ES11_95w50
drop T1_ES01_95w1ES11_95w100 T0_ES01_95w1ES11_95w100 pi01_ES01_95w1ES11_95w100 pi11_ES01_95w1ES11_95w100 pi1_ES01_95w1ES11_95w100 Emp_ES01_95w1ES11_95w100 Theo_ES01_95w1ES11_95w100 LRIn_ES01_95w1ES11_95w100

drop T1_ES01_95w5ES11_95w1 T0_ES01_95w5ES11_95w1 pi01_ES01_95w5ES11_95w1 pi11_ES01_95w5ES11_95w1 pi1_ES01_95w5ES11_95w1 Emp_ES01_95w5ES11_95w1 Theo_ES01_95w5ES11_95w1 LRIn_ES01_95w5ES11_95w1
drop T1_ES01_95w5ES11_95w20 T0_ES01_95w5ES11_95w20 pi01_ES01_95w5ES11_95w20 pi11_ES01_95w5ES11_95w20 pi1_ES01_95w5ES11_95w20 Emp_ES01_95w5ES11_95w20 Theo_ES01_95w5ES11_95w20 LRIn_ES01_95w5ES11_95w20
drop T1_ES01_95w5ES11_95w50 T0_ES01_95w5ES11_95w50 pi01_ES01_95w5ES11_95w50 pi11_ES01_95w5ES11_95w50 pi1_ES01_95w5ES11_95w50 Emp_ES01_95w5ES11_95w50 Theo_ES01_95w5ES11_95w50 LRIn_ES01_95w5ES11_95w50
drop T1_ES01_95w5ES11_95w100 T0_ES01_95w5ES11_95w100 pi01_ES01_95w5ES11_95w100 pi11_ES01_95w5ES11_95w100 pi1_ES01_95w5ES11_95w100 Emp_ES01_95w5ES11_95w100 Theo_ES01_95w5ES11_95w100 LRIn_ES01_95w5ES11_95w100

drop T1_ES01_95w20ES11_95w1 T0_ES01_95w20ES11_95w1 pi01_ES01_95w20ES11_95w1 pi11_ES01_95w20ES11_95w1 pi1_ES01_95w20ES11_95w1 Emp_ES01_95w20ES11_95w1 Theo_ES01_95w20ES11_95w1 LRIn_ES01_95w20ES11_95w1
drop T1_ES01_95w20ES11_95w5 T0_ES01_95w20ES11_95w5 pi01_ES01_95w20ES11_95w5 pi11_ES01_95w20ES11_95w5 pi1_ES01_95w20ES11_95w5 Emp_ES01_95w20ES11_95w5 Theo_ES01_95w20ES11_95w5 LRIn_ES01_95w20ES11_95w5
drop T1_ES01_95w20ES11_95w50 T0_ES01_95w20ES11_95w50 pi01_ES01_95w20ES11_95w50 pi11_ES01_95w20ES11_95w50 pi1_ES01_95w20ES11_95w50 Emp_ES01_95w20ES11_95w50 Theo_ES01_95w20ES11_95w50 LRIn_ES01_95w20ES11_95w50
drop T1_ES01_95w20ES11_95w100 T0_ES01_95w20ES11_95w100 pi01_ES01_95w20ES11_95w100 pi11_ES01_95w20ES11_95w100 pi1_ES01_95w20ES11_95w100 Emp_ES01_95w20ES11_95w100 Theo_ES01_95w20ES11_95w100 LRIn_ES01_95w20ES11_95w100

drop T1_ES01_95w50ES11_95w1 T0_ES01_95w50ES11_95w1 pi01_ES01_95w50ES11_95w1 pi11_ES01_95w50ES11_95w1 pi1_ES01_95w50ES11_95w1 Emp_ES01_95w50ES11_95w1 Theo_ES01_95w50ES11_95w1 LRIn_ES01_95w50ES11_95w1
drop T1_ES01_95w50ES11_95w5 T0_ES01_95w50ES11_95w5 pi01_ES01_95w50ES11_95w5 pi11_ES01_95w50ES11_95w5 pi1_ES01_95w50ES11_95w5 Emp_ES01_95w50ES11_95w5 Theo_ES01_95w50ES11_95w5 LRIn_ES01_95w50ES11_95w5
drop T1_ES01_95w50ES11_95w20 T0_ES01_95w50ES11_95w20 pi01_ES01_95w50ES11_95w20 pi11_ES01_95w50ES11_95w20 pi1_ES01_95w50ES11_95w20 Emp_ES01_95w50ES11_95w20 Theo_ES01_95w50ES11_95w20 LRIn_ES01_95w50ES11_95w20
drop T1_ES01_95w50ES11_95w100 T0_ES01_95w50ES11_95w100 pi01_ES01_95w50ES11_95w100 pi11_ES01_95w50ES11_95w100 pi1_ES01_95w50ES11_95w100 Emp_ES01_95w50ES11_95w100 Theo_ES01_95w50ES11_95w100 LRIn_ES01_95w50ES11_95w100

drop T1_ES01_95w100ES11_95w1 T0_ES01_95w100ES11_95w1 pi01_ES01_95w100ES11_95w1 pi11_ES01_95w100ES11_95w1 pi1_ES01_95w100ES11_95w1 Emp_ES01_95w100ES11_95w1 Theo_ES01_95w100ES11_95w1 LRIn_ES01_95w100ES11_95w1
drop T1_ES01_95w100ES11_95w5 T0_ES01_95w100ES11_95w5 pi01_ES01_95w100ES11_95w5 pi11_ES01_95w100ES11_95w5 pi1_ES01_95w100ES11_95w5 Emp_ES01_95w100ES11_95w5 Theo_ES01_95w100ES11_95w5 LRIn_ES01_95w100ES11_95w5
drop T1_ES01_95w100ES11_95w20 T0_ES01_95w100ES11_95w20 pi01_ES01_95w100ES11_95w20 pi11_ES01_95w100ES11_95w20 pi1_ES01_95w100ES11_95w20 Emp_ES01_95w100ES11_95w20 Theo_ES01_95w100ES11_95w20 LRIn_ES01_95w100ES11_95w20
drop T1_ES01_95w100ES11_95w50 T0_ES01_95w100ES11_95w50 pi01_ES01_95w100ES11_95w50 pi11_ES01_95w100ES11_95w50 pi1_ES01_95w100ES11_95w50 Emp_ES01_95w100ES11_95w50 Theo_ES01_95w100ES11_95w50 LRIn_ES01_95w100ES11_95w50

levelsof ID, local(ID)
foreach x of varlist ES01_99* { 
		bys ID: egen T01_`x' = total(`x')
		bys ID: egen T_`x' = count(`x')
	foreach y of varlist ES11_99* {	
		gen T1_`x'`y'=T01_`x'+T11_`y'
		gen T0_`x'`y'=T_`x'-T1_`x'`y'
		gen pi01_`x'`y'=T01_`x'/T0_`x'`y'
		gen pi11_`x'`y'=T11_`y'/T1_`x'`y'
		gen pi1_`x'`y'=T1_`x'`y'/T_`x'
	
	gen Emp_`x'`y' = (T0_`x'`y'-T01_`x')*log(1-pi01_`x'`y')+T01_`x'*log(pi01_`x'`y')+(T1_`x'`y'-T11_`y')*log(1-pi11_`x'`y')+T11_`y'*log(pi11_`x'`y')
	gen Theo_`x'`y' = (T_`x'-T1_`x'`y')*log(1-pi1_`x'`y')+T1_`x'`y'*log(pi1_`x'`y')
	gen LRIn_`x'`y' = -2*(Theo_`x'`y' - Emp_`x'`y')
	display LRIn_`x'`y'
	}
}
drop T1_ES01_99w1ES11_99w5 T0_ES01_99w1ES11_99w5 pi01_ES01_99w1ES11_99w5 pi11_ES01_99w1ES11_99w5 pi1_ES01_99w1ES11_99w5 Emp_ES01_99w1ES11_99w5 Theo_ES01_99w1ES11_99w5 LRIn_ES01_99w1ES11_99w5
drop T1_ES01_99w1ES11_99w20 T0_ES01_99w1ES11_99w20 pi01_ES01_99w1ES11_99w20 pi11_ES01_99w1ES11_99w20 pi1_ES01_99w1ES11_99w20 Emp_ES01_99w1ES11_99w20 Theo_ES01_99w1ES11_99w20 LRIn_ES01_99w1ES11_99w20
drop T1_ES01_99w1ES11_99w50 T0_ES01_99w1ES11_99w50 pi01_ES01_99w1ES11_99w50 pi11_ES01_99w1ES11_99w50 pi1_ES01_99w1ES11_99w50 Emp_ES01_99w1ES11_99w50 Theo_ES01_99w1ES11_99w50 LRIn_ES01_99w1ES11_99w50
drop T1_ES01_99w1ES11_99w100 T0_ES01_99w1ES11_99w100 pi01_ES01_99w1ES11_99w100 pi11_ES01_99w1ES11_99w100 pi1_ES01_99w1ES11_99w100 Emp_ES01_99w1ES11_99w100 Theo_ES01_99w1ES11_99w100 LRIn_ES01_99w1ES11_99w100

drop T1_ES01_99w5ES11_99w1 T0_ES01_99w5ES11_99w1 pi01_ES01_99w5ES11_99w1 pi11_ES01_99w5ES11_99w1 pi1_ES01_99w5ES11_99w1 Emp_ES01_99w5ES11_99w1 Theo_ES01_99w5ES11_99w1 LRIn_ES01_99w5ES11_99w1
drop T1_ES01_99w5ES11_99w20 T0_ES01_99w5ES11_99w20 pi01_ES01_99w5ES11_99w20 pi11_ES01_99w5ES11_99w20 pi1_ES01_99w5ES11_99w20 Emp_ES01_99w5ES11_99w20 Theo_ES01_99w5ES11_99w20 LRIn_ES01_99w5ES11_99w20
drop T1_ES01_99w5ES11_99w50 T0_ES01_99w5ES11_99w50 pi01_ES01_99w5ES11_99w50 pi11_ES01_99w5ES11_99w50 pi1_ES01_99w5ES11_99w50 Emp_ES01_99w5ES11_99w50 Theo_ES01_99w5ES11_99w50 LRIn_ES01_99w5ES11_99w50
drop T1_ES01_99w5ES11_99w100 T0_ES01_99w5ES11_99w100 pi01_ES01_99w5ES11_99w100 pi11_ES01_99w5ES11_99w100 pi1_ES01_99w5ES11_99w100 Emp_ES01_99w5ES11_99w100 Theo_ES01_99w5ES11_99w100 LRIn_ES01_99w5ES11_99w100

drop T1_ES01_99w20ES11_99w1 T0_ES01_99w20ES11_99w1 pi01_ES01_99w20ES11_99w1 pi11_ES01_99w20ES11_99w1 pi1_ES01_99w20ES11_99w1 Emp_ES01_99w20ES11_99w1 Theo_ES01_99w20ES11_99w1 LRIn_ES01_99w20ES11_99w1
drop T1_ES01_99w20ES11_99w5 T0_ES01_99w20ES11_99w5 pi01_ES01_99w20ES11_99w5 pi11_ES01_99w20ES11_99w5 pi1_ES01_99w20ES11_99w5 Emp_ES01_99w20ES11_99w5 Theo_ES01_99w20ES11_99w5 LRIn_ES01_99w20ES11_99w5
drop T1_ES01_99w20ES11_99w50 T0_ES01_99w20ES11_99w50 pi01_ES01_99w20ES11_99w50 pi11_ES01_99w20ES11_99w50 pi1_ES01_99w20ES11_99w50 Emp_ES01_99w20ES11_99w50 Theo_ES01_99w20ES11_99w50 LRIn_ES01_99w20ES11_99w50
drop T1_ES01_99w20ES11_99w100 T0_ES01_99w20ES11_99w100 pi01_ES01_99w20ES11_99w100 pi11_ES01_99w20ES11_99w100 pi1_ES01_99w20ES11_99w100 Emp_ES01_99w20ES11_99w100 Theo_ES01_99w20ES11_99w100 LRIn_ES01_99w20ES11_99w100

drop T1_ES01_99w50ES11_99w1 T0_ES01_99w50ES11_99w1 pi01_ES01_99w50ES11_99w1 pi11_ES01_99w50ES11_99w1 pi1_ES01_99w50ES11_99w1 Emp_ES01_99w50ES11_99w1 Theo_ES01_99w50ES11_99w1 LRIn_ES01_99w50ES11_99w1
drop T1_ES01_99w50ES11_99w5 T0_ES01_99w50ES11_99w5 pi01_ES01_99w50ES11_99w5 pi11_ES01_99w50ES11_99w5 pi1_ES01_99w50ES11_99w5 Emp_ES01_99w50ES11_99w5 Theo_ES01_99w50ES11_99w5 LRIn_ES01_99w50ES11_99w5 T1_ES01_99w50ES11_99w20
drop T0_ES01_99w50ES11_99w20 pi01_ES01_99w50ES11_99w20 pi11_ES01_99w50ES11_99w20 pi1_ES01_99w50ES11_99w20 Emp_ES01_99w50ES11_99w20 Theo_ES01_99w50ES11_99w20 LRIn_ES01_99w50ES11_99w20
drop T1_ES01_99w50ES11_99w100 T0_ES01_99w50ES11_99w100 pi01_ES01_99w50ES11_99w100 pi11_ES01_99w50ES11_99w100 pi1_ES01_99w50ES11_99w100 Emp_ES01_99w50ES11_99w100 Theo_ES01_99w50ES11_99w100 LRIn_ES01_99w50ES11_99w100

drop T1_ES01_99w100ES11_99w1 T0_ES01_99w100ES11_99w1 pi01_ES01_99w100ES11_99w1 pi11_ES01_99w100ES11_99w1 pi1_ES01_99w100ES11_99w1 Emp_ES01_99w100ES11_99w1 Theo_ES01_99w100ES11_99w1 LRIn_ES01_99w100ES11_99w1
drop T1_ES01_99w100ES11_99w5 T0_ES01_99w100ES11_99w5 pi01_ES01_99w100ES11_99w5 pi11_ES01_99w100ES11_99w5 pi1_ES01_99w100ES11_99w5 Emp_ES01_99w100ES11_99w5 Theo_ES01_99w100ES11_99w5 LRIn_ES01_99w100ES11_99w5
drop T1_ES01_99w100ES11_99w20 T0_ES01_99w100ES11_99w20 pi01_ES01_99w100ES11_99w20 pi11_ES01_99w100ES11_99w20 pi1_ES01_99w100ES11_99w20 Emp_ES01_99w100ES11_99w20 Theo_ES01_99w100ES11_99w20 LRIn_ES01_99w100ES11_99w20
drop T1_ES01_99w100ES11_99w50 T0_ES01_99w100ES11_99w50 pi01_ES01_99w100ES11_99w50 pi11_ES01_99w100ES11_99w50 pi1_ES01_99w100ES11_99w50 Emp_ES01_99w100ES11_99w50 Theo_ES01_99w100ES11_99w50 LRIn_ES01_99w100ES11_99w50

	levelsof ID, local(ID)
	foreach x of varlist ES01_n95 { 
			bys ID: egen T01_`x' = total(`x')
			bys ID: egen T_`x' = count(`x')
		foreach y of varlist ES11_n95 {	
			gen T1_`x'`y'=T01_`x'+T11_`y'
			gen T0_`x'`y'=T_`x'-T1_`x'`y'
			gen pi01_`x'`y'=T01_`x'/T0_`x'`y'
			gen pi11_`x'`y'=T11_`y'/T1_`x'`y'
			gen pi1_`x'`y'=T1_`x'`y'/T_`x'
		
		gen Emp_`x'`y' = (T0_`x'`y'-T01_`x')*log(1-pi01_`x'`y')+T01_`x'*log(pi01_`x'`y')+(T1_`x'`y'-T11_`y')*log(1-pi11_`x'`y')+T11_`y'*log(pi11_`x'`y')
		gen Theo_`x'`y' = (T_`x'-T1_`x'`y')*log(1-pi1_`x'`y')+T1_`x'`y'*log(pi1_`x'`y')
		gen LRIn_`x'`y' = -2*(Theo_`x'`y' - Emp_`x'`y')
		display LRIn_`x'`y'
		}
	}

	levelsof ID, local(ID)
	foreach x of varlist ES01_n99 { 
			bys ID: egen T01_`x' = total(`x')
			bys ID: egen T_`x' = count(`x')
		foreach y of varlist ES11_n99 {	
			gen T1_`x'`y'=T01_`x'+T11_`y'
			gen T0_`x'`y'=T_`x'-T1_`x'`y'
			gen pi01_`x'`y'=T01_`x'/T0_`x'`y'
			gen pi11_`x'`y'=T11_`y'/T1_`x'`y'
			gen pi1_`x'`y'=T1_`x'`y'/T_`x'
		
		gen Emp_`x'`y' = (T0_`x'`y'-T01_`x')*log(1-pi01_`x'`y')+T01_`x'*log(pi01_`x'`y')+(T1_`x'`y'-T11_`y')*log(1-pi11_`x'`y')+T11_`y'*log(pi11_`x'`y')
		gen Theo_`x'`y' = (T_`x'-T1_`x'`y')*log(1-pi1_`x'`y')+T1_`x'`y'*log(pi1_`x'`y')
		gen LRIn_`x'`y' = -2*(Theo_`x'`y' - Emp_`x'`y')
		display LRIn_`x'`y'
		}
	}

	levelsof ID, local(ID)
	foreach x of varlist ES01_t95 { 
			bys ID: egen T01_`x' = total(`x')
			bys ID: egen T_`x' = count(`x')
		foreach y of varlist ES11_t95 {	
			gen T1_`x'`y'=T01_`x'+T11_`y'
			gen T0_`x'`y'=T_`x'-T1_`x'`y'
			gen pi01_`x'`y'=T01_`x'/T0_`x'`y'
			gen pi11_`x'`y'=T11_`y'/T1_`x'`y'
			gen pi1_`x'`y'=T1_`x'`y'/T_`x'
		
		gen Emp_`x'`y' = (T0_`x'`y'-T01_`x')*log(1-pi01_`x'`y')+T01_`x'*log(pi01_`x'`y')+(T1_`x'`y'-T11_`y')*log(1-pi11_`x'`y')+T11_`y'*log(pi11_`x'`y')
		gen Theo_`x'`y' = (T_`x'-T1_`x'`y')*log(1-pi1_`x'`y')+T1_`x'`y'*log(pi1_`x'`y')
		gen LRIn_`x'`y' = -2*(Theo_`x'`y' - Emp_`x'`y')
		display LRIn_`x'`y'
		}
	}

	levelsof ID, local(ID)
	foreach x of varlist ES01_t99 { 
			bys ID: egen T01_`x' = total(`x')
			bys ID: egen T_`x' = count(`x')
		foreach y of varlist ES11_t99 {	
			gen T1_`x'`y'=T01_`x'+T11_`y'
			gen T0_`x'`y'=T_`x'-T1_`x'`y'
			gen pi01_`x'`y'=T01_`x'/T0_`x'`y'
			gen pi11_`x'`y'=T11_`y'/T1_`x'`y'
			gen pi1_`x'`y'=T1_`x'`y'/T_`x'
		
		gen Emp_`x'`y' = (T0_`x'`y'-T01_`x')*log(1-pi01_`x'`y')+T01_`x'*log(pi01_`x'`y')+(T1_`x'`y'-T11_`y')*log(1-pi11_`x'`y')+T11_`y'*log(pi11_`x'`y')
		gen Theo_`x'`y' = (T_`x'-T1_`x'`y')*log(1-pi1_`x'`y')+T1_`x'`y'*log(pi1_`x'`y')
		gen LRIn_`x'`y' = -2*(Theo_`x'`y' - Emp_`x'`y')
		display LRIn_`x'`y'
		}
	}


*keep c tm y m ID rmdreal T* T1* T0* T11* T01* pi* Emp* Theo* LRIn*
*bysort c: gen a=_n
*drop if a>1
*drop a

*export excel c LRIn* using "E:\Kiel\Thesis\Estimation\Methodology\Backtesting\Backtesting_ID_check.xlsx", firstrow(variables)
	
save "E:\Kiel\Thesis\Estimation\Methodology\Backtesting\Backtesting_ID.dta", replace
	
*============================
* CONDITIONAL COVERAGE TEST *
*============================
* HS 
keep c tm y m ID rmdreal T_* T1_* Emp* 

** 5% percentile
gen interval = 1-0.95

gen Theocc_HS95w1 = (T_HS9501_w1-T1_HS9501_w1HS9511_w1)*log(1-interval)+T1_HS9501_w1HS9511_w1*log(interval)
gen LRCC_HS95w1 = -2*(Theocc_HS95w1  - Emp_HS9501_w1HS9511_w1)
gen Theocc_HS95w5 = (T_HS9501_w5-T1_HS9501_w5HS9511_w5)*log(1-interval)+T1_HS9501_w5HS9511_w5*log(interval)
gen LRCC_HS95w5 = -2*(Theocc_HS95w5  - Emp_HS9501_w5HS9511_w5)
gen Theocc_HS95w20 = (T_HS9501_w20-T1_HS9501_w20HS9511_w20)*log(1-interval)+T1_HS9501_w20HS9511_w20*log(interval)
gen LRCC_HS95w20 = -2*(Theocc_HS95w20  - Emp_HS9501_w20HS9511_w20)
gen Theocc_HS95w50 = (T_HS9501_w50-T1_HS9501_w50HS9511_w50)*log(1-interval)+T1_HS9501_w50HS9511_w50*log(interval)
gen LRCC_HS95w50 = -2*(Theocc_HS95w50  - Emp_HS9501_w50HS9511_w50)
gen Theocc_HS95w100 = (T_HS9501_w100-T1_HS9501_w100HS9511_w100)*log(1-interval)+T1_HS9501_w100HS9511_w100*log(interval)
gen LRCC_HS95w100 = -2*(Theocc_HS95w100  - Emp_HS9501_w100HS9511_w100)

gen Theocc_n95 = (T_GA01_n95-T1_GA01_n95GA11_n95)*log(1-interval)+T1_GA01_t95GA11_t95*log(interval)
gen LRCC_n95 = -2*(Theocc_n95 - Emp_GA01_n95GA11_n95)
gen Theocc_t95 = (T_GA01_t95-T1_GA01_t95GA11_t95)*log(1-interval)+T1_GA01_t95GA11_t95*log(interval)
gen LRCC_t95 = -2*(Theocc_t95 - Emp_GA01_t95GA11_t95)

gen Theocc_ESHS95w1 = ( T_ES01_95w1-T1_ES01_95w1ES11_95w1)*log(1-interval)+T1_ES01_95w1ES11_95w1*log(interval)
gen LRCC_ESHS95w1  = -2*(Theocc_ESHS95w1 - Emp_ES01_95w1ES11_95w1)
gen Theocc_ESHS95w5 = ( T_ES01_95w5-T1_ES01_95w5ES11_95w5)*log(1-interval)+T1_ES01_95w5ES11_95w5*log(interval)
gen LRCC_ESHS95w5 = -2*(Theocc_ESHS95w5 - Emp_ES01_95w5ES11_95w5)
gen Theocc_ESHS95w20 = ( T_ES01_95w20-T1_ES01_95w20ES11_95w20)*log(1-interval)+T1_ES01_95w20ES11_95w20*log(interval)
gen LRCC_ESHS95w20 = -2*(Theocc_ESHS95w20 - Emp_ES01_95w20ES11_95w20)
gen Theocc_ESHS95w50 = ( T_ES01_95w50-T1_ES01_95w50ES11_95w50)*log(1-interval)+T1_ES01_95w50ES11_95w50*log(interval)
gen LRCC_ESHS95w50 = -2*(Theocc_ESHS95w50 - Emp_ES01_95w50ES11_95w50)
gen Theocc_ESHS95w100 = ( T_ES01_95w100-T1_ES01_95w100ES11_95w100)*log(1-interval)+T1_ES01_95w100ES11_95w100*log(interval)
gen LRCC_ESHS95w100 = -2*(Theocc_ESHS95w100 - Emp_ES01_95w100ES11_95w100)

gen Theocc_ESn95 = (T_ES01_n95-T1_ES01_n95ES11_n95)*log(1-interval)+T1_ES01_n95ES11_n95*log(interval)
gen LRCC_ESn95 = -2*(Theocc_ESn95 - Emp_ES01_n95ES11_n95)
gen Theocc_ESt95 = (T_ES01_t95-T1_ES01_t95ES11_t95)*log(1-interval)+T1_ES01_t95ES11_t95*log(interval)
gen LRCC_ESt95 = -2*(Theocc_ESt95 - Emp_ES01_t95ES11_t95)

** 1% percentile
gen interval_1 = 1-0.99

gen Theocc_HS99w1 = (T_HS9901_w1-T1_HS9901_w1HS9911_w1)*log(1-interval_1)+T1_HS9901_w1HS9911_w1*log(interval_1)
gen LRCC_HS99w1 = -2*(Theocc_HS99w1  - Emp_HS9501_w1HS9511_w1)
gen Theocc_HS99w5 = (T_HS9901_w5-T1_HS9901_w5HS9911_w5)*log(1-interval_1)+T1_HS9901_w5HS9911_w5*log(interval_1)
gen LRCC_HS99w5 = -2*(Theocc_HS99w5  - Emp_HS9901_w5HS9911_w5)
gen Theocc_HS99w20 = (T_HS9901_w20-T1_HS9901_w20HS9911_w20)*log(1-interval_1)+T1_HS9901_w20HS9911_w20*log(interval_1)
gen LRCC_HS99w20 = -2*(Theocc_HS99w20  - Emp_HS9901_w20HS9911_w20)
gen Theocc_HS99w50 = (T_HS9901_w50-T1_HS9901_w50HS9911_w50)*log(1-interval_1)+T1_HS9901_w50HS9911_w50*log(interval_1)
gen LRCC_HS99w50 = -2*(Theocc_HS99w50  - Emp_HS9901_w50HS9911_w50)
gen Theocc_HS99w100 = (T_HS9901_w100-T1_HS9901_w100HS9911_w100)*log(1-interval_1)+T1_HS9901_w100HS9911_w100*log(interval_1)
gen LRCC_HS99w100 = -2*(Theocc_HS99w100  - Emp_HS9901_w100HS9911_w100)

gen Theocc_n99 = (T_GA01_n99-T1_GA01_n99GA11_n99)*log(1-interval_1)+T1_GA01_t99GA11_t99*log(interval_1)
gen LRCC_n99 = -2*(Theocc_n99  - Emp_GA01_n99GA11_n99)
gen Theocc_t99 = (T_GA01_t99-T1_GA01_t99GA11_t99)*log(1-interval_1)+T1_GA01_t99GA11_t99*log(interval_1)
gen LRCC_t99 = -2*(Theocc_t99  - Emp_GA01_t99GA11_t99)

gen Theocc_ESHS99w1 = ( T_ES01_99w1-T1_ES01_99w1ES11_99w1)*log(1-interval_1)+T1_ES01_99w1ES11_99w1*log(interval_1)
gen LRCC_ESHS99w1  = -2*(Theocc_ESHS99w1 - Emp_ES01_99w1ES11_99w1)
gen Theocc_ESHS99w5 = ( T_ES01_95w5-T1_ES01_95w5ES11_95w5)*log(1-interval_1)+T1_ES01_99w5ES11_99w5*log(interval_1)
gen LRCC_ESHS99w5 = -2*(Theocc_ESHS99w5 - Emp_ES01_99w5ES11_99w5)
gen Theocc_ESHS99w20 = ( T_ES01_99w20-T1_ES01_99w20ES11_99w20)*log(1-interval_1)+T1_ES01_99w20ES11_99w20*log(interval_1)
gen LRCC_ESHS99w20 = -2*(Theocc_ESHS95w20 - Emp_ES01_95w20ES11_95w20)
gen Theocc_ESHS99w50 = ( T_ES01_99w50-T1_ES01_99w50ES11_99w50)*log(1-interval_1)+T1_ES01_99w50ES11_99w50*log(interval_1)
gen LRCC_ESHS99w50 = -2*(Theocc_ESHS99w50 - Emp_ES01_99w50ES11_99w50)
gen Theocc_ESHS99w100 = ( T_ES01_99w100-T1_ES01_99w100ES11_99w100)*log(1-interval_1)+T1_ES01_99w100ES11_99w100*log(interval_1)
gen LRCC_ESHS99w100 = -2*(Theocc_ESHS99w100 - Emp_ES01_99w100ES11_99w100)

gen Theocc_ESn99 = (T_ES01_n99-T1_ES01_n99ES11_n99)*log(1-interval_1)+T1_ES01_n99ES11_n99*log(interval_1)
gen LRCC_ESn99 = -2*(Theocc_ESn99 - Emp_ES01_n99ES11_n99)
gen Theocc_ESt99 = (T_GA01_t99-T1_GA01_t99GA11_t99)*log(1-interval_1)+T1_ES01_t99ES11_t99*log(interval_1)
gen LRCC_ESt99 = -2*(Theocc_ESt99 - Emp_ES01_t99ES11_t99)

*keep c tm y m ID rmdreal LRCC*
*bysort c: gen a=_n
*drop if a>1
*drop a
*export excel c LRCC* using "E:\Kiel\Thesis\Estimation\Methodology\Backtesting\Backtesting_CC.xlsx", firstrow(variables)

save "E:\Kiel\Thesis\Estimation\Methodology\Backtesting\Backtesting_CC.dta", replace



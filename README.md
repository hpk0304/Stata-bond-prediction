# Stata-Check the outliers with Value-at-Risk (VaR) models
## Thesis: Testing VaR models on long-run Sovereign bond data
In the face of current chaos in finance, risk management is an urgent requirement in controlling losses. This thesis shed light on testing VaR model on monthly Sovereign bond data over 200 years. The main contents compare performance of one-day prediction of 25 selected portfolios via three methods – Historical Simulation (Engle and Manganelli (2001)), GARCH(1,1) (Robert Eagle (1982)) and Expected Shortfall (Artzner et al. (1997)). Remarkably, performance is evaluated by Kupiec test, Independence test and Conditional Coverage test, named shortly as Back-testing. After testing, Historical Simulation and Expected Shortfall of Historical Simulation are most effective. Besides, Normal GARCH(1,1) and ES Normal GARCH(1,1) are also potential. However, a persistent model applied throughout time should be carefully considered, especially in crisis. As regards GARCH(1,1), tested normal distribution works surprisingly better than Student-t. Last but not least, 1% percentile is more effective than 5% percentile in most approaches.

**Keywords:** Value-at-Risk; Sovereign bond; long-run; Historical Simulation; GARCH(1,1); Expected Shortfall; Back-testing

**Support:** risk management, portfolio optimization

### Data source: 
Meyer et. al (2018) with project "200 years of Sovereign Haircuts and Bond Returns", solve 25/91 single portfolios

Excel and Stata files contain the bondId (ID), Name, Country (c), issue date (issuey), maturity date (maturityy), monthly return (rdrealy), amount of issue (amtISS), currency, year y and month m

## Information about the files

**Descriptive statistics and Data Exploration**

Realization.do: Data Wrangling and EDA (Exploratory Data Analysis), visualize the statistics and distributions of dataset

**3 methods to find the VaR values, check the outliers and do one-day prediction**

VaR_HistSim_final.do: The first method - Historical Simulation, no assumption about distribution, rolling the historical data in the window of 1 year, 5 years, 20 years, 50 years and 100 years

VaR_GARCH_final.do: The second method - Generalized Autoregressive Conditional Heteroskedasticity GARCH, applying normality and t-distribution, considering the access kurtosis of loss distribution where losses are probably larger than expectation

VaR_ES_final.do: The last method - Expected Shortfall or Conditional VaR (CVaR), Average VaR (AVaR) or Expected Tail Loss (ETL ES) implying the expected portfolio return when return exceeds the break of extreme threshold VaR

**Back-testing**
Backtesting_final.do: examining the fitness of those models with the reality by the frequency of violations

It contains 3 tests:
a.	Kupiec Test: checking the rate of failure which loss returns exceed the VaR 
b.	Independence Test: testing the independent violations over the years, no correlation with fluctuation between time t and (t-1)
c.	Conditional Coverage Test: combination of those above tests, solving the shortcomings of Kupiec test (lack of time correlations) and Independence test (measurement in short-term, lack the rate of loss failures)



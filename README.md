# bitcoin-cor-study
R script to import price data on electronic securities and perform time-series correlation analysis

**Program:** 1 Year Time-Series Price Regression of Bitcoin [BTC] vs. VARIOUS ESTIMATOR PRICES

**Code Language: R** (Statistics & Mathematics Programming Language)

**Description:** This R Language program will extract data time-series currency data over a one-year period between [2015-01-01] and [2016-01-01].  The calculations performed in this program seek to quantify how well the prices of several alike currencies can be used to explain (not predict) the movement of the price of one response variable: the price of the Bitcoin [BTC] in USD.  This measurement is made the context of the inquiry: “is Bitcoin treated by the market as part of the “alternate currency (NON-USD)” basket of investments?” and the data provided is supplemental to a regression correlation analysis.  

The program, when executed will: 
• import web data
• build a linear model of each time-series data pair
• build a multilinear combined model
• output statistical metrics of regression
• build visual graphs (outputted in .JPG format to the active R directory).

**ABSTRACT:**
The typical economic theory would suggest that if Bitcoin is treated as an alternate currency investment in the same way as other currencies used as speculative investments, that the day-to-day fluctuation of bitcoin prices will mirror (to some extent) the day-to-day movement of other similar investments.  This assumption is driven by the liquid nature of electronic trading, the low cost of divestment, and the high volume of these markets.

A simple correlation analysis is done by linear regression, in which the data is broken into time-series chunks by 24 hour period with all unmatched data sets discarded.  The CRAN, ZOO, and QUANDL R packages are used to achieve the construction of the day-to-day (ZOO XTS) linear model of BTC vs. A SINGLE ESTIMATOR, as well as support for a Multiple Linear Model that encompasses the entirety of the ESTIMATOR sets.

The following data are included by default as Estimator sets:
	Chinese Yen [¥] 24 hour close average
	Gold Index Fund 24 hour close average
	Corporate Stock Index 24 hour close average
  
 **NOTES:**
 In order to import the XTS data properly, a QUANDL API key will be required.  These are given for free at www.Quandl.com to users that request API keys.  Fill in the "API_KEY_HERE" fields with theis API key in order to execute the R program.
 
 A sample function for generating graphics of this dataset is included as well, utilizing the ggplot function set.
 


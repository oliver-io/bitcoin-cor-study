# -------- This bit sets up dependencies, some fiddling may be required to get Quandl to install properly

install.packages("devtools", deps=TRUE)
install.packages("Quandl", deps=TRUE)
library(devtools)
library(Quandl)

# -------- Download the databases
# this will pull in data as a normal dataframe

btc_spot	<- Quandl("BAVERAGE/USD", api_key="API_KEY_HERE", trim_start="2015-01-01", trim_end="2016-01-01")
gold_index	<- Quandl("CHRIS/CME_GC1", api_key="API_KEY_HERE", trim_start="2015-01-01", trim_end="2016-01-01")
corp_future <- Quandl("YAHOO/INDEX_W5KMCV", api_key="API_KEY_HERE", trim_start="2015-01-01", trim_end="2016-01-01")
usd_cny <- Quandl("CURRFX/CNYUSD", api_key="API_KEY_HERE", trim_start="2015-01-01", trim_end="2016-01-01")


# -------- Rename the column labels to get rid of bad symbols,
# for some reason Quandl keeps delivering names with illegitimate characters

colnames(btc_spot) <- make.names(colnames(btc_spot), unique=TRUE)
colnames(gold_index) <- make.names(colnames(gold_index), unique=TRUE)
colnames(corp_future) <- make.names(colnames(corp_future), unique=TRUE)
colnames(usd_cny) <- make.names(colnames(usd_cny), unique=TRUE)

# -------- Let's pull out the relevant data and discard of the other information
# so that we can compile all of this into a bigger dataframe

btc_spot <- data.frame(btc_spot$Date, btc_spot$X24h.Average)
colnames(btc_spot) <- c("date", "price")
gold_index <- data.frame(gold_index$Date, gold_index$Settle)
colnames(gold_index) <- c("date", "price")
corp_future <- data.frame(corp_future$Date, corp_future$Close)
colnames(corp_future) <- c("date", "price")
usd_cny <- data.frame(usd_cny$Date, usd_cny$Rate)
colnames(usd_cny) <- c("date", "price")

# -------- Let's shove the data we've already accumulated into a time-series datatype,
# using the zoo library and XTS datatypes for this

xts_btc <- as.xts(btc_spot, order.by = btc_spot$date, frequency=NULL, .RECLASS = FALSE)
xts_auI <- as.xts(gold_index, order.by = gold_index$date, frequency=NULL, .RECLASS = FALSE)
xts_coF <- as.xts(corp_future, order.by = corp_future$date, frequency=NULL, .RECLASS = FALSE)
xts_cny <- as.xts(usd_cny, order.by = usd_cny$date, frequency=NULL, .RECLASS = FALSE)

# -------- Get rid of the textual dates, the XTS datatype already contains a hardcoded
# refernece to a date-type data object of its own
xts_btc$date <- NULL
xts_auI$date <- NULL
xts_coF$date <- NULL
xts_cny$date <- NULL

# -------- Coerce these into the same frame for easy manipulation.  After this we should have
# one dataframe, with a date and columns corresponding to asset prices

frame <- merge.xts(xts_btc, xts_auI)
frame <- merge.xts(frame, xts_coF)
frame <- merge.xts(frame, xts_cny)

# -------- One final rename for the ease of calls

colnames(frame) <- c("btc", "aui", "cof", "cny")


# Everything from here is tests


#CNY
cor(as.numeric(frame$btc), as.numeric(frame$cny), use="complete.obs")
fit <- lm(formula = as.numeric(frame$btc) ~ as.numeric(frame$cny), data = frame)
summary(fit)

#GOLD
cor(as.numeric(frame$btc), as.numeric(frame$aui), use="complete.obs")
fit <- lm(formula = as.numeric(frame$btc) ~ as.numeric(frame$aui), data = frame)
summary(fit)

#TECH
cor(as.numeric(frame$btc), as.numeric(frame$cof), use="complete.obs")
fit <- lm(formula = as.numeric(frame$btc) ~ as.numeric(frame$cof), data = frame)
summary(fit)

#MLM
cor(as.numeric(frame$btc), as.numeric(frame$cof), use="complete.obs")
fit <- lm(formula = as.numeric(frame$btc) ~ as.numeric(frame$cof) + as.numeric(frame$cny) + as.numeric(frame$cny), data = frame)
summary(fit)



#GENERATE SOME VISUALS

rescale <- function(vec, lims=range(vec), clip=c(0, 1)) {
  # find the coeficients of transforming linear equation
  # that maps the lims range to (0, 1)
  slope <- (1 - 0) / (lims[2] - lims[1])
  intercept <- - slope * lims[1]

  xformed <- slope * as.numeric(vec) + intercept

  # do the clipping
  xformed[xformed < 0] <- clip[1]
  xformed[xformed > 1] <- clip[2]

  xformed
}


##here is the sample function to generate a BTC vs CNY correlation plot, with the scales removed for clarity
ggplot(frame,aes(date,btc)) + geom_line(aes(color="ibm")) + geom_line(data=frame,aes(color="frame")) + labs(color="Legend") + scale_colour_manual("", breaks = c("btc"), values = c("blue", "brown")) +  ggtitle("BTC VS CNY") +   theme(plot.title = element_text(lineheight=.7, face="bold"))

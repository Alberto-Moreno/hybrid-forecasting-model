library(forecast) # We will use this package to display the ACF and PACF plots more easily and neatly
library(tseries) # This package includes several Unit Root Tests

# Fig. 1
plot(training, ylab = "Monthly registrations (training set)")

# Fig. 2
tsdisplay(training, main = "Autocorrelation of the time series")

# Stationarity test 

kpss.test(x = training)

# Arima model
fit_arima <- arima(training, order = c(1,1,2))

# Fig. 3
res <- residuals(fit_arima)
tsdisplay(res, main = "ARIMA(1,1,2) analysis of the residuals ")

# Box-Ljung test for the ARIMA residuals with h = 10 and K = 3

Box.test(res, lag=10, fitdf=3, type="Lj")


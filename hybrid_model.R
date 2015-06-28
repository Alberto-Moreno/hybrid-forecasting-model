# This algorithm adds the forecast of the original ARIMA model and the new ANN (that forecasts the residuals) 

fit_arima <- arima(training, order = c(1,1,2))
fit_annresiduals <- nnetar(residuals(fit_arima), p = 1, size = 1)

forecast_arima <- forecast(fit_arima, 29)
forecast_annresiduals <- forecast(fit_annresiduals, 29)

forecast_hybrid <- forecast_arima$mean + forecast_annresiduals$mean

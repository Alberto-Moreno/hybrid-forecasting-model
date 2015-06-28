# Calculate the MAE for each model using the testing set (29 observations)

source("hybrid_model.R") # This script includes the forecasts of the ARIMA and hybrid models
fit_ann <- nnetar(training, p = 5, size = 1) # Estimate the original ANN model

# Perform the 29-period forecasts for the ANN model
forecast_ann <- forecast(fit_ann, 29) 


# Calculate different accuracy measures for the forecasts and extract the testing MAE
mae_ann <- accuracy(forecast_ann, testing)[2,3]  
mae_arima <- accuracy(forecast_arima, testing)[2,3] 
mae_hybrid <- accuracy(forecast_hybrid, testing)[1,3]


# Create a data frame with the MAEs for each model

comparison <- data.frame(ARIMA = mae_arima, ANN = mae_ann, Hybrid = mae_hybrid)

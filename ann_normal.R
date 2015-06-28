library(forecast) # We will use this library to fit the ANNs and make the forecasts

source("read_registrations.R") ## Load the registrations dataset (previously processed and saved)

# Create a cluster with the cores used for the computations. We use all the available cores in the machine.
cl<-makeCluster(detectCores())
registerDoParallel(cl)

k <- 60 # Number of observations used in each iteration
n <- length(training) 
st <- tsp(training)[1]+(k-2)/12 # Value used to control the start and and of the CV train and test sets in each iteration

mae <- numeric(0)
results <- data.frame(p = integer(0), size = integer(0), MAE_mean = numeric(0)) # Create a data frame to store the results
h <- 1 # Counter

for(p in 1:12) {
  for(size in 1:10){
    for(i in 1:(n-k)) {
      subtrain <- window(training, end=st + i/12) # The train set for this iteration of the CV process
      subtest <- window(training, start=st + (i+1)/12, end=st + (i+12)/12) # The test set for this iteration of the CV process
      fit <- nnetar(p = p, size = size, x = subtrain, repeats = 20) # Estimate the ANN currently being evaluated
      fcast <- forecast(fit, h=12) # Create a 12-month forecast
      mae[i] <- mean(abs(fcast[['mean']]-subtest)) # Calculate the average of the MAE of each month
    }
    results[h, ] <- c(p, size, mean(mae)) # Store the lags, number of nodes in the hidden layer and the average MAE for the current ANN
    h <- h + 1
  }
}

# Store the results in a data frame for evaluation  
results <- as.data.frame(x)
names(results) <- c("p", "size", "MAE_mean")
library(forecast) # We will use this library to fit the ANNs and make the forecasts

source("read_registrations.R") ## Load the registrations dataset (previously processed and saved)

#Load all the required libraries for running the code in parallel
library(parallel)
library(foreach)
library(doParallel)

# Create a cluster with the cores used for the computations. We use all the available cores in the machine.
cl<-makeCluster(detectCores())
registerDoParallel(cl)

k <- 60 # Number of observations used in each iteration
n <- length(training) 
st <- tsp(training)[1]+(k-2)/12 # Value used to control the start and and of the CV train and test sets in each iteration

mae <- numeric(0)

# The 'foreach' loop works similarly to a standard 'for' loop. In this case, it consists of 4 nested foreach loops that perform the cross-validation proces for each combination of 1-12 lags and 1-10 nodes in the hidden layer
# The loops are nested through the operator '%:%' and the process is performed in parallel through the operator '%dopar%'

x <- foreach(p = 1:12, .combine = rbind) %:% foreach(size = 1:10, .combine = rbind, .packages ="foreach") %dopar% {
  foreach(i = 1:(n-k), .combine = rbind, .packages = "forecast") %dopar% {
    subtrain <- window(training, end=st + i/12) # The train set for this iteration of the CV process
    subtest <- window(training, start=st + (i+1)/12, end=st + (i+12)/12) # The test set for this iteration of the CV process
    fit <- nnetar(p = p, size = size, x = subtrain, repeats = 20) # Estimate the ANN currently being evaluated
    fcast <- forecast(fit, h=12) # Create a 12-month forecast
    mae[i] <- mean(abs(fcast[['mean']]-subtest)) # Calculate the average of the MAE of each month

  }

  c(p, size, mean(mae)) # Return a vector with the number of lags, the number of nodes in the hidden layer and the mean MAE of the evaluated ANN model 
}


stopCluster(cl) # Close the cluster

# Store the results in a data frame for evaluation  
results <- as.data.frame(x)
names(results) <- c("p", "size", "MAE_mean")
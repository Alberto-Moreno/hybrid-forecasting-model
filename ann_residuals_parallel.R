

source("load_everything.R")

k <- 60
n <- length(res)
st <- tsp(res)[1]+(k-2)/12
results <- data.frame(p = integer(0), P = integer(0), size = integer(0), MAE = numeric(0))
mae <- numeric(0)

ini <- Sys.time()
ini
x <- foreach(p = 1:12, .combine = rbind) %:% foreach(P = 1, .combine = rbind) %:% foreach(size = 1:10, .combine = rbind, .packages ="foreach") %dopar% {
  foreach(i = 1:(n-k), .combine = rbind, .packages = "forecast") %dopar% {
    xshort <- window(res, start=st+(i-k+1)/12, end=st+i/12)
    xnext <- window(res, start=st + (i+1)/12, end=st + (i+12)/12)
    fit <- nnetar(p = p, P = P, size = size, x = xshort, repeats = 10)
    fcast <- forecast(fit, h=12)
    mae[i] <- mean(abs(fcast[['mean']]-xnext))
    
  }
  
  c(p, P, size, mean(mae))
}
fin <- Sys.time() - ini
fin
stopCluster(cl)

results <- as.data.frame(x)
names(results) <- c("p", "P", "size", "MAE_mean")
library(forecast)

load("data.RData")
training <- window(data, end = c(2012,12))
testing <- window(data, start = 2013)


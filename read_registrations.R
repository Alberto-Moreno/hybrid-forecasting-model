data <- read.csv("registrations.csv", skip = 4) # Read the File
data <- data[,2] # Extract from the file only the registration figures
data <- rev(data) # Reverse the order of the vector, since in the original file they were ordered from latest to newest
data <- ts(data, start = 1990, frequency = 12) # Coerce the data into a time series (ts) variable

## Split the dataset into two separate time series variables, one for training and one for testing
training <- window(data, end = c(2012,12))
testing <- window(data, start = 2013)
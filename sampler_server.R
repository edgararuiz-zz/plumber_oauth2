library(plumber)
r <- plumb("sample_plumber.R")  
r$run(port=1410)


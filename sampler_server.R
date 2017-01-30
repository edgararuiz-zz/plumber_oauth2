

library(plumber)
r <- plumb("sample_plumber.R") 
r$addGlobalProcessor(sessionCookie("secret", "token"))
r$addGlobalProcessor(sessionCookie("secret", "email"))
r$run(port=1410)


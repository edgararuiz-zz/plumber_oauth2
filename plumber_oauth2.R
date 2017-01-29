library(jsonlite)
library(plumber)
library(httr)
library(openssl)

identify_user <- function(req, code=""){
  
  if(is.null(req$session$token) & code==""){
    url <-paste("https://accounts.google.com/o/oauth2/v2/auth?",
                "client_id=1085813435165-epc453ido1lo0amaiu9v9o78l9evq50t.apps.googleusercontent.com&",
                "response_type=code&",
                "scope=openid%20email&",
                "redirect_uri=http://localhost:1410/new&",
                "state=token", sep="")
    BROWSE(url)        
  }
  
  
  
  
  if(is.null(req$session$token) & code!=""){
    
    
    #-------------------------------- Googla OAuth -----------------------------------------------
    
    url <- "https://www.googleapis.com/oauth2/v4/token"
    body <- list("code"=code,
                 "client_id"="1085813435165-epc453ido1lo0amaiu9v9o78l9evq50t.apps.googleusercontent.com",
                 "client_secret"="aQMrJBuVkvHMBnDeNB__M5ws",
                 "redirect_uri"="http://localhost:1410/new",
                 "grant_type"="authorization_code")
    r <- POST(url, body = body, encode = "form")
    r_resp <- fromJSON(content(r, "text", encoding = "ISO-8859-1"))
    
    req$session$token <- r_resp$access_token
    
    #return(req$session$token)
  }
  
  
  
  if(!is.null(req$session$token)){
    r <- GET("https://www.googleapis.com/oauth2/v1/userinfo", query=list("alt"="json", "access_token"=req$session$token))
    new_resp <- content(r, "text", encoding = "ISO-8859-1")
    return(fromJSON(new_resp))
  }}
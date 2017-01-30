library(jsonlite)
library(plumber)
library(httr)
library(openssl)




identify_user <- function(req, code=""){
  
  # Load OAuth2.0 credentials
  load("creds.rds")
  
  # Scenario 1 - No session token and no code - User redirected to Google OAuth
  if(is.null(req$session$token) & code==""){
    url <-paste("https://accounts.google.com/o/oauth2/v2/auth?",
                "client_id=", google_credentials$client_id,"&",
                "response_type=code&",
                "scope=openid%20email&",
                "redirect_uri=", google_credentials$redirect_uri,"&",
                "state=token", sep="")
    BROWSE(url)        
  }
  
  
  
  # Scenario 2 - Has a authorization code - After user accepts the Google prompt to pass identity data
  if(is.null(req$session$token) & code!=""){
    url <- "https://www.googleapis.com/oauth2/v4/token"
    body <- list("code"=code,
                 "client_id"=google_credentials$client_id,
                 "client_secret"=google_credentials$client_secret,
                 "redirect_uri"=google_credentials$redirect_uri,
                 "grant_type"="authorization_code")
    r <- POST(url, body = body, encode = "form")
    r_resp <- fromJSON(content(r, "text", encoding = "ISO-8859-1"))
    
    req$session$token <- r_resp$access_token

  }
  
  
  # Scenario 3 - A token is available - The function passes a list variable with all the data Google provided
  if(!is.null(req$session$token)){
    r <- GET("https://www.googleapis.com/oauth2/v1/userinfo", query=list("alt"="json", "access_token"=req$session$token))
    new_resp <- content(r, "text", encoding = "ISO-8859-1")
    return(fromJSON(new_resp))
    
  }}



cache_credentials <- function(client_id,client_secret,redirect_uri)
{
  google_credentials <- data.frame(client_id=client_id, client_secret=client_secret, redirect_uri=redirect_uri
                                   , stringsAsFactors = FALSE)
  save(google_credentials, file="creds.rds")
} 


build_url <- function(){
  # Load OAuth2.0 credentials
  load("creds.rds")
  url <-paste("https://accounts.google.com/o/oauth2/v2/auth?",
                "client_id=", google_credentials$client_id,"&",
                "response_type=code&",
                "scope=openid%20email&",
                "redirect_uri=", google_credentials$redirect_uri,"&",
                "state=token", sep="")
   return(url)      
}
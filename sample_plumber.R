

#* @get /login
function(req, code=""){
  user <- identify_user(req, code)
  
  print(paste("Welcome ", user$email))
  
}

#* @get /second
function(req){
  
  if(is.null(req$session$email ))identify_user(req)
    
  print(req$session$email)
  
}

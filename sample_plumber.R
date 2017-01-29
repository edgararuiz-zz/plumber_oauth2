#* @get /new
function(req, code=""){
  user <- identify_user(req, code)
  
  print(user$email)
  
}

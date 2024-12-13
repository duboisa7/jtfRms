
#' Set JotForm API Key
#'
#' This function stores the JotForm API Key in .Rprofile.
#'
#' @param key A string value of the JotForm API key.
#' @export
set_key <- function(key){
  options("jf_api_key" = key)
  message("API key set successfully")
}


#' Retrieve JotForm API Key
#'
#' This function checks if a JotForm API Key is stored in .Rprofile.
#'
#' @export
get_key <- function(){

  if (is.null(getOption("jf_api_key"))) {
    stop("API key not set. Use set_key().")
  } else{
  message("An existing JotForm API key is stored in .Rprofile.")
  }
}



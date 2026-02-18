
#' Set JotForm API Key
#'
#' This function stores the JotForm API Key in .Rprofile.
#'
#' @export
set_key <- function(){
  key <- askpass::askpass("Please enter your JotForm API key.")

  if(is.null(key) || key == "") {
    message("API key set cancelled by user.")
  } else {
    options("jf_api_key" = key)
    message("API key set successfully.")
  }
}


#' Retrieve JotForm API Key
#'
#' This function checks if a JotForm API Key is stored in .Rprofile.
#'
#' @export
key_exists <- function(){
  if (is.null(getOption("jf_api_key"))) {
    stop("API key not set. Use set_key() to store API key before making a request.")
  } else{
    message("An existing JotForm API key is stored in .Rprofile.")
  }
}

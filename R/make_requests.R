#' Create a HTTP request
#'
#' This function creates a HTTP request to send to JotForm.
#'
#' @param url_type A string value: "standard", "EU", or "HIPAA". "standard" is the default value.
#' @param form_id A string value. Default value is NULL. This is the series of digits that can be found at the end of the form URL. If form IDs are unknown, create a HTTP request of request_type = "form_list". This will return a list of forms and includes the form ID for each.
#' @param request_type A string value: "form_list", "form", or "submissions". Default value is "form_list". "form_list" returns all user form data up to the specified or default limit. "form" returns properties of a specified form. "submissions" returns submission data of a specified form.
#' @param limit A numeric value between 1-1000. Default value is NULL. JotForm by default will pull data on up to 20 content types, i.e. data on 20 forms, 20 submissions, etc. Use this field to increase or decrease data pulled.
#' @returns An HTTP response object. Contains metadata, headers, and body of the response.
#' @export

create_request <- function(url_type = "standard", form_id = NULL, request_type = "form_list", limit = NULL){

  if(is.null(getOption("jf_api_key"))) {
    stop("API key not set. Use set_key() to store API key before making a request.")
  } else {

  apikey <- getOption("jf_api_key")
  headers <- list(APIKEY = apikey)

  base <- if(url_type == tolower("standard")){

    paste0("https://api.jotform.com")

  } else if(url_type == tolower("eu")){
    paste0("https://eu-api.jotform.com")

  } else if(url_type == tolower("hipaa")){
    paste0("https://hipaa-api.jotform.com")

  } else {
    stop("URL type invalid. Options are 'standard', 'eu', or 'hipaa'.")
  }

  endpt <- if(request_type == tolower("form_list")){

    paste0("/user/forms?")

  } else if(request_type == tolower("form") && is.null(form_id)){
    stop("form_id must be supplied for request_type 'form'.")
  } else if(request_type == tolower("form") && !is.null(form_id)){
    paste0("/form/", form_id, "?")

    # TODO add question parsing to parse_content() before uncommenting
  # } else if(request_type == tolower("questions") && is.null(form_id)){
  #   stop("form_id must be supplied for request_type 'questions'.")
  # } else if(request_type == tolower("questions") && !is.null(form_id)){
  #   paste0("/form/", form_id, "/questions?")

  } else if(request_type == tolower("submissions") && is.null(form_id)){
    stop("form_id must be supplied for request_type 'submissions'.")
  } else if(request_type == tolower("submissions") && !is.null(form_id)){
    paste0("/form/", form_id, "/submissions?")

  } else {
    stop("Request type invalid. Options are 'form_list', 'form', 'submissions'. \n 'form' and 'submissions' require the form_id argument.")
  }

  return_limit <- if(!is.null(limit) && is.numeric(limit) == FALSE){
    stop("Limit must be a number between 1-1000.")
  } else {
    paste0("limit=", limit)
  }

  url <- if(is.null(limit)){
    paste0(base, endpt)
  } else {
    paste0(base, endpt, return_limit)
  }

}

httr2::request(url) |>
  httr2::req_headers(!!!headers) |>
  httr2::req_perform()

}



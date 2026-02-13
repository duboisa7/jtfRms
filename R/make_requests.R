#' Create a HTTP request
#'
#' This function creates a HTTP request to send to JotForm.
#'
#' @param url_type A string value: "standard", "EU", "HIPAA", or "custom". "standard" is the default value.
#' @param form_id A string value. Default value is NULL. This is the series of digits that can be found at the end of the form URL. If form IDs are unknown, create a HTTP request of request_type = "form_list". This will return a list of forms and includes the form ID for each.
#' @param request_type A string value: "form_list", "form", or "submissions". Default value is "form_list". "form_list" returns all user form data up to the specified or default limit. "form" returns properties of a specified form. "submissions" returns submission data of a specified form.
#' @param limit A numeric value between 1-1000. Default value is NULL. JotForm by default will pull data on up to 20 content types, i.e. data on 20 forms, 20 submissions, etc. Use this field to increase or decrease data pulled.
#' @returns An HTTP response object. Contains metadata, headers, and body of the response.
#' @export

create_request <- function(url_type = "standard", form_id = NULL, request_type = "form_list", limit = NULL){

  if(is.null(getOption("jf_api_key"))) {
    stop("API key not set. Use jtfRms::set_key() to store API key before making a request.", call. = FALSE)
  }

  apikey <- getOption("jf_api_key")
  headers <- list(APIKEY = apikey)

  base <- switch(
    url_type,
    standard = "https://api.jotform.com",
    eu = "https://eu-api.jotform.com",
    hipaa = "https://hipaa-api.jotform.com",
    stop("URL type invalid. Options are 'standard', 'eu', or 'hipaa'.", call. = FALSE)
  )

  # TODO Figure out how to handle custom bases. Would need to make a custom_base param or something

  endpt <- if(request_type == "form_list"){
    paste0("/user/forms?")

    } else if(request_type == "form"){
      if(is.null(form_id)) {
        stop(
          "form_id must be supplied for request_type 'form'.\n**HINT: Use create_request(request_type = 'form_list') first to see form IDs.**",
          call. = FALSE
          )
        }
    paste0("/form/", form_id, "?")

    # TODO add question parsing to parse_content() before uncommenting
  # } else if(request_type == tolower("questions") && is.null(form_id)){
  #   stop("form_id must be supplied for request_type 'questions'.")
  # } else if(request_type == tolower("questions") && !is.null(form_id)){
  #   paste0("/form/", form_id, "/questions?")

  } else if(request_type == "submissions"){
    if(is.null(form_id)) {
      stop(
        "form_id must be supplied for request_type 'form'.\n**HINT: Use create_request(request_type = 'form_list') first to see form IDs.**",
        call. = FALSE
      )
    }
    paste0("/form/", form_id, "/submissions?")

  } else {
    stop(
      "Request type invalid. Options are 'form_list', 'form', 'submissions'.\n'form' and 'submissions' require the form_id argument.",
      call. = FALSE
      )
  }

if(!is.null(limit)) {
  if (!is.numeric(limit) || length(limit) != 1 || is.na(limit) || limit < 1 || limit > 1000) {
    stop("If indicating a limit, it must be a number between 1-1000.", call. = FALSE)
  }
}

  url <- if(is.null(limit)){
    paste0(base, endpt)
  } else {
    paste0(base, endpt, "limit=", limit)
  }

httr2::request(url) %>%
  httr2::req_headers(!!!headers) %>%
  httr2::req_perform()

}



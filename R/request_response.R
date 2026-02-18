#' Send an HTTP request and get a JSON response
#'
#' This function creates an HTTP request, sends it to JotForm, and returns the JSON response.
#'
#' @param url_type A string value: "standard", "EU", "HIPAA", or "custom". "standard" is the default value.
#' @param form_id A string value. Default value is NULL. This is the series of digits that can be found at the end of the form URL. If form IDs are unknown, create a HTTP request of request_type = "form_list". This will return a list of forms and includes the form ID for each.
#' @param request_type A string value: "form_list", "form", or "submissions". Default value is "form_list". "form_list" returns all user form data up to the specified or default limit. "form" returns properties of a specified form. "submissions" returns submission data of a specified form.
#' @param limit A numeric value between 1-1000. Default value is NULL. JotForm by default will pull data on up to 20 content types, i.e. data on 20 forms, 20 submissions, etc. Use this field to increase or decrease data pulled.
#' @returns A JSON response object. Contains response metadata and body of the response.
#' @export
#'
#'
get_response <- function(
    url_type = "standard",
    form_id = NULL,
    request_type = "form_list",
    limit = NULL#,
    #capacity = NULL
){

  if(is.null(getOption("jf_api_key"))) {
    stop(
      "API key not set. Use set_key() to store API key before making a request.",
      call. = FALSE
    )
  }

  apikey <- getOption("jf_api_key")
  headers <- list(APIKEY = apikey)

  base <- switch(
    url_type,
    standard = "https://api.jotform.com",
    eu = "https://eu-api.jotform.com",
    hipaa = "https://hipaa-api.jotform.com",
    stop(
      "URL type invalid. Options are 'standard', 'eu', or 'hipaa'.",
      call. = FALSE
    )
  )

  if(request_type == "form" & is.null(form_id)){
    stop("A form ID must be supplied for request types of 'form' and 'submissions'.\n
      HINT: Use get_response(request_type = 'form_list') first to see form IDs.",
         call. = FALSE
    )
  }

  if(request_type == "submissions" & is.null(form_id)){
    stop("A form ID must be supplied for request types of 'form' and 'submissions'.\n
      HINT: Use get_response(request_type = 'form_list') first to see form IDs.",
         call. = FALSE
    )
  }

  endpt <- switch(
    request_type,
    form_list = "/user/forms?",
    form = paste0("/form/", form_id, "?"),
    submissions = paste0("/form/", form_id, "/submissions?"),
    stop(
      "Request type invalid. Options are 'form_list', 'form', or 'submissions'.",
      call. = FALSE
    )
  )

  if(!is.null(limit)) {
    if (
      !is.numeric(limit) || length(limit) != 1 ||
      is.na(limit) || limit < 1 || limit > 1000
    ) {
      stop(
        "If indicating a limit, it must be a number between 1-1000.",
        call. = FALSE
      )
    }
  }

  url <- if(is.null(limit)){
    paste0(base, endpt)
  } else {
    paste0(base, endpt, "limit=", limit)
  }

  # if(!is.null(capacity)) {
  #   if(!is.numeric(capacity) || length(capacity != 1) || is.na(capacity) || capacity < 1
  # }
  #   stop("API call limits start at 1000/day for JotForm free.")
  httr2::request(url) %>%
    httr2::req_headers(!!!headers) %>%
    #httr2::req_throttle(capacity = 1000, fill_time_s = 86400) %>%
    httr2::req_perform() %>%
    httr2::resp_body_json()

  #data.frame(url = url, base = base, endpt = endpt)

}

#' Parse response and return as data frame
#'
#' This function takes the JotForm HTTP response object, extracts the body as a parsed JSON, and returns a data frame of the specified JotForm data.
#'
#' @param request A HTTP response object created by [create_request()].
#' @param type A string value: "form_list", "form", or "submissions". "form_list" returns a list of the user's forms. "form" returns properties of a specified form. "submissions" returns submission data of a specified form.
#' @returns A data frame containing the data type specified in the "type" argument.
#' @export

parse_to_df <- function(request, type){

  json_req <- httr2::resp_body_json(request)

  if(type == "form_list") {
    content <- json_req[["content"]]

    return(
      do.call(rbind, lapply(content, rbind)) |>
        as.data.frame()
      )

  } else if(type == "form"){

    return(
     as.data.frame(json_req[["content"]])
    )

  } else if(type == "submissions"){
    content <- json_req[["content"]]

    submission_data <- do.call(rbind, lapply(content, function(submission){

      form_id <- submission$form_id
      submission_id <- submission$id
      created_at <- submission$created_at
      response_data <- submission$answers

      valid_data <- lapply(response_data, function(response){

        if(all(c("text", "answer") %in% names(response))){

          return(
            data.frame(
              form_id = form_id,
              submission_id = submission_id,
              created_at = created_at,
              question = response$text,
              answer = response$answer
              )
            )
        }
      return(NULL)
    })
      do.call(rbind, valid_data) |>
        stats::reshape(
          idvar = c("form_id", "submission_id", "created_at"),
          timevar = "question",
          direction = "wide"
        ) |>
        (\(valid_data) {
          names(valid_data) <- gsub("answer\\.", "", names(valid_data))
          valid_data
        })()
    }))


  } else {

    stop("'type' argument is invalid. Options are 'form_list', 'form', or 'submissions.'")
  }

}

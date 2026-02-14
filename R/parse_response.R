#' Parse response and return as data frame
#'
#' This function takes the JotForm HTTP response object, extracts the body as a parsed JSON, and returns a data frame of the specified JotForm data.
#'
#' @param request A HTTP response object created by [jtfRms::create_request()].
#' @param type A string value: "form_list", "form", or "submissions". "form_list" returns a list of the user's forms. "form" returns properties of a specified form. "submissions" returns submission data of a specified form.
#' @param pivot A string value used only for type = "submissions". Determines shape of final dataframe, options are "wide" or "long".
#' @returns A data frame containing the data type specified in the "type" argument.
#' @export

parse_to_df <- function(request, type, pivot){

  json_resp <- httr2::resp_body_json(request)
  content <- json_resp[["content"]]

  if(type == "form_list") {
    return((content))

    } else if(type == "form"){
      return(as.data.frame(content))

      } else if(type == "submissions"){
        submission_data <- do.call(rbind, lapply(content, function(submission){
          form_id <- submission$form_id
          submission_id <- submission$id
          created_at <- submission$created_at
          answers <- submission$answers

          if(is.null(answers) || !is.list(answers) ||length(answers) == 0) return(NULL)

          rows <- lapply(answers, function(survey_obj){
            if(!is.null(survey_obj$type) && survey_obj$type %in% c("heading", "control_head", "control_button")) return(NULL)
            if(is.null(survey_obj$text) || length(survey_obj$text) == 0) return(NULL)

            an_answer <- survey_obj$answer
            an_answer_chr <- if(is.null(an_answer) || length(an_answer) == 0) {
              NA_character_

              } else if(is.list(an_answer)) {
                paste(unlist(an_answer, use.names = FALSE), collapse = "; ")
                } else {
                  paste(as.character(an_answer), collapse = "; ")
                  }

            return(data.frame(
              form_id = form_id,
              submission_id = submission_id,
              created_at = created_at,
              question = as.character(survey_obj$text)[1],
              answer = an_answer_chr,
              stringsAsFactors = FALSE
              ))
            })

          rows <- Filter(Negate(is.null), rows)
          if(length(rows) == 0) return(NULL)

          return(do.call(rbind, rows))
          }))

        if(is.null(submission_data) || nrow(submission_data) == 0) {
          submission_data <- data.frame(
            form_id = character(),
            submission_id = character(),
            created_at = character(),
            stringsAsFactors = FALSE
            )
          } else {

            if(pivot == "wide"){
              submission_data <- stats::reshape(
                submission_data,
                idvar = c("form_id", "submission_id", "created_at"),
                timevar = "question",
                direction = "wide"
                )
              names(submission_data) <- sub("^answer\\.", "", names(submission_data))

              return(submission_data)
              } else {

                return(submission_data)
              }
            }
        } else {
          stop("'type' argument is invalid. Options are 'form_list', 'form', or 'submissions.'")
        }
  }

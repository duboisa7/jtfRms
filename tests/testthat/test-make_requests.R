test_that("create_request() errors if API key is NULL", {
  withr::local_options(jf_api_key = NULL)

  expect_error(
    create_request(),
    "API key not set. Use set_key() to store API key before making a request."
    )
})

test_that("create_request() errors on invalid url_type", {
  withr::local_options(jf_api_key = "example_api_key")

  expect_error(
    create_request(url_type = "not_a_valid_type"),
    "URL type invalid. Options are 'standard', 'eu', or 'hipaa'."
    )
})

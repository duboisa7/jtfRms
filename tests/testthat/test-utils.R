testthat::test_that("set_key() stores API key in options", {
  set_key("123")
  testthat::expect_equal(getOption("jf_api_key"), "123")
})

testthat::test_that("set_key displays success message", {
  testthat::expect_message(set_key("12345"), "API key set successfully")
})


testthat::test_that("get_key() output is stable", {

  # If jf_api_key is missing
  withr::local_options(jf_api_key = NULL)
  testthat::expect_snapshot_error(get_key())

  # If a jf_api_key is stored in options
  withr::local_options(jf_api_key = "123")
  testthat::expect_snapshot(get_key())
})

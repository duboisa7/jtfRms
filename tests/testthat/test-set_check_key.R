# testthat::test_that("set_key() stores API key in options", {
#   set_key("example_api_key")
#   testthat::expect_equal(getOption("jf_api_key"), "example_api_key")
# })

# testthat::test_that("set_key displays success message", {
#   testthat::expect_message(set_key(), "API key set successfully")
# })


testthat::test_that("key_exists() output is stable", {

  # If jf_api_key is missing
  withr::local_options(jf_api_key = NULL)
  testthat::expect_snapshot_error(key_exists())

  # If a jf_api_key is stored in options
  withr::local_options(jf_api_key = "example_api_key")
  testthat::expect_snapshot(key_exists())
})

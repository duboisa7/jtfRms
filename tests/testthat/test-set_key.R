testthat::test_that("set_key stores API key in options", {
  set_key("123")
  testthat::expect_equal(getOption("jf_api_key"), "123")
})

testthat::test_that("set_key displays a success message", {
  testthat::expect_message(set_key("12345"), "API key set successfully")
})

test_that("Errors appropriately for missing file", {
  parts <- parse_m365_url_components(site_csv_url)
  site_url <- parts$site_url
  expect_error(
    find_item_in_any_doclib(site_url, "file_that_does_not_exist_12345.csv"),
    "not found"
  )
})

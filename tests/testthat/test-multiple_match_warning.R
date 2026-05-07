test_that("Warning is given for multiple matching files", {
  if (is.na(site_csv_url)) skip("No SharePoint site_csv_url available.")

  site_url <- parse_m365_url_components(site_csv_url)$site_url

  expect_warning(
    find_item_in_any_doclib(site_url, "DuplicateFile.txt"),
    "found in drives/paths"
  )
})

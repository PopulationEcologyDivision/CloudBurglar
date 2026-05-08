test_that("Document library names are normalized correctly", {
  if (is.na(site_csv_url)|is.na(personal_csv_url)) skip("No SharePoint test url")
  personal_url <- parse_m365_url_components(personal_csv_url)$site_url
  site_url <- parse_m365_url_components(site_csv_url)$site_url

  # Team site: "Shared Documents" → "Documents"
  expect_equal(
    normalize_doclib_name(site_url, "Shared Documents"),
    "Documents"
  )

  # Personal site: "Documents" or anything else → "OneDrive"
  expect_equal(
    normalize_doclib_name(personal_url, "Documents"),
    "OneDrive"
  )
  expect_equal(
    normalize_doclib_name(personal_url, "x"),  # even an arbitrary doclib name
    "OneDrive"
  )
})

test_that("URL parsing succeeds for each link type", {
  if (!is.na(site_csv_url)) {
    parts1 <- parse_m365_url_components(site_csv_url)
    expect_match(parts1$site_url, "sharepoint.com/sites/")
    expect_true(grepl("csv", parts1$file_path_in_library))
  }
  if (!is.na(site_nested_rds_url)) {
    parts2 <- parse_m365_url_components(site_nested_rds_url)
    expect_match(parts2$site_url, "sharepoint.com/sites/")
    expect_true(grepl("sample_survey.rds", parts2$file_path_in_library))
  }
  if (!is.na(personal_csv_url)) {
    parts3 <- parse_m365_url_components(personal_csv_url)
    expect_match(parts3$site_url, "sharepoint.com/personal/")
    expect_true(grepl("csv", parts3$file_path_in_library))
  }
  if (!is.na(personal_download_jpg_url)) {
    parts4 <- parse_m365_url_components(personal_download_jpg_url)
    expect_match(parts4$site_url, "sharepoint.com/personal/")
    expect_true(grepl("jpg", parts4$file_path_in_library))
  }
})

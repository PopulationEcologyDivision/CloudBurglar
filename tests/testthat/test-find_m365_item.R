test_that("find_m365_item locates SharePoint and OneDrive files", {
  if (!is.na(site_csv_url)) {
    item1 <- find_m365_item(site_csv_url)
    expect_true(!is.null(item1))
    expect_true("properties" %in% names(item1))
    expect_match(item1$properties$name, "csv$")
  }
  if (!is.na(site_nested_rds_url)) {
    item2 <- find_m365_item(site_nested_rds_url)
    expect_true(!is.null(item2))
    expect_match(item2$properties$name, "rds$")
  }
  if (!is.na(personal_csv_url)) {
    item3 <- find_m365_item(personal_csv_url)
    expect_true(!is.null(item3))
    expect_match(item3$properties$name, "csv$")
  }
  if (!is.na(personal_download_jpg_url)) {
    item4 <- find_m365_item(personal_download_jpg_url)
    expect_true(!is.null(item4))
    expect_match(item4$properties$name, "jpg$")
  }
})

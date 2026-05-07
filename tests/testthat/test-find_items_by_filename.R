test_that("find_items_by_filename finds expected files", {
  if (!is.na(site_csv_url)) {
    parts <- parse_m365_url_components(site_csv_url)
    site <- get_sharepoint_site(site_url = parts$site_url)
    drv  <- site$get_drive(parts$document_library_name)
    found <- find_items_by_filename(drv, "testShareFile.csv")
    expect_true(length(found) > 0)
    expect_true(any(vapply(found, function(x) grepl("testShareFile.csv", x$path), logical(1))))
  }
})

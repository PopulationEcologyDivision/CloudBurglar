test_that("Can load a CSV from a SharePoint site", {
  if (is.na(site_csv_url)) skip("No site_csv_url set.")
  df <- load_m365_file(site_csv_url)
  expect_s3_class(df, "data.frame")
  expect_true(ncol(df) > 0)
})

test_that("Can load a CSV from a personal OneDrive", {
  if (is.na(personal_csv_url)) skip("No personal_csv_url set.")
  df <- load_m365_file(personal_csv_url)
  expect_s3_class(df, "data.frame")
})

test_that("Can load an RDS from nested folder in site", {
  if (is.na(site_nested_rds_url)) skip("No site_nested_rds_url set.")
  obj <- load_m365_file(site_nested_rds_url)
  expect_true(is.list(obj) || is.data.frame(obj) || is.vector(obj))
})

test_that("Can download an image file from personal OneDrive", {
  if (is.na(personal_download_jpg_url)) skip("No personal_download_jpg_url set.")
  out <- load_m365_file(personal_download_jpg_url)
  expect_true(file.exists(out))
  expect_match(out, "\\.jpg$")
  unlink(out) # Clean up
})

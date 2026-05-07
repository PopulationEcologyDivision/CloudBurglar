test_that("Downloaded files are cleaned up", {
  if (is.na(personal_download_jpg_url)) skip("No test image url available")

  out_path <- load_m365_file(personal_download_jpg_url)
  expect_true(file.exists(out_path))

  unlink(out_path)
  expect_false(file.exists(out_path))
})

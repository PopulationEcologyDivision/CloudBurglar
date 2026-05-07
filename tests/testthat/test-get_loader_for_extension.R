test_that("Correct loader returned for file types", {
  # All loaders should return functions
  for (ext in c("csv", "tsv", "txt", "xlsx", "xls", "rds", "rda", "rdata", "jpg")) {
    loader <- get_loader_for_extension(ext)
    expect_type(loader, "closure")
  }
  # .jpg should not be a data loader
  loader_jpg <- get_loader_for_extension("jpg")
  expect_true(is.function(loader_jpg))
})

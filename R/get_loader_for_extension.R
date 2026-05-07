#' get_loader_for_extension
#'
#' @title get_loader_for_extension
#'
#' @description get_loader_for_extension returns an appropriate handler function for a given file extension.
#'
#' Supported file types and their behavior:
#' \itemize{
#'   \item \strong{csv, txt, tsv}: Loaded as data frames.
#'   \item \strong{xlsx, xls}: Loaded as data frames (first sheet by default).
#'   \item \strong{rds}: Loaded using \code{readRDS()}.
#'   \item \strong{rda, rdata}: Loaded into the global environment (\code{load()}).
#' }
#' All other file types (including \code{R}, \code{Rmd}, images, etc.) will be downloaded to the user's working directory.
#'
#' @param ext default is \code{NULL}. The file extension (e.g., "csv", "xlsx").
#'
#' @return A function that loads the file into R if supported, otherwise downloads it.
#'
#' @author Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
get_loader_for_extension <- function(ext) {
  ext <- tolower(ext)
  loader_map <- list(
    csv   = function(itm, ...) { itm$load_dataframe(show_col_types = FALSE, ...) },
    tsv   = function(itm, ...) { itm$load_dataframe(delim = "\t", show_col_types = FALSE, ...) },
    txt   = function(itm, ...) { itm$load_dataframe(show_col_types = FALSE, ...) },
    xlsx  = function(itm, ...) { itm$load_dataframe(...) },
    xls   = function(itm, ...) { itm$load_dataframe(...) },
    rds   = function(itm, ...) { itm$load_rds() },
    rda   = function(itm, ...) { itm$load_rdata(...) },
    rdata = function(itm, ...) { itm$load_rdata(...) }
    # Add more file types as needed
  )
  if (ext %in% names(loader_map)) {
    loader_map[[ext]]
  } else {
    function(itm, ...) {
      fname <- itm$properties$name
      outpath <- file.path(getwd(), fname)
      itm$download(outpath, overwrite = TRUE)
      message("Downloaded to: ", outpath)
      invisible(outpath)
    }
  }
}

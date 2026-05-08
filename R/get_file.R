#' get_file
#'
#' @title get_file
#'
#' @description Loads or downloads a SharePoint/OneDrive file given a sharing URL.
#'
#' @param file_url default is \code{NULL}. The file's full sharepoint/onedrive sharing URL.
#' @param library default is \code{NULL}. Optionally, the document library to search within (e.g. "Documents").
#' @param ... Extra arguments passed to the relevant file loader (e.g., csv, excel, etc)
#'
#' @return The loaded R object, data.frame, or path to downloaded file.
#'
#' @author Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
#' @export
get_file <- function(file_url, library = NULL, ...) {
  itm <- find_m365_item(file_url, library)
  fname <- itm$properties$name
  ext <- tolower(tools::file_ext(fname))
  loader_fun <- get_loader_for_extension(ext)
  loader_fun(itm, ...)
}

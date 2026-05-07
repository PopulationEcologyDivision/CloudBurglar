#' find_m365_item
#'
#' @title find_m365_item
#'
#' @description Finds a file item on SharePoint/OneDrive from a submitted URL.
#'
#' @param file_url default is \code{NULL}. The file's sharing URL.
#' @param library default is \code{NULL}. Optionally, the document library name.
#'
#' @return The found file item object, or error if not found.
#'
#' @author Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
#' @importFrom Microsoft365R get_sharepoint_site
find_m365_item <- function(file_url, library = NULL) {
  parsed_url_parts <- parse_m365_url_components(file_url)
  site_url <- parsed_url_parts$site_url
  file_path <- parsed_url_parts$file_path_in_library
  doclib <- normalize_doclib_name(site_url, if (!is.null(library)) library else parsed_url_parts$document_library_name)
  site <- get_sharepoint_site(site_url=site_url)
  if (is.null(doclib)) {
    filename <- basename(file_path)
    res <- find_item_in_any_doclib(site_url, filename)
    itm <- res$item
    doclib <- res$drive_name
    file_path <- res$path
    message(sprintf("File %s found in library '%s', path '%s'.", filename, doclib, file_path))
  } else {
    drv <- site$get_drive(drive_name=doclib)
    filename <- basename(file_path)
    if (file_path %in% c(filename, paste0("/", filename))) {
      res <- find_items_by_filename(drv, filename)
      if (length(res) == 0) stop(sprintf("File %s not found in library %s", filename, doclib))
      if (length(res) > 1) {
        warning(sprintf("File %s found in multiple locations in library %s:\n  %s\nReturning the first found.",
                        filename, doclib,
                        paste(vapply(res, function(x) x$path, character(1)), collapse="\n  ")))
      }
      itm <- res[[1]]$item
      file_path <- res[[1]]$path
    } else {
      # ---- Minimal OneDrive path fix ----
      if (grepl("/personal/", site_url)) {
        file_path <- sub("^/?Documents/", "", file_path)
      }
      file_path <- sub("^/", "", file_path)
      itm <- drv$get_item(file_path)
    }
  }
  itm
}

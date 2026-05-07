#' find_item_in_any_doclib
#'
#' @title find_item_in_any_doclib
#'
#' @description Recursively searches all document libraries in a SharePoint site for a filename.
#'
#' @param site_url default is \code{NULL}. The base site URL.
#' @param target_filename default is \code{NULL}. The filename to look for.
#' @param verbose default is \code{TRUE}. Whether to display progress messages.
#'
#' @return List with found item and its drive/path.
#'
#' @author Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
#' @importFrom Microsoft365R get_sharepoint_site
find_item_in_any_doclib <- function(site_url, target_filename, verbose = TRUE) {
  site <- get_sharepoint_site(site_url=site_url)
  drives <- site$list_drives()
  all_found <- list()
  for (drv in drives) {
    found <- find_items_by_filename(drv, target_filename)
    if (length(found) > 0) {
      for (m in found) {
        all_found[[paste0(drv$properties$name, m$path)]] <- list(drive_name = drv$properties$name, item = m$item, path = m$path)
      }
    }
  }
  if (length(all_found) == 0) {
    stop(sprintf("File %s not found in any document library in site %s", target_filename, site_url))
  }
  drive_names <- unique(vapply(all_found, function(x) x$drive_name, character(1)))
  if (length(all_found) > 1) {
    warning(sprintf("File %s found in drives/paths:\n  %s\nReturning the first found.", target_filename,
      paste(sprintf("%s: %s",
                    vapply(all_found, function(x) x$drive_name, character(1)),
                    vapply(all_found, function(x) x$path, character(1))), collapse = "\n  ")
    ))
  }
  all_found[[1]]
}

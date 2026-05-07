#' find_items_by_filename
#'
#' @title find_items_by_filename
#'
#' @description Recursively searches a document library/drive for files matching a filename.
#'
#' @param drive default is \code{NULL}. Drive object to search.
#' @param target_filename default is \code{NULL}. Filename to look for.
#' @param parent_path default is \code{""}. Parent path to start in.
#' @param matches default is \code{list()}. Used internally during recursion. Ignore.
#'
#' @return List of found items, each with path and item.
#'
#' @author Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
find_items_by_filename <- function(drive, target_filename, parent_path = "", matches = list()) {
  items <- tryCatch({
    drive$list_files(parent_path)
  }, error = function(e) list())
  if (is.null(items) || length(items)==0) return(matches)
  if (is.data.frame(items)) {
    for (i in seq_len(nrow(items))) {
      item <- lapply(items, function(col) col[[i]])
      if (!is.null(item$isdir) && isTRUE(item$isdir)) item$folder <- TRUE
      if (!is.null(item$folder) && isTRUE(item$folder)) {
        new_parent <- if (parent_path == "") item$name else file.path(parent_path, item$name)
        matches <- find_items_by_filename(drive, target_filename, new_parent, matches)
      } else {
        if (identical(item$name, target_filename)) {
          match_path <- if (parent_path == "") paste0("/", item$name) else paste0("/", parent_path, "/", item$name)
          matches[[length(matches)+1]] <- list(item = drive$get_item(match_path), path = match_path)
        }
      }
    }
  } else if (is.list(items)) {
    for (i in seq_along(items)) {
      item <- items[[i]]
      if (is.list(item) && !is.null(item$name)) {
        if (!is.null(item$folder) && isTRUE(item$folder)) {
          new_parent <- if (parent_path == "") item$name else file.path(parent_path, item$name)
          matches <- find_items_by_filename(drive, target_filename, new_parent, matches)
        } else {
          if (identical(item$name, target_filename)) {
            match_path <- if (parent_path == "") paste0("/", item$name) else paste0("/", parent_path, "/", item$name)
            matches[[length(matches)+1]] <- list(item = drive$get_item(match_path), path = match_path)
          }
        }
      }
    }
  }
  matches
}

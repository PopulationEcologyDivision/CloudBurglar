#' normalize_doclib_name
#'
#' @title normalize_doclib_name
#'
#' @description Normalizes the document library name for different SharePoint or OneDrive site types.
#'
#' @param site_url default is \code{NULL}. The base site URL.
#' @param doclib default is \code{NULL}. Library name.
#'
#' @return Character, possibly adjusted library name.
#'
#' @author Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
normalize_doclib_name <- function(site_url, doclib) {
  # Assume NULL or missing library stays NULL
  if (is.null(doclib)) return(NULL)

  if (grepl("/personal/", site_url)) {
    # In personal sites, 'Documents' is the default library, so treat as NULL for lookups
    # if (identical(doclib, "Documents"))
      return("OneDrive")
  } else {
    # In team/sites, 'Shared Documents' is often referred to interchangeably with 'Documents'
    if (identical(doclib, "Shared Documents")) return("Documents")
  }
  doclib
}

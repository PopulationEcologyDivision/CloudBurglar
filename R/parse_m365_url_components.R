#' parse_m365_url_components
#'
#' @title parse_m365_url_components
#'
#' @description Parses a SharePoint or OneDrive sharing URL into its site, library, and file path components.
#'
#' @param file_url default is \code{NULL}. The sharing URL.
#'
#' @return List with \code{site_url}, \code{document_library_name}, \code{file_path_in_library}, and \code{library_unknown}.
#'
#' @author Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
#' @importFrom stringr str_extract str_split str_detect str_match
#' @importFrom utils URLdecode
parse_m365_url_components <- function(file_url) {
  domain_match <- str_extract(file_url, "https?://[^/]+")
  if (is.na(domain_match)) stop("could not find domain")
  url_path_only <- str_split(file_url, "\\?", simplify = TRUE)[1]
  path_only <- sub(paste0("^", domain_match), "", url_path_only)  # always starts with "/"
  site_path_match <- str_extract(file_url, "/(personal/[^/]+|sites/[^/]+)")
  if (is.na(site_path_match)) stop("could not find site path")
  site_url <- paste0(domain_match, site_path_match)
  if (str_detect(file_url, "_layouts/15/Doc.aspx")) {
    fname <- str_match(file_url, "[&?]file=([^&]+)")[,2]
    if (is.na(fname)) stop("No filename in share link query", call.=FALSE)
    doclib <- NULL
    file_path <- paste0("/", URLdecode(fname))
    library_unknown <- TRUE
  } else {
    path_segments <- unlist(strsplit(gsub("^/", "", path_only), "/"))
    sharing_style <- length(path_segments) > 4 && path_segments[1] %in% c(":x:", ":u:", ":t:") && path_segments[2] == "r" && path_segments[3] == "sites"
    if (sharing_style) {
      site_name <- path_segments[4]
      doclib <- URLdecode(path_segments[5])
      file_path <- paste0("/", paste(URLdecode(path_segments[-(1:5)]), collapse = "/"))
    } else {
      pos_sites <- which(path_segments == "sites")
      if (length(pos_sites) && (length(path_segments) >= pos_sites + 2)) {
        doclib <- URLdecode(path_segments[pos_sites + 2])
        file_path <- paste0("/", paste(URLdecode(path_segments[-seq_len(pos_sites + 2)]), collapse="/"))
      } else {
        pos_personal <- which(path_segments == "personal")
        if (length(pos_personal) && (length(path_segments) >= pos_personal + 1)) {
          doclib <- URLdecode(path_segments[pos_personal + 1])
          file_path <- paste0("/", paste(URLdecode(path_segments[-seq_len(pos_personal + 1)]), collapse="/"))
        } else {
          stop(
            sprintf(
              "CloudBurglar could not parse the submitted URL: '%s'.\n
    This may be an unsupported or new style of SharePoint/OneDrive link.
    Please check the URL and consult the package docs, or file an issue with this link example.",
              file_url
            ),
            call. = FALSE
          )
        }
      }
    }
    library_unknown <- FALSE
  }
  parsed <- list(
    site_url = site_url,
    document_library_name = normalize_doclib_name(site_url, doclib),
    file_path_in_library = file_path,
    library_unknown = library_unknown
  )
}

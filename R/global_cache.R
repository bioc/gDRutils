## This global cache maintains a cache of identifiers, 
## headers, and their respective values. 

global_cache <- new.env(parent = emptyenv())
global_cache$identifiers_list <- list() 

#############
# Identifiers
#############

#' @keywords internal
.get_ids <- function(ks) {
  out <- unname(vapply(ks, function(x) .get_id(x), character(1)))
  if (length(out) != length(ks)) {
    stop(sprintf("unequal returned identifiers: '%s' and input identifiers: '%s'", ks, out))
  }
  out
}


#' @keywords internal
.get_id <- function(k = NULL) {
  if (length(global_cache$identifiers_list) == 0L) {
    global_cache$identifiers_list <- IDENTIFIERS_LIST
  }
  
  if (!is.null(k)) {
    checkmate::assert_string(k, null.ok = TRUE)
    checkmate::assert_choice(k, choices = names(IDENTIFIERS_LIST))
    
    return(global_cache$identifiers_list[[k]])
  } else {
    return(global_cache$identifiers_list)
  }
}


#' @keywords internal
.set_id <- function(k, v) {
  valid_ids <- names(IDENTIFIERS_LIST)

  checkmate::assert_string(k, null.ok = FALSE)
  checkmate::assert_choice(k, choices = valid_ids)

  global_cache$identifiers_list[[k]] <- v
  invisible(NULL)
}


#' @keywords internal
.reset_ids <- function() {
  global_cache$identifiers_list <- IDENTIFIERS_LIST
  invisible(NULL)
}


##########
# Headers
##########

#' @keywords internal
.get_header <- function(k = NULL) {
  ## The following .getHeadersList() call is inside the function .get_header
  ## to avoid cyclical dependencies and collation order problems.
  headers <- .getHeadersList()
  if (!is.null(k)) {
    checkmate::assert_string(k, null.ok = TRUE)
    checkmate::assert_choice(k, choices = names(headers))
    out <- headers[[k]]
  } else {
    out <- headers
  }
  out
}

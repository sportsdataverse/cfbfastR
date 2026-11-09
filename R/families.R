# Family index pages.
#
# roxygen's `@family` writes every member of a family into the "See also" of
# every other member, so a family of n pages carries n^2 links. The ESPN CFB
# family has ~70 members, which made those lists the largest repeated block in
# the installed help. Its members carry `@concept ESPN CFB Functions` and one
# `@seealso` link to the index page below instead; the index lists the family
# once, built at document() time from the `@concept` tags in R/. Small families
# stay on `@family`.

#' Roxygen lines listing every function whose roxygen block carries
#' `@concept <family>` (roxygen `@eval`, run by `devtools::document()` from the
#' package root).
#'
#' A function counts when its block is followed by its definition
#' (`name <- function`), whether it has a page of its own or shares one through
#' `@rdname`.
#'
#' @param family The family name, exactly as in the `@concept` tags.
#' @return Character vector of roxygen lines.
#' @noRd
.family_index <- function(family) {
  fns <- character()
  for (path in sort(list.files("R", "[.][Rr]$", full.names = TRUE))) {
    l <- readLines(path, warn = FALSE)
    for (i in which(l == paste0("#' @concept ", family))) {
      j <- i
      while (j <= length(l) && startsWith(l[j], "#'")) j <- j + 1L
      m <- regmatches(l[j], regexec("^`?([A-Za-z][A-Za-z0-9._]*)`? *<- *function", l[j]))[[1]]
      if (length(m)) fns <- c(fns, m[2])
    }
  }
  fns <- sort(unique(fns))
  if (!length(fns)) stop("no function carries `@concept ", family, "`", call. = FALSE)
  c("@description",
    paste0("Every function in the ", family, " family (", length(fns), "):"),
    "",
    paste0("* [", fns, "()]"))
}

#' ESPN CFB Functions: family index
#'
#' @name family_espn_cfb
#' @eval .family_index("ESPN CFB Functions")
NULL

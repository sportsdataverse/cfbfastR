#' @name cfb_model_card
#' @title
#' **Read the published contract for a CFB model**
#' @description
#' Each model in the `cfb_model_artifacts` bundle ships a `<model>.card.json`
#' carrying the ordered `features` array it was trained with and, where the
#' model consumes one, an `era_contract`. Reading that contract lets a caller's
#' frame be validated against the artifact itself rather than a feature list
#' restated in this package -- the duplication that produced
#' cfbfastR-cfb-data#70, where this package kept a private 2017 era cut the
#' trainer never used and 2018-2020 scored an era off the models trained with
#' them.
#'
#' * `cfb_model_card()`: the parsed card.
#' * `cfb_card_features()`: the model's feature names, in trained order.
#' * `cfb_card_era_contract()`: the era encoding, or `NULL`.
#' * `cfb_card_reset_cache()`: drop the in-session card cache.
#'
#' @param model (*String* required): Bundle stem, e.g. `"ep_model"` or `"wp_spread"`.
#'
#' @return [cfb_model_card()] - A list with the card's fields, including:
#'
#'  |col_name      |types     |description                                                        |
#'  |:-------------|:---------|:------------------------------------------------------------------|
#'  |model_type    |character |Model family, e.g. "ep", "fg", "xpass".                            |
#'  |label         |character |Training label the model was fit against.                          |
#'  |features      |character |Ordered feature names the booster was trained with.                |
#'  |era_contract  |list      |Era encoding and cutpoints, or `NULL` when the model uses no era.  |
#'
#' @keywords CFB Model Card
#' @importFrom jsonlite fromJSON
#' @importFrom cli cli_abort
#' @family CFB Model Calculators
#' @export
#' @examples
#' \donttest{
#'   try(cfb_card_features("ep_model"))
#' }
cfb_model_card <- function(model) {
  cached <- .cfb_card_cache[[model]]
  if (!is.null(cached)) {
    return(cached)
  }
  card <- .read_card_json(model)
  assign(model, card, envir = .cfb_card_cache)
  card
}

#: In-session cache. The card is read on every calculator call, so re-parsing it
#: each time would put a file read in the hot path.
.cfb_card_cache <- new.env(parent = emptyenv())

.read_card_json <- function(model) {
  path <- .cfb_model_file(paste0(model, ".card.json"))
  if (is.null(path) || !file.exists(path)) {
    cli::cli_abort("No published card for {.val {model}}.")
  }
  jsonlite::fromJSON(path, simplifyVector = TRUE)
}

#' @rdname cfb_model_card
#' @return [cfb_card_features()] - A character vector of feature names in the
#'   order the booster was trained with. Order is load-bearing: xgboost aligns a
#'   DMatrix by position, so a sorted or re-derived list scores against the
#'   wrong columns without ever erroring.
#' @export
cfb_card_features <- function(model) {
  feats <- cfb_model_card(model)$features
  if (is.null(feats) || length(feats) == 0L) {
    cli::cli_abort("Card for {.val {model}} declares no features.")
  }
  as.character(feats)
}

#' @rdname cfb_model_card
#' @return [cfb_card_era_contract()] - A list with `encoding` (`"ordinal"` or
#'   `"one_hot"`), `columns` and `cuts`, or `NULL` when the model consumes no
#'   era feature. `NULL` is correct for `ep_model`, `wp_naive`, `wp_spread` and
#'   `cfb_cp_model`.
#' @export
cfb_card_era_contract <- function(model) {
  cfb_model_card(model)$era_contract
}

#' @rdname cfb_model_card
#' @return [cfb_card_reset_cache()] - Invisibly `NULL`, called for its effect.
#' @export
cfb_card_reset_cache <- function() {
  rm(list = ls(.cfb_card_cache), envir = .cfb_card_cache)
  invisible(NULL)
}

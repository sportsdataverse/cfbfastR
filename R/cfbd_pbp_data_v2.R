#' @title
#' **Get college football play-by-play data — modular EPA/WPA pipeline (v2)**
#' @description Returns CFBD play-by-play data with optional Expected Points
#' Added (EPA) and Win Probability Added (WPA) modeling. The modular
#' successor to [cfbd_pbp_data()]: a thin orchestrator over the shared
#' EPA/WPA engine (`.run_epa_wpa()`), the canonical play-type taxonomy
#' (`.pbp_play_types()`), and the canonical output schema
#' (`.pbp_output_order`). Side-by-side with the legacy entry point until the
#' equivalence harness proves the new path matches.
#' @param year (*Numeric* required): Season year (e.g. `2024`).
#' @param season_type (*Character*): Season type — `"regular"` (default),
#'   `"postseason"`, `"both"`, `"allstar"`, `"spring_regular"`,
#'   `"spring_postseason"`.
#' @param week (*Numeric*): Week number.
#' @param team (*Character*): Optional team filter (e.g. `"Texas"`).
#' @param play_type (*Character*): Optional play-type filter (see
#'   [cfbd_play_type_df]).
#' @param epa_wpa (*Logical*): When `TRUE`, run the EPA/WPA pipeline and
#'   return the modeled frame; when `FALSE` (default) return the raw plays +
#'   drives + betting join.
#' @return A `cfbfastR_data` tibble. The `epa_wpa = TRUE` output matches the
#'   legacy [cfbd_pbp_data()] pipeline-canonical column set; documented
#'   bug-fix sites are listed in the package vignette.
#' @keywords CFB PBP
#' @family CFBD PBP
#' @importFrom rlang .data
#' @importFrom dplyr filter group_by mutate left_join select rename ungroup
#'   slice_min any_of all_of setdiff
#' @importFrom janitor clean_names
#' @importFrom jsonlite fromJSON
#' @importFrom httr modify_url content
#' @importFrom cli cli_alert_warning
#' @importFrom glue glue
#' @importFrom stats setNames
#' @importFrom magrittr %>%
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_pbp_data_v2(year = 2024, week = 1, season_type = "regular",
#'                        epa_wpa = TRUE))
#' }
cfbd_pbp_data_v2 <- function(year,
                             season_type = "regular",
                             week        = 1,
                             team        = NULL,
                             play_type   = NULL,
                             epa_wpa     = FALSE) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old))

  # --- validation -------------------------------------------------------
  allowable_play_types <- na.omit(c(
    cfbfastR::cfbd_play_type_df$text,
    cfbfastR::cfbd_play_type_df$abbreviation
  ))

  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)

  pt_abb_exists <- TRUE
  if (!is.null(play_type)) {
    text <- play_type %in% cfbfastR::cfbd_play_type_df$text
    abbr <- play_type %in% cfbfastR::cfbd_play_type_df$abbreviation
    validate_list(play_type, allowable_play_types)
    if (text) {
      pt_abb <- cfbfastR::cfbd_play_type_df$abbreviation[
        which(cfbfastR::cfbd_play_type_df$text == play_type)]
      pt_abb_exists <- !is.null(pt_abb)
    } else {
      pt_abb <- play_type
    }
  } else {
    pt_abb <- NULL
  }
  team <- handle_accents(team)

  # --- raw plays --------------------------------------------------------
  play_base_url <- "https://api.collegefootballdata.com/plays"
  query_params  <- list(
    "seasonType" = season_type,
    "year"       = year,
    "week"       = week,
    "team"       = team,
    "playType"   = pt_abb
  )
  full_url <- httr::modify_url(play_base_url, query = query_params)
  res <- get_req(full_url)
  check_status(res)

  raw_play_df <- res %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()
  raw_play_df <- do.call(data.frame, raw_play_df)
  if (nrow(raw_play_df) == 0) {
    cli::cli_alert_warning(
      "Likely a bye week or empty filter for {year} wk {week}; returning NULL."
    )
    return(NULL)
  }

  # --- betting lines (year >= 2013, with a non-silent error handler) ----
  if (year >= 2013) {
    tryCatch(
      expr = {
        providers_list <- c(
          "consensus", "DraftKings", "ESPN Bet", "Caesars",
          "Caesars Sportsbook (Colorado)", "Caesars (Pennsylvania)",
          "Bovada", "SugarHouse", "William Hill (New Jersey)",
          "teamrankings", "numberfire"
        )
        game_spread <- cfbd_betting_lines(
          year        = year,
          week        = week,
          season_type = season_type,
          team        = team
        )
        game_spread <- game_spread %>%
          dplyr::filter(.data$provider %in% providers_list) %>%
          dplyr::mutate(
            spread     = as.numeric(.data$spread),
            over_under = as.numeric(.data$over_under)
          ) %>%
          dplyr::select(
            "game_id", "provider", "spread", "formatted_spread", "over_under"
          )
        prov_priority <- stats::setNames(
          seq_along(providers_list), providers_list
        )
        game_spread <- game_spread %>%
          dplyr::mutate(.prov_rank = prov_priority[.data$provider]) %>%
          dplyr::group_by(.data$game_id) %>%
          dplyr::slice_min(.data$.prov_rank, with_ties = FALSE) %>%
          dplyr::ungroup() %>%
          dplyr::select(-dplyr::all_of(".prov_rank"))
        raw_play_df <- raw_play_df %>%
          dplyr::left_join(
            game_spread, by = c("gameId" = "game_id"),
            suffix = c("_x", "")
          )
        if (all(is.na(raw_play_df$spread))) {
          raw_play_df$spread           <- NA_real_
          raw_play_df$formatted_spread <- NA_character_
          raw_play_df$over_under       <- NA_real_
        }
      },
      error = function(e) {
        cli::cli_alert_warning(
          "Betting lines unavailable for {year} wk {week}: {conditionMessage(e)}"
        )
      }
    )
  }

  # --- drives -----------------------------------------------------------
  drive_info     <- cfbd_drives(
    year = year, season_type = season_type, team = team, week = week
  )
  clean_drive_df <- clean_drive_info(drive_info)
  colnames(clean_drive_df) <- paste0("drive_", colnames(clean_drive_df))

  # --- assemble: clean_names + drive join + col cleanups (legacy:521-559)
  play_df <- raw_play_df %>%
    janitor::clean_names() %>%
    dplyr::rename("yard_line" = "yardline") %>%
    dplyr::mutate(drive_id = as.numeric(.data$drive_id)) %>%
    dplyr::left_join(
      clean_drive_df,
      by = c("drive_id" = "drive_drive_id",
             "game_id"  = "drive_game_id"),
      suffix = c("_play", "_drive")
    )

  rm_cols <- c(
    "drive_game_id", "drive_id_drive",
    "drive_plays", "drive_start_yardline", "drive_end_yardline",
    "drive_offense", "drive_offense_conference",
    "drive_defense", "drive_defense_conference",
    "drive_start_time_hours", "drive_start_time_minutes",
    "drive_start_time_seconds",
    "drive_end_time_hours", "drive_end_time_minutes",
    "drive_end_time_seconds",
    "drive_elapsed_hours", "drive_elapsed_minutes", "drive_elapsed_seconds"
  )

  play_df <- play_df %>%
    dplyr::select(-dplyr::any_of(rm_cols)) %>%
    dplyr::rename(
      "drive_pts"          = "drive_pts_drive",
      "drive_result"       = "drive_drive_result",
      "orig_drive_number"  = "drive_drive_number",
      "id_play"            = "id",
      "offense_play"       = "offense",
      "defense_play"       = "defense"
    )

  play_df <- .cfbd_to_epa_input(play_df, year = year, week = week)

  if (!pt_abb_exists) {
    play_df <- play_df %>%
      dplyr::filter(tolower(.data$play_type) == tolower(!!play_type))
  }

  # --- modeled path (epa_wpa = TRUE) -----------------------------------
  if (isTRUE(epa_wpa)) {
    if (year <= 2005) {
      cli::cli_alert_warning(
        "Data quality prior to 2005 is inconsistent; EPA/WPA may be unreliable."
      )
    }
    play_df <- .run_epa_wpa_by_game(
      play_df,
      ep_model   = ep_model,
      fg_model   = fg_model,
      wp_model   = wp_model,
      clean_text = TRUE,
      min_plays  = 20L
    ) %>%
      .pbp_apply_output_schema()
  }

  play_df %>%
    make_cfbfastR_data(
      "Play-by-Play data from CollegeFootballData.com (v2)", Sys.time()
    )
}

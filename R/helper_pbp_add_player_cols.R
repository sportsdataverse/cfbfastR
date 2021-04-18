#' Add player columns extracted from play text
#'
#' @param play_df (\emph{data.frame} required) Extracts player name information from Play-by-Play data frame, as pulled from `cfbd_pbp_data()`
#' @details Cleans CFB (D-I) player Data to create player name columns. Requires the following columns be present:
#' \itemize{
#' \item{rush}{.}
#' \item{pass}{.}
#' \item{play_text}{}
#' \item{play_type}{.}
#' \item{sack}{.}
#' \item{fumble_vec}{.}
#' }
#' @return The original `pbp` with the following columns appended to it:
#' \describe{
#' \item{rusher_player_name}{.}
#' \item{receiver_player_name}{.}
#' \item{passer_player_name}{.}
#' \item{sack_player_name}{.}
#' \item{sack_player_name2}{.}
#' \item{pass_breakup_player_name}{.}
#' \item{interception_player_name}{.}
#' \item{fg_kicker_player_name}{.}
#' \item{fg_block_player_name}{.}
#' \item{fg_return_player_name}{.}
#' \item{kickoff_player_name}{.}
#' \item{kickoff_returner_player_name}{.}
#' \item{punter_player_name}{.}
#' \item{punt_block_player_name}{.}
#' \item{punt_returner_player_name}{.}
#' \item{punt_block_return_player_name}{.}
#' \item{fumble_player_name}{.}
#' \item{fumble_forced_player_name}{.}
#' \item{fumble_recovered_player_name}{.}
#' }
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom stringr str_detect str_extract str_remove str_trim
#' @importFrom dplyr mutate arrange case_when select
#' @export
#'
add_player_cols <- function(pbp) {
  pbp$rush_player <- NA_real_
  pbp$receiver_player <- NA_real_
  pbp$pass_player <- NA_real_
  pbp$sack_players <- NA_real_
  pbp$sack_player1 <- NA_real_
  pbp$sack_player2 <- NA_real_
  pbp$interception_player <- NA_real_
  pbp$pass_breakup_player <- NA_real_
  pbp$fg_kicker_player <- NA_real_
  pbp$fg_return_player <- NA_real_
  pbp$fg_block_player <- NA_real_
  pbp$punter_player <- NA_real_
  pbp$punt_return_player <- NA_real_
  pbp$punt_block_player <- NA_real_
  pbp$punt_block_return_player <- NA_real_
  pbp$kickoff_return_player <- NA_real_
  pbp$fumble_player <- NA_real_
  pbp$fumble_forced_player <- NA_real_
  pbp$fumble_recovered_player <- NA_real_
  pbp$rush_player_name <- NA_real_
  pbp$receiver_player_name <- NA_real_
  pbp$passer_player_name <- NA_real_
  pbp$sack_player_name <- NA_real_
  pbp$sack_player_name2 <- NA_real_
  pbp$interception_player_name <- NA_real_
  pbp$pass_breakup_player_name <- NA_real_
  pbp$fg_kicker_player_name <- NA_real_
  pbp$fg_return_player_name <- NA_real_
  pbp$fg_block_player_name <- NA_real_
  pbp$punter_player_name <- NA_real_
  pbp$punt_return_player_name <- NA_real_
  pbp$punt_block_player_name <- NA_real_
  pbp$punt_block_return_player_name <- NA_real_
  pbp$kickoff_player_name <- NA_real_
  pbp$kickoff_return_player_name <- NA_real_
  pbp$fumble_player_name <- NA_real_
  pbp$fumble_forced_player_name <- NA_real_
  pbp$fumble_recovered_player_name <- NA_real_

  ## Extract player names
  # RB names
  pbp <- pbp %>%
    dplyr::mutate(
      rush_player = ifelse(.data$rush == 1,
        stringr::str_extract(.data$play_text, "(.{0,25} )run |(.{0,25} )\\d{0,2} Yd Run"), NA_character_
      ),
      rush_player = stringr::str_remove(.data$rush_player, " run | \\d+ Yd Run")
    )
  # QB names
  pbp <- pbp %>%
    dplyr::mutate(
      pass_player =
        ifelse(.data$pass == 1 & .data$play_type != "Passing Touchdown",
          stringr::str_extract(
            .data$play_text,
            "pass from (.*?) \\(|(.{0,30} )pass |(.+) sacked by|(.+) sacked for|(.{0,30} )incomplete "
          ), NA_character_
        ),
      pass_player = stringr::str_remove(.data$pass_player, "pass | sacked by| sacked for| incomplete"),
      pass_player = dplyr::if_else(.data$play_type == "Passing Touchdown",
        stringr::str_extract(.data$play_text, "pass from(.+)"), .data$pass_player
      ),
      pass_player = stringr::str_remove(.data$pass_player, "pass from "),
      pass_player = stringr::str_remove(.data$pass_player, "\\(.+\\)"),
      pass_player = stringr::str_remove(.data$pass_player, " \\,"),
      pass_player = ifelse(.data$play_type == "Passing Touchdown" & is.na(.data$pass_player),
        stringr::str_extract(.data$play_text, "(.+)pass complete to"), .data$pass_player
      ),
      pass_player = stringr::str_remove(.data$pass_player, " pass complete to(.+)"),
      pass_player = stringr::str_remove(.data$pass_player, " pass complete to"),
      pass_player = ifelse(.data$play_type == "Passing Touchdown" & is.na(.data$pass_player),
        stringr::str_extract(.data$play_text, "(.+)pass,to"), .data$pass_player
      ),
      pass_player = stringr::str_remove(.data$pass_player, " pass,to(.+)"),
      pass_player = stringr::str_remove(.data$pass_player, " pass,to")
    )
  ## Receiver names
  pbp <- pbp %>%
    dplyr::mutate(
      receiver_player = ifelse(.data$pass == 1 & !stringr::str_detect(.data$play_text, "sacked"),
        stringr::str_extract(.data$play_text, "to (.+)"), NA_character_
      ),
      receiver_player = if_else(stringr::str_detect(.data$play_text, regex("Yd pass", ignore_case = TRUE)),
        stringr::str_extract(.data$play_text, "(.{0,25} )\\d{0,2} Yd pass"),
        .data$receiver_player
      ),
      receiver_player = if_else(stringr::str_detect(.data$play_text, regex("Yd TD pass", ignore_case = TRUE)),
        stringr::str_extract(.data$play_text, "(.{0,25} )\\d{0,2} Yd TD pass"),
        .data$receiver_player
      ),
      receiver_player = ifelse(.data$play_type == "Sack" |
        .data$play_type == "Interception Return" |
        .data$play_type == "Interception Return Touchdown" |
        (.data$play_type %in% c(
          "Fumble Recovery (Opponent)",
          "Fumble Recovery (Opponent) Touchdown"
        ) &
          stringr::str_detect(.data$play_text, "sacked")), NA_character_, .data$receiver_player),
      receiver_player = stringr::str_remove(.data$receiver_player, "to "),
      receiver_player = stringr::str_remove(.data$receiver_player, "\\,.+"),
      receiver_player = stringr::str_remove(.data$receiver_player, "for (.+)"),
      receiver_player = stringr::str_remove(.data$receiver_player, " (\\d{1,2})"),
      receiver_player = stringr::str_remove(.data$receiver_player, " Yd pass"),
      receiver_player = stringr::str_remove(.data$receiver_player, " Yd TD pass"),
      receiver_player = stringr::str_remove(.data$receiver_player, "pass complete to"),
      receiver_player = stringr::str_remove(.data$receiver_player, regex("penalty", ignore_case = TRUE)),
      receiver_player = ifelse(!stringr::str_detect(.data$receiver_player, "III"),
        stringr::str_remove(.data$receiver_player, "[A-Z]{3,}+"), .data$receiver_player
      ),
      receiver_player = ifelse(!stringr::str_detect(.data$receiver_player, "III"),
        stringr::str_remove(.data$receiver_player, "[A-Z]{3,}+"), .data$receiver_player
      ),
      receiver_player = ifelse(!stringr::str_detect(.data$receiver_player, "III"),
        stringr::str_remove(.data$receiver_player, "[A-Z]{3,}+"), .data$receiver_player
      ),
      receiver_player = stringr::str_remove(.data$receiver_player, " &"),
      receiver_player = stringr::str_remove(.data$receiver_player, "A&M"),
      receiver_player = stringr::str_remove(.data$receiver_player, " ST"),
      receiver_player = stringr::str_remove(.data$receiver_player, " GA"),
      receiver_player = stringr::str_remove(.data$receiver_player, " UL"),
      receiver_player = stringr::str_remove(.data$receiver_player, " FL"),
      receiver_player = stringr::str_remove(.data$receiver_player, " OH"),
      receiver_player = stringr::str_remove(.data$receiver_player, " NC"),
      receiver_player = stringr::str_remove(.data$receiver_player, " \\u00c9"),
      receiver_player = stringr::str_remove(.data$receiver_player, " fumbled,"),
      receiver_player = stringr::str_remove(.data$receiver_player, "the (.+)"),
      receiver_player = stringr::str_remove(.data$receiver_player, "pass incomplete to"),
      receiver_player = stringr::str_remove(.data$receiver_player, "(.+)pass incomplete to"),
      receiver_player = stringr::str_remove(.data$receiver_player, "(.+)pass incomplete"),
      receiver_player = stringr::str_remove(.data$receiver_player, "pass incomplete")
    )

  ## Extract player names
  ## Sack player names
  pbp <- pbp %>%
    dplyr::mutate(
      sack_players = ifelse(.data$pass == 1 & (.data$sack == 1 | .data$fumble_vec == 1),
        stringr::str_extract(.data$play_text, "sacked by(.+)"), NA_character_
      ),
      sack_players = stringr::str_remove(.data$sack_players, "for (.+)"),
      sack_players = stringr::str_remove(.data$sack_players, "(.+) by "),
      sack_player1 = stringr::str_remove(.data$sack_players, "and (.+)"),
      sack_player2 = dplyr::if_else(stringr::str_detect(.data$sack_players, "and (.+)"),
        stringr::str_remove(.data$sack_players, "(.+) and"), NA_character_
      )
    )
  ## Interception player name
  pbp <- pbp %>%
    dplyr::mutate(
      interception_player = ifelse(.data$pass == 1 & (.data$play_type == "Interception Return" |
        .data$play_type == "Interception Return Touchdown"),
      stringr::str_extract(.data$play_text, "intercepted (.+)"), NA_character_
      ),
      interception_player = dplyr::if_else(stringr::str_detect(.data$play_text, regex("Yd Interception Return", ignore_case = TRUE)),
        stringr::str_extract(.data$play_text, "(.{0,25} )\\d{0,2} Yd Interception Return|(.{0,25} )\\d{0,2} yd interception return"),
        .data$interception_player
      ),
      interception_player = stringr::str_remove(.data$interception_player, "return (.+)"),
      interception_player = stringr::str_remove(.data$interception_player, "(.+) intercepted "),
      interception_player = stringr::str_remove(.data$interception_player, "intercepted"),
      interception_player = stringr::str_remove(.data$interception_player, " Yd Interception Return"),
      interception_player = stringr::str_remove(.data$interception_player, regex("for a 1st down", ignore_case = TRUE)),
      interception_player = stringr::str_remove(.data$interception_player, " (\\d{1,2})"),
      interception_player = stringr::str_remove(.data$interception_player, "for a TD ")
    )

  ## Pass Breakup player name
  pbp <- pbp %>%
    dplyr::mutate(
      pass_breakup_player = ifelse(.data$pass == 1,
        stringr::str_extract(.data$play_text, "broken up by (.+)"), NA_character_
      ),
      pass_breakup_player = stringr::str_remove(.data$pass_breakup_player, "(.+) broken up by"),
      pass_breakup_player = stringr::str_remove(.data$pass_breakup_player, "broken up by"),
      pass_breakup_player = stringr::str_remove(.data$pass_breakup_player, "Penalty(.+)"),
      pass_breakup_player = stringr::str_remove(.data$pass_breakup_player, "SOUTH FLORIDA"),
      pass_breakup_player = stringr::str_remove(.data$pass_breakup_player, "WEST VIRGINIA"),
      pass_breakup_player = stringr::str_remove(.data$pass_breakup_player, "MISSISSIPPI ST"),
      pass_breakup_player = stringr::str_remove(.data$pass_breakup_player, "CAMPBELL"),
      pass_breakup_player = stringr::str_remove(.data$pass_breakup_player, "COASTL CAROLINA")
    )

  ## Punter player name
  pbp <- pbp %>%
    dplyr::mutate(
      punter_player = ifelse(stringr::str_detect(.data$play_type, "Punt"),
        stringr::str_extract(.data$play_text, ".{0,25} punt"), NA_character_
      ),
      punter_player = stringr::str_remove(.data$punter_player, " punt"),
      punter_player = stringr::str_remove(.data$punter_player, " for(.+)")
    )

  ## Punt Returner player name
  pbp <- pbp %>%
    dplyr::mutate(
      punt_returner_player = ifelse(stringr::str_detect(.data$play_type, "Punt"),
        stringr::str_extract(.data$play_text, ", .{0,25} returns|fair catch by .{0,25}"), NA_character_
      ),
      punt_returner_player = stringr::str_remove(.data$punt_returner_player, ", "),
      punt_returner_player = stringr::str_remove(.data$punt_returner_player, " returns"),
      punt_returner_player = stringr::str_remove(.data$punt_returner_player, "fair catch by"),
      punt_returner_player = stringr::str_remove(.data$punt_returner_player, " at (.+)")
    )

  ## Punt Block player name
  pbp <- pbp %>%
    dplyr::mutate(
      punt_block_player = ifelse(stringr::str_detect(.data$play_type, "Punt"),
        stringr::str_extract(.data$play_text, "punt blocked by .{0,25}| blocked by(.+)"), NA_character_
      ),
      punt_block_player = stringr::str_remove(.data$punt_block_player, "punt blocked by |for a(.+)"),
      punt_block_player = stringr::str_remove(.data$punt_block_player, "blocked by(.+)"),
      punt_block_player = stringr::str_remove(.data$punt_block_player, "blocked(.+)"),
      punt_block_player = stringr::str_remove(.data$punt_block_player, " for(.+)"),
      punt_block_player = stringr::str_remove(.data$punt_block_player, ",(.+)"),
      punt_block_player = ifelse(stringr::str_detect(.data$play_text, regex("yd return of blocked punt", ignore_case = TRUE)),
        stringr::str_extract(.data$play_text, regex("(.+) yd return of blocked", ignore_case = TRUE)),
        .data$punt_block_player
      ),
      punt_block_player = stringr::str_remove(.data$punt_block_player, "blocked|Blocked"),
      punt_block_player = stringr::str_remove(.data$punt_block_player, "\\d+"),
      punt_block_player = stringr::str_remove(.data$punt_block_player, regex("yd return of", ignore_case = TRUE))
    )

  ## Punt Block return player name
  pbp <- pbp %>%
    dplyr::mutate(
      punt_block_return_player = ifelse(stringr::str_detect(.data$play_type, "Punt") &
        stringr::str_detect(.data$play_text, "blocked") &
        stringr::str_detect(.data$play_text, "return"),
      stringr::str_extract(.data$play_text, "(.+) return"), NA_character_
      ),
      punt_block_return_player = stringr::str_remove(.data$punt_block_return_player, glue::glue("(.+)blocked by {punt_block_player}")),
      punt_block_return_player = stringr::str_remove(.data$punt_block_return_player, glue::glue("blocked by {punt_block_player}")),
      punt_block_return_player = stringr::str_remove(.data$punt_block_return_player, "return(.+)"),
      punt_block_return_player = stringr::str_remove(.data$punt_block_return_player, "return"),
      punt_block_return_player = stringr::str_remove(.data$punt_block_return_player, "(.+)blocked by"),
      punt_block_return_player = stringr::str_remove(.data$punt_block_return_player, "for a TD(.+)|for a SAFETY(.+)"),
      punt_block_return_player = stringr::str_remove(.data$punt_block_return_player, "blocked by"),
      punt_block_return_player = stringr::str_remove(.data$punt_block_return_player, ", ")
    )

  ## Kickoff Specialist player name
  pbp <- pbp %>%
    dplyr::mutate(
      kickoff_player = ifelse(stringr::str_detect(.data$play_type, "Kickoff"),
        stringr::str_extract(.data$play_text, ".{0,25} kickoff|.{0,25} on-side"), NA_character_
      ),
      kickoff_player = stringr::str_remove(.data$kickoff_player, " on-side| kickoff")
    )

  ## Kickoff Returner player name
  pbp <- pbp %>%
    dplyr::mutate(
      kickoff_returner_player = ifelse(stringr::str_detect(.data$play_type, "ickoff"),
        stringr::str_extract(.data$play_text, ", .{0,25} return|, .{0,25} fumble"), NA_character_
      ),
      kickoff_returner_player = stringr::str_remove(.data$kickoff_returner_player, ", "),
      kickoff_returner_player = stringr::str_remove(.data$kickoff_returner_player, " return| fumble")
    )

  ## Field Goal Kicker player name
  pbp <- pbp %>%
    dplyr::mutate(
      fg_kicker_player = ifelse(stringr::str_detect(.data$play_type, "Field Goal"),
        stringr::str_extract(.data$play_text, regex("(.{0,25} )\\d{0,2} yd field goal| (.{0,25} )\\d{0,2} yd fg", ignore_case = TRUE)),
        NA_character_
      ),
      fg_kicker_player = stringr::str_remove(.data$fg_kicker_player, regex(" Yd Field Goal|Yd FG |yd FG| yd FG", ignore_case = TRUE)),
      fg_kicker_player = stringr::str_remove(.data$fg_kicker_player, "(\\d{1,2})")
    )

  ## FG Block player name
  pbp <- pbp %>%
    dplyr::mutate(
      fg_block_player = ifelse(stringr::str_detect(.data$play_type, "Field Goal"),
        stringr::str_extract(.data$play_text, "blocked by .{0,25}"), NA_character_
      ),
      fg_block_player = stringr::str_remove(.data$fg_block_player, ",(.+)"),
      fg_block_player = stringr::str_remove(.data$fg_block_player, "blocked by "),
      fg_block_player = stringr::str_remove(.data$fg_block_player, "  (.)+")
    )

  ## FG Block Return player name
  pbp <- pbp %>%
    dplyr::mutate(
      fg_return_player = ifelse(stringr::str_detect(.data$play_type, "Field Goal") &
        stringr::str_detect(.data$play_text, regex("blocked by|missed", ignore_case = TRUE)) &
        stringr::str_detect(.data$play_text, regex("return")),
      stringr::str_extract(.data$play_text, "  (.+)"), NA_character_
      ),
      fg_return_player = stringr::str_remove(.data$fg_return_player, ",(.+)"),
      fg_return_player = stringr::str_remove(.data$fg_return_player, "return "),
      fg_return_player = stringr::str_remove(.data$fg_return_player, " for (.+)"),
      fg_return_player = ifelse(is.na(.data$fg_return_player) & .data$play_type %in% c("Missed Field Goal Return", "Missed Field Goal Return Touchdown"),
        stringr::str_extract(.data$play_text, "(.+)return"), .data$fg_return_player
      ),
      fg_return_player = stringr::str_remove(.data$fg_return_player, " return"),
      fg_return_player = stringr::str_remove(.data$fg_return_player, "(.+),")
    )

  ## Fumble player name
  pbp <- pbp %>%
    dplyr::mutate(
      fumble_player = ifelse(stringr::str_detect(.data$play_text, "fumble"),
        stringr::str_extract(.data$play_text, regex("(.{0,25} )fumble", ignore_case = TRUE)), NA_character_
      ),
      fumble_player = stringr::str_remove(.data$fumble_player, regex(" fumble(.+)", ignore_case = TRUE)),
      fumble_player = stringr::str_remove(.data$fumble_player, regex("fumble", ignore_case = TRUE)),
      fumble_player = stringr::str_remove(.data$fumble_player, regex(" yds", ignore_case = TRUE)),
      fumble_player = stringr::str_remove(.data$fumble_player, regex(" yd", ignore_case = TRUE)),
      fumble_player = stringr::str_remove(.data$fumble_player, regex("yardline", ignore_case = TRUE)),
      fumble_player = stringr::str_remove(.data$fumble_player, regex(" yards| yard|for a TD|or a safety", ignore_case = TRUE)),
      fumble_player = stringr::str_remove(.data$fumble_player, regex(" for ", ignore_case = TRUE)),
      fumble_player = stringr::str_remove(.data$fumble_player, regex(" a safety", ignore_case = TRUE)),
      fumble_player = stringr::str_remove(.data$fumble_player, regex("r no gain", ignore_case = TRUE)),
      fumble_player = stringr::str_remove(.data$fumble_player, "(.+)(\\d{1,2})"),
      fumble_player = stringr::str_remove(.data$fumble_player, "(\\d{1,2})"),
      fumble_player = stringr::str_remove(.data$fumble_player, ", "),
      fumble_player = ifelse(.data$play_type == "Penalty", NA_character_, .data$fumble_player)
    )

  ## Fumble Forced player name
  pbp <- pbp %>%
    dplyr::mutate(
      fumble_forced_player = ifelse(stringr::str_detect(.data$play_text, "fumble") &
        stringr::str_detect(.data$play_text, regex("forced by", ignore_case = TRUE)),
      stringr::str_extract(.data$play_text, regex("forced by(.{0,25})", ignore_case = TRUE)), NA_character_
      ),
      fumble_forced_player = stringr::str_remove(.data$fumble_forced_player, regex("(.+)forced by", ignore_case = TRUE)),
      fumble_forced_player = stringr::str_remove(.data$fumble_forced_player, regex("forced by", ignore_case = TRUE)),
      fumble_forced_player = stringr::str_remove(.data$fumble_forced_player, regex(", recove(.+)", ignore_case = TRUE)),
      fumble_forced_player = stringr::str_remove(.data$fumble_forced_player, regex(", re(.+)", ignore_case = TRUE)),
      fumble_forced_player = stringr::str_remove(.data$fumble_forced_player, regex(", fo(.+)", ignore_case = TRUE)),
      fumble_forced_player = stringr::str_remove(.data$fumble_forced_player, regex(", r", ignore_case = TRUE)),
      fumble_forced_player = stringr::str_remove(.data$fumble_forced_player, ","),
      fumble_forced_player = ifelse(.data$play_type == "Penalty", NA_character_, .data$fumble_forced_player)
    )

  ## Fumble recovered player
  pbp <- pbp %>%
    dplyr::mutate(
      fumble_recovered_player = ifelse(stringr::str_detect(.data$play_text, "fumble") &
        stringr::str_detect(.data$play_text, regex("recovered by", ignore_case = TRUE)),
      stringr::str_extract(.data$play_text, regex("recovered by(.{0,30})", ignore_case = TRUE)), NA_character_
      ),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex("for a 1ST down", ignore_case = TRUE)),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex("for a 1st down")),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex("(.+)recovered", ignore_case = TRUE)),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex("(.+) by")),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex(", recove(.+)", ignore_case = TRUE)),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex(", re(.+)", ignore_case = TRUE)),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex("a 1st down", ignore_case = TRUE)),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex(" a 1st down", ignore_case = TRUE)),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex(", for(.+)", ignore_case = TRUE)),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex(", r(.+)", ignore_case = TRUE)),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex(" for(.+)", ignore_case = TRUE)),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex(" for a")),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex(" fo")),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex(" , r", ignore_case = TRUE)),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex(", r", ignore_case = TRUE)),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex("  (.+)", ignore_case = TRUE)),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex(" ,", ignore_case = TRUE)),
      fumble_recovered_player = stringr::str_remove(.data$fumble_recovered_player, regex("penalty(.+)", ignore_case = TRUE)),
      fumble_recovered_player = ifelse(.data$play_type == "Penalty", NA_character_, .data$fumble_recovered_player)
    )

  pbp <- pbp %>%
    dplyr::mutate(
      passer_player_name = stringr::str_trim(.data$pass_player),
      rusher_player_name = stringr::str_trim(.data$rush_player),
      receiver_player_name = stringr::str_trim(.data$receiver_player),
      sack_player_name = stringr::str_trim(.data$sack_player1),
      sack_player_name2 = stringr::str_trim(.data$sack_player2),
      pass_breakup_player_name = stringr::str_trim(.data$pass_breakup_player),
      interception_player_name = stringr::str_trim(.data$interception_player),
      fg_kicker_player_name = stringr::str_trim(.data$fg_kicker_player),
      fg_block_player_name = stringr::str_trim(.data$fg_block_player),
      fg_return_player_name = stringr::str_trim(.data$fg_return_player),
      kickoff_player_name = stringr::str_trim(.data$kickoff_player),
      kickoff_returner_player_name = stringr::str_trim(.data$kickoff_returner_player),
      punter_player_name = stringr::str_trim(.data$punter_player),
      punt_block_player_name = stringr::str_trim(.data$punt_block_player),
      punt_returner_player_name = stringr::str_trim(.data$punt_returner_player),
      punt_block_return_player_name = stringr::str_trim(.data$punt_block_return_player),
      fumble_player_name = stringr::str_trim(.data$fumble_player),
      fumble_forced_player_name = stringr::str_trim(.data$fumble_forced_player),
      fumble_recovered_player_name = stringr::str_trim(.data$fumble_recovered_player)
    ) %>%
    dplyr::select(
      -.data$rush_player,
      -.data$receiver_player,
      -.data$pass_player,
      -.data$sack_player1,
      -.data$sack_player2,
      -.data$pass_breakup_player,
      -.data$interception_player,
      -.data$punter_player,
      -.data$fg_kicker_player,
      -.data$fg_block_player,
      -.data$fg_return_player,
      -.data$kickoff_player,
      -.data$kickoff_returner_player,
      -.data$punt_returner_player,
      -.data$punt_block_player,
      -.data$punt_block_return_player,
      -.data$fumble_player,
      -.data$fumble_forced_player,
      -.data$fumble_recovered_player
    )
  return(pbp)
}

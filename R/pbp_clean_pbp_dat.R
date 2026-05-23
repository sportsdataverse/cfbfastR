#' Modular PBP -- play_type normalization, rush/pass/sack flags, scoring flags
#'
#' Refactor of `clean_pbp_dat()` for the modular `.run_epa_wpa()` engine.
#' Behavior-equivalent except for: play-type vectors sourced from
#' `.pbp_play_types()`.
#'
#' @param play_df Single-game play data frame (post-`.pbp_add_play_counts()`).
#' @return `play_df` with play-type / scoring / pass / rush / sack flags.
#' @keywords internal
#' @noRd
#' @importFrom rlang .data
#' @importFrom stringr str_detect str_remove regex
#' @importFrom dplyr mutate if_else case_when
#' @importFrom magrittr %>%
.pbp_clean_pbp_dat <- function(play_df) {
  tt                <- .pbp_play_types()
  scores_vec        <- tt$scores
  defense_score_vec <- tt$defense_score
  turnover_vec      <- tt$turnover
  normalplay        <- tt$normalplay
  penalty           <- tt$penalty
  offense_score_vec <- tt$offense_score
  punt_vec          <- tt$punt
  kickoff_vec       <- tt$kickoff
  int_vec           <- tt$int

  play_df <- play_df %>%
    dplyr::mutate(
      #-- Touchdowns----
      scoring_play = ifelse(.data$play_type %in% scores_vec, 1, 0),
      td_play = ifelse(stringr::str_detect(.data$play_text, regex("touchdown|for a TD", ignore_case = TRUE)) &
        !is.na(.data$play_text), 1, 0),
      touchdown = ifelse(stringr::str_detect(.data$play_type, regex("touchdown", ignore_case = TRUE)), 1, 0),
      safety = ifelse(stringr::str_detect(.data$play_text, regex("safety", ignore_case = TRUE)), 1, 0),
      #-- Fumbles----
      fumble_vec = ifelse(stringr::str_detect(.data$play_text, "fumble") & !is.na(.data$play_text), 1, 0),
      #-- Kicks/Punts----
      kickoff_play = ifelse(.data$play_type %in% kickoff_vec, 1, 0),
      kickoff_tb = ifelse(stringr::str_detect(.data$play_text, regex("touchback", ignore_case = TRUE)) &
        (.data$kickoff_play == 1) & !is.na(.data$play_text), 1, 0),
      kickoff_onside = ifelse(stringr::str_detect(.data$play_text, regex("on-side|onside|on side", ignore_case = TRUE)) &
        (.data$kickoff_play == 1) & !is.na(.data$play_text), 1, 0),
      kickoff_oob = ifelse(stringr::str_detect(.data$play_text, regex("out-of-bounds|out of bounds", ignore_case = TRUE)) &
        (.data$kickoff_play == 1) & !is.na(.data$play_text), 1, 0),
      kickoff_fair_catch = ifelse(stringr::str_detect(.data$play_text, regex("fair catch|fair caught", ignore_case = TRUE)) &
        (.data$kickoff_play == 1) & !is.na(.data$play_text), 1, 0),
      kickoff_downed = ifelse(stringr::str_detect(.data$play_text, regex("downed", ignore_case = TRUE)) &
        (.data$kickoff_play == 1) & !is.na(.data$play_text), 1, 0),
      kick_play = ifelse(stringr::str_detect(.data$play_text, regex("kick|kickoff", ignore_case = TRUE)) &
        !is.na(.data$play_text), 1, 0),
      kickoff_safety = ifelse(!(.data$play_type %in% c("Blocked Punt", "Penalty")) & .data$safety == 1 &
        stringr::str_detect(.data$play_text, regex("kickoff", ignore_case = TRUE)), 1, 0),
      punt = ifelse(.data$play_type %in% punt_vec, 1, 0),
      punt_play = ifelse(stringr::str_detect(.data$play_text, regex("punt", ignore_case = TRUE)) &
        !is.na(.data$play_text), 1, 0),
      punt_tb = ifelse(stringr::str_detect(.data$play_text, regex("touchback", ignore_case = TRUE)) &
        (.data$punt == 1) & !is.na(.data$play_text), 1, 0),
      punt_oob = ifelse(stringr::str_detect(.data$play_text, regex("out-of-bounds|out of bounds", ignore_case = TRUE)) &
        (.data$punt == 1) & !is.na(.data$play_text), 1, 0),
      punt_fair_catch = ifelse(stringr::str_detect(.data$play_text, regex("fair catch|fair caught", ignore_case = TRUE)) &
        (.data$punt == 1) & !is.na(.data$play_text), 1, 0),
      punt_downed = ifelse(stringr::str_detect(.data$play_text, regex("downed", ignore_case = TRUE)) &
        (.data$punt == 1) & !is.na(.data$play_text), 1, 0),
      ## TODO investigate order of safety definitions: think intentional grounding on a fumbled punt/penalty, which one takes precedence
      punt_safety = ifelse((.data$play_type %in% c("Blocked Punt", "Punt")) & .data$safety == 1 &
        stringr::str_detect(.data$play_text, regex("punt", ignore_case = TRUE)), 1, 0),
      penalty_safety = ifelse((.data$play_type %in% c("Penalty")) & .data$safety == 1, 1, 0),
      punt_blocked = ifelse(.data$punt == 1 & stringr::str_detect(.data$play_text, regex("blocked", ignore_case = TRUE)), 1, 0),

      #-- Pass/Rush----
      rush = ifelse(
        (.data$play_type == "Rush" & !is.na(.data$play_text)) |
          .data$play_type == "Rushing Touchdown" |
          (.data$play_type == "Safety" &
            stringr::str_detect(.data$play_text, regex("run for", ignore_case = TRUE)) & !is.na(.data$play_text)) |
          (.data$play_type == "Fumble Recovery (Opponent)" &
            stringr::str_detect(.data$play_text, regex("run for", ignore_case = TRUE)) & !is.na(.data$play_text)) |
          (.data$play_type == "Fumble Recovery (Opponent) Touchdown" &
            stringr::str_detect(.data$play_text, regex("run for", ignore_case = TRUE)) & !is.na(.data$play_text)) |
          (.data$play_type == "Fumble Recovery (Own)" &
            stringr::str_detect(.data$play_text, regex("run for", ignore_case = TRUE)) & !is.na(.data$play_text)) |
          (.data$play_type == "Fumble Recovery (Own) Touchdown" &
            stringr::str_detect(.data$play_text, regex("run for", ignore_case = TRUE)) & !is.na(.data$play_text)) |
          (.data$play_type == "Fumble Return Touchdown" &
            stringr::str_detect(.data$play_text, regex("run for", ignore_case = TRUE)) & !is.na(.data$play_text)), 1, 0
      ),
      pass = if_else(
        .data$play_type == "Pass Reception" |
          .data$play_type == "Pass Completion" |
          .data$play_type == "Passing Touchdown" |
          .data$play_type == "Sack" |
          .data$play_type == "Pass" |
          .data$play_type == "Interception" |
          .data$play_type == "Pass Interception Return" |
          .data$play_type == "Interception Return Touchdown" |
          (.data$play_type == "Pass Incompletion" & !is.na(.data$play_text)) |
          .data$play_type == "Sack Touchdown" |
          (.data$play_type == "Safety" &
            stringr::str_detect(.data$play_text, regex("sacked",
              ignore_case = TRUE
            )) & !is.na(.data$play_text)) |
          (.data$play_type == "Safety" &
            stringr::str_detect(.data$play_text, regex("pass complete",
              ignore_case = TRUE
            )) & !is.na(.data$play_text)) |
          (.data$play_type == "Fumble Recovery (Own)" &
            stringr::str_detect(.data$play_text, regex("pass complete|pass incomplete|pass intercepted",
              ignore_case = TRUE
            )) & !is.na(.data$play_text)) |
          (.data$play_type == "Fumble Recovery (Own)" &
            stringr::str_detect(.data$play_text, regex("sacked",
              ignore_case = TRUE
            )) & !is.na(.data$play_text)) |
          (.data$play_type == "Fumble Recovery (Own) Touchdown" &
            stringr::str_detect(.data$play_text, regex("pass complete|pass incomplete|pass intercepted",
              ignore_case = TRUE
            )) & !is.na(.data$play_text)) |
          (.data$play_type == "Fumble Recovery (Opponent)" &
            stringr::str_detect(.data$play_text, regex("pass complete|pass incomplete|pass intercepted",
              ignore_case = TRUE
            )) & !is.na(.data$play_text)) |
          (.data$play_type == "Fumble Recovery (Opponent)" &
            stringr::str_detect(.data$play_text, regex("sacked",
              ignore_case = TRUE
            )) & !is.na(.data$play_text)) |
          (.data$play_type == "Fumble Recovery (Opponent) Touchdown" &
            stringr::str_detect(.data$play_text, regex("pass complete|pass incomplete",
              ignore_case = TRUE
            )) & !is.na(.data$play_text)) |
          (.data$play_type == "Fumble Return Touchdown" &
            stringr::str_detect(.data$play_text, regex("pass complete|pass incomplete",
              ignore_case = TRUE
            )) & !is.na(.data$play_text)) |
          (.data$play_type == "Fumble Return Touchdown" &
            stringr::str_detect(.data$play_text, regex("sacked",
              ignore_case = TRUE
            )) & !is.na(.data$play_text)), 1, 0
      ),
      #-- Sacks----
      sack_vec = ifelse(
        ((.data$play_type %in% c("Sack", "Sack Touchdown")) |
          (.data$play_type %in% c(
            "Fumble Recovery (Own)", "Fumble Recovery (Own) Touchdown",
            "Fumble Recovery (Opponent)", "Fumble Recovery (Opponent) Touchdown",
            "Fumble Return Touchdown"
          ) &
            .data$pass == 1 & stringr::str_detect(.data$play_text, regex("sacked", ignore_case = TRUE))) |
          (.data$play_type == "Safety" & stringr::str_detect(.data$play_text, regex("sacked", ignore_case = TRUE)))) &
          !is.na(.data$play_text), 1, 0
      ),
      play_type = ifelse(stringr::str_detect(.data$play_text, regex(" coin toss ", ignore_case = TRUE)),
        "Coin Toss", .data$play_type
      ),
      ## Fix Strip-Sacks to Fumbles----
      play_type = ifelse(.data$fumble_vec == 1 & .data$pass == 1 &
        .data$change_of_poss == 1 & .data$td_play == 0 & .data$down != 4 &
        !(.data$play_type %in% defense_score_vec),
      "Fumble Recovery (Opponent)", .data$play_type
      ),
      play_type = ifelse(.data$fumble_vec == 1 & .data$pass == 1 &
        .data$change_of_poss == 1 & .data$td_play == 1,
      "Fumble Recovery (Opponent) Touchdown", .data$play_type
      ),
      ## Fix rushes with fumbles and a change of possession to fumbles----
      play_type = ifelse(.data$fumble_vec == 1 & .data$rush == 1 &
        .data$change_of_poss == 1 & .data$td_play == 0 &
        !(.data$play_type %in% defense_score_vec),
      "Fumble Recovery (Opponent)", .data$play_type
      ),
      play_type = ifelse(.data$fumble_vec == 1 & .data$rush == 1 &
        .data$change_of_poss == 1 & .data$td_play == 1,
      "Fumble Recovery (Opponent) Touchdown", .data$play_type
      ),
      ## Portion of touchdown check for plays where touchdown is not listed in the play_type--
      td_check = ifelse(!str_detect(.data$play_type, "Touchdown"), 1, 0),
      #-- Fix kickoff fumble return TDs ----
      play_type = ifelse(.data$kickoff_play == 1 & .data$fumble_vec == 1 &
        .data$td_play == 1 & .data$td_check == 1,
      paste0(.data$play_type, " Touchdown"),
      .data$play_type
      ),
      #-- Fix punt return TDs ----
      play_type = ifelse(.data$punt_play == 1 & .data$td_play == 1 & .data$td_check == 1,
        paste0(.data$play_type, " Touchdown"),
        .data$play_type
      ),
      #-- Fix kick return TDs----
      play_type = ifelse(.data$kickoff_play == 1 & .data$fumble_vec == 0 &
        .data$td_play == 1 & .data$td_check == 1,
      "Kickoff Return Touchdown",
      .data$play_type
      ),
      #-- Fix rush/pass tds that aren't explicit----
      play_type = ifelse(.data$td_play == 1 & .data$rush == 1 &
        .data$fumble_vec == 0 & .data$td_check == 1,
      "Rushing Touchdown",
      .data$play_type
      ),
      play_type = ifelse(.data$td_play == 1 & .data$pass == 1 & .data$td_check == 1 &
        .data$fumble_vec == 0 & !(.data$play_type %in% int_vec),
      "Passing Touchdown",
      .data$play_type
      ),
      play_type = ifelse(.data$pass == 1 & .data$play_type == "Pass Reception" &
        .data$yards_gained == .data$yards_to_goal &
        .data$fumble_vec == 0 & !(.data$play_type %in% int_vec),
      "Passing Touchdown",
      .data$play_type
      ),
      play_type = ifelse(.data$play_type == "Blocked Field Goal" &
        stringr::str_detect(.data$play_text, regex("for a TD", ignore_case = TRUE)),
      "Blocked Field Goal Touchdown",
      .data$play_type
      ),
      #-- Fix duplicated TD play_type labels----
      play_type = ifelse(.data$play_type == "Punt Touchdown Touchdown", "Punt Touchdown", .data$play_type),
      play_type = ifelse(.data$play_type == "Fumble Return Touchdown Touchdown", "Fumble Return Touchdown", .data$play_type),
      play_type = ifelse(.data$play_type == "Rushing Touchdown Touchdown", "Rushing Touchdown", .data$play_type),
      play_type = ifelse(.data$play_type == "Uncategorized Touchdown Touchdown", "Uncategorized Touchdown", .data$play_type),
      #-- Fix Pass Interception Return TD play_type labels----
      play_type = ifelse(stringr::str_detect(.data$play_text, "pass intercepted for a TD") & !is.na(.data$play_text),
        "Interception Return Touchdown", .data$play_type
      ),
      #-- Fix Sack/Fumbles Touchdown play_type labels----
      play_type = ifelse(stringr::str_detect(.data$play_text, regex("sacked", ignore_case = TRUE)) &
        stringr::str_detect(.data$play_text, regex("fumbled", ignore_case = TRUE)) &
        stringr::str_detect(.data$play_text, regex("TD", ignore_case = TRUE)) &
        !is.na(.data$play_text),
      "Fumble Recovery (Opponent) Touchdown", .data$play_type
      ),
      #-- Fix generic pass plays ----
      ## -- first one looks for complete pass
      play_type = ifelse(.data$play_type == "Pass" & str_detect(.data$play_text, "pass complete"),
        "Pass Completion", .data$play_type
      ),
      ## -- second one looks for incomplete pass
      play_type = ifelse(.data$play_type == "Pass" & str_detect(.data$play_text, "pass incomplete"),
        "Pass Incompletion", .data$play_type
      ),
      ## -- third one looks for interceptions
      play_type = ifelse(.data$play_type == "Pass" & str_detect(.data$play_text, "pass intercepted"),
        "Pass Interception", .data$play_type
      ),
      ## -- fourth one looks for sacked
      play_type = ifelse(.data$play_type == "Pass" & str_detect(.data$play_text, "sacked"), "Sack", .data$play_type),
      ## -- fifth one play type is Passing Touchdown, but its intercepted
      play_type = ifelse(.data$play_type == "Passing Touchdown" & str_detect(.data$play_text, "pass intercepted for a TD"),
        "Interception Return Touchdown", .data$play_type
      ),
      #--- Moving non-Touchdown pass interceptions to one play_type: "Interception Return" -----
      play_type = ifelse(.data$play_type == "Interception", "Interception Return", .data$play_type),
      play_type = ifelse(.data$play_type == "Pass Interception", "Interception Return", .data$play_type),
      play_type = ifelse(.data$play_type == "Pass Interception Return", "Interception Return", .data$play_type),
      #--- Moving Kickoff/Punt Touchdowns without fumbles to Kickoff/Punt Return Touchdown
      play_type = ifelse(.data$play_type == "Kickoff Touchdown" & .data$fumble_vec == 0,
        "Kickoff Return Touchdown", .data$play_type
      ),
      play_type = ifelse(.data$play_type %in% c("Kickoff", "Kickoff Return (Offense)") &
        .data$fumble_vec == 1 & .data$change_of_pos_team == 1,
      "Kickoff Team Fumble Recovery", .data$play_type
      ),
      play_type = ifelse(.data$play_type == "Punt Touchdown" &
        (.data$fumble_vec == 0 | (.data$fumble_vec == 1 & .data$game_id == 401112100)),
      "Punt Return Touchdown", .data$play_type
      ),
      play_type = ifelse(.data$play_type == "Punt" & .data$fumble_vec == 1 & .data$change_of_poss == 0,
        "Punt Team Fumble Recovery", .data$play_type
      ),
      play_type = ifelse(.data$play_type == "Punt Touchdown", "Punt Team Fumble Recovery Touchdown", .data$play_type),
      play_type = ifelse(.data$play_type == "Kickoff Touchdown", "Kickoff Team Fumble Recovery Touchdown", .data$play_type),
      play_type = ifelse(.data$play_type == "Fumble Return Touchdown" & (.data$pass == 1 | .data$rush == 1),
        "Fumble Recovery (Opponent) Touchdown", .data$play_type
      ),
      #--- Safeties (kickoff, punt, penalty) ----
      play_type = ifelse(.data$play_type %in% c("Pass Reception", "Rush", "Rushing Touchdown") &
        (.data$pass == 1 | .data$rush == 1) & .data$safety == 1,
      "Safety", .data$play_type
      ),
      play_type = ifelse(.data$kickoff_safety == 1, "Kickoff (Safety)", .data$play_type),
      play_type = ifelse(.data$punt_safety == 1, paste0(.data$play_type, " (Safety)"), .data$play_type),
      play_type = ifelse(.data$penalty_safety == 1, paste0(.data$play_type, " (Safety)"), .data$play_type),
      # NB: literals are quoted to preserve character type. The legacy used
      # unquoted numeric literals here, which forced an `ifelse` type coercion
      # of `id_play` from character to numeric on the ESPN path. Numeric
      # `id_play` values (~4e17 for core-v2 play ids) exceed double precision
      # (2^53), so a downstream `as.character(id_play)` produced scientific
      # notation and broke the play-id join in `espn_cfb_pbp_v2()`. Keeping
      # the literals as character preserves the join semantics and is safe
      # for the CFBD path (its `id_play` is already character).
      id_play = ifelse(.data$id_play == "400852742102997104" & .data$play_type == "Kickoff", "400852742102997106", .data$id_play),
      id_play = ifelse(.data$id_play == "400852742102997106" & .data$play_type == "Defensive 2pt Conversion", "400852742102997104", .data$id_play),
      #--- Sacks ----
      sack = ifelse((.data$play_type %in% c("Sack") |
        (.data$play_type %in% c(
          "Fumble Recovery (Own)",
          "Fumble Recovery (Own) Touchdown",
          "Fumble Recovery (Opponent)",
          "Fumble Recovery (Opponent) Touchdown"
        ) &
          .data$pass == 1 & stringr::str_detect(.data$play_text, "sacked")) |
        (.data$play_type == "Safety" & stringr::str_detect(.data$play_text, regex("sacked", ignore_case = TRUE)))) &
        !is.na(.data$play_text), 1, 0),
      #--- Interceptions ------
      int = ifelse(.data$play_type %in% c("Interception Return", "Interception Return Touchdown"), 1, 0),
      int_td = ifelse(.data$play_type %in% c("Interception Return Touchdown"), 1, 0),
      #--- Pass Completions, Attempts and Targets -------
      completion = ifelse(.data$play_type %in% c("Pass Reception", "Pass Completion", "Passing Touchdown") |
        ((.data$play_type %in% c(
          "Fumble Recovery (Own)",
          "Fumble Recovery (Own) Touchdown",
          "Fumble Recovery (Opponent)",
          "Fumble Recovery (Opponent) Touchdown"
        ) & .data$pass == 1 &
          !stringr::str_detect(.data$play_text, "sacked"))), 1, 0),
      pass_attempt = ifelse(.data$play_type %in% c(
        "Pass Reception",
        "Pass Completion",
        "Passing Touchdown",
        "Pass Incompletion",
        "Interception Return",
        "Interception Return Touchdown"
      ) |
        ((.data$play_type %in% c(
          "Fumble Recovery (Own)",
          "Fumble Recovery (Own) Touchdown",
          "Fumble Recovery (Opponent)",
          "Fumble Recovery (Opponent) Touchdown"
        ) & .data$pass == 1 &
          !stringr::str_detect(.data$play_text, "sacked"))), 1, 0),
      target = ifelse(.data$play_type %in% c(
        "Pass Reception",
        "Pass Completion",
        "Passing Touchdown",
        "Pass Incompletion"
      ) |
        ((.data$play_type %in% c(
          "Fumble Recovery (Own)",
          "Fumble Recovery (Own) Touchdown",
          "Fumble Recovery (Opponent)",
          "Fumble Recovery (Opponent) Touchdown"
        ) & .data$pass == 1 &
          !stringr::str_detect(.data$play_text, "sacked"))), 1, 0),
      #--- Pass/Rush TDs ------
      pass_td = ifelse(.data$play_type %in% c("Passing Touchdown"), 1, 0),
      rush_td = ifelse(.data$play_type %in% c("Rushing Touchdown"), 1, 0),
      #-- Change of possession via turnover
      turnover_vec = ifelse(.data$play_type %in% turnover_vec, 1, 0),
      offense_score_play = ifelse(.data$play_type %in% offense_score_vec, 1, 0),
      defense_score_play = ifelse(.data$play_type %in% defense_score_vec, 1, 0),
      downs_turnover = ifelse((.data$play_type %in% normalplay) &
        (.data$yards_gained < .data$distance) & (.data$down == 4) &
        !(.data$penalty_1st_conv), 1, 0),
      #-- Touchdowns----
      scoring_play = ifelse(.data$play_type %in% scores_vec, 1, 0),
      yds_punted = ifelse(.data$punt == 1, as.numeric(stringr::str_extract(
        stringi::stri_extract_first_regex(.data$play_text, "(?<= punt for)[^,]+"),
        "\\d+"
      )), NA_real_),
      yds_punt_gained = ifelse(.data$punt == 1, .data$yards_gained, NA_real_),
      fg_inds = ifelse(stringr::str_detect(.data$play_type, "Field Goal"), 1, 0),
      fg_made = ifelse(.data$play_type == "Field Goal Good", TRUE, FALSE),
      yds_fg = ifelse(.data$fg_inds == 1, as.numeric(
        stringr::str_remove(
          stringr::str_extract(
            .data$play_text,
            regex("\\d{0,2} Yd FG|\\d{0,2} Yd Field|\\d{0,2} Yard Field", ignore_case = TRUE)
          ),
          regex("yd FG|yd field|yard field", ignore_case = TRUE)
        )
      ), NA),
      yards_to_goal = ifelse(.data$fg_inds == 1 & !is.na(.data$yds_fg), .data$yds_fg - 17, .data$yards_to_goal),
      yards_to_goal = ifelse(.data$id_play == "401112476101977728", 16, .data$yards_to_goal),
      yards_to_goal = ifelse(.data$id_play == "401112476104999424", 36, .data$yards_to_goal),
      pos_unit = dplyr::case_when(
        .data$punt == 1 ~ "Punt Offense",
        .data$kickoff_play == 1 ~ "Kickoff Return",
        .data$fg_inds == 1 ~ "Field Goal Offense",
        .data$play_type == "Defensive 2pt Conversion" ~ "Offense",
        TRUE ~ "Offense"
      ),
      def_pos_unit = dplyr::case_when(
        .data$punt == 1 ~ "Punt Return",
        .data$kickoff_play == 1 ~ "Kickoff Defense",
        .data$fg_inds == 1 ~ "Field Goal Defense",
        .data$play_type == "Defensive 2pt Conversion" ~ "Defense",
        TRUE ~ "Defense"
      ),
      #--- Lags/Leads play type ----
      lag_play_type3 = dplyr::lag(.data$play_type, 3),
      lag_play_type2 = dplyr::lag(.data$play_type, 2),
      lag_play_type = dplyr::lag(.data$play_type, 1),
      lead_play_type = dplyr::lead(.data$play_type, 1),
      lead_play_type2 = dplyr::lead(.data$play_type, 2),
      lead_play_type3 = dplyr::lead(.data$play_type, 3)
    )
  return(play_df)
}

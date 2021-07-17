#' @rdname helpers_pbp
#'
#' @param raw_df (*data.frame* required): Performs data cleansing on Play-by-Play DataFrame, as pulled from `cfbd_pbp_data()`
#' @details Runs penalty detection on the play text and play types. Requires the following columns be present:
#' \itemize{
#' \item{`game_id`}{Referencing game id.}
#' \item{`period`}{Game period (quarter).}
#' \item{`down`}{Down of the play.}
#' \item{`play_type`}{Categorical play type.}
#' \item{`play_text`}{A description of the play.}
#' }
#' @return The original `raw_df` with the following columns appended/redefined:
#' \describe{
#' \item{`penalty_flag`: TRUE/FALSE flag for penalty play types or penalty in play text plays.}{.}
#' \item{`penalty_declined`: TRUE/FALSE flag for 'declined' in penalty play types or penalty in play text plays.}{.}
#' \item{`penalty_no_play`: TRUE/FALSE flag for 'no play' in penalty play types or penalty in play text plays.}{.}
#' \item{`penalty_offset`: TRUE/FALSE flag for 'off-setting' in penalty play types or penalty in play text plays.}{.}
#' \item{`penalty_1st_conv`: TRUE/FALSE flag for 1st Down in penalty play types or penalty in play text plays.}{.}
#' \item{`penalty_text`: TRUE/FALSE flag for penalty in text but not a penalty play type.}{.}
#' \item{`orig_play_type`: Copy of original play_type label prior to any changes by the proceeding functions}{.}
#' \item{`down`: Defines kickoff downs and penalties on kickoffs and converts them from 5 (as from the API) to 1.}{.}
#' \item{`play_type`: Defines `play_type`, "Penalty (Kickoff)", penalties on kickoffs with a repeat kick.}{.}
#' \item{`half`: Defines the half variable (1, 2).}{.}
#' }
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom stringr str_detect str_trim str_remove str_extract
#' @importFrom dplyr mutate filter case_when
#' @import tidyr
#' @export
#'

penalty_detection <- function(raw_df) {
  #-- 'Penalty' in play text ----
  pen_text <- stringr::str_detect(raw_df$play_text, regex("penalty", ignore_case = TRUE))
  #-- 'Declined' in play text ----
  pen_declined_text <- stringr::str_detect(raw_df$play_text, regex("declined", ignore_case = TRUE))
  #-- 'No Play' in play text ----
  pen_no_play_text <- stringr::str_detect(raw_df$play_text, regex("no play", ignore_case = TRUE))
  #-- 'Off-setting' in play text ----
  pen_offset_text <- stringr::str_detect(raw_df$play_text, regex("off-setting", ignore_case = TRUE))
  #-- '1st Down' in play text ----
  pen_1st_down_text <- stringr::str_detect(raw_df$play_text, regex("1st down", ignore_case = TRUE))

  #-- Penalty play_types
  pen_type <- raw_df$play_type == "Penalty" | raw_df$play_type == "penalty"

  #-- T/F flag conditions penalty_flag
  raw_df$penalty_flag <- FALSE
  raw_df$penalty_flag[pen_type] <- TRUE
  raw_df$penalty_flag[pen_text] <- TRUE
  #-- T/F flag conditions penalty_declined
  raw_df$penalty_declined <- FALSE
  raw_df$penalty_declined[pen_text & pen_declined_text] <- TRUE
  raw_df$penalty_declined[pen_type & pen_declined_text] <- TRUE
  #-- T/F flag conditions penalty_no_play
  raw_df$penalty_no_play <- FALSE
  raw_df$penalty_no_play[pen_text & pen_no_play_text] <- TRUE
  raw_df$penalty_no_play[pen_type & pen_no_play_text] <- TRUE
  #-- T/F flag conditions penalty_offset
  raw_df$penalty_offset <- FALSE
  raw_df$penalty_offset[pen_text & pen_offset_text] <- TRUE
  raw_df$penalty_offset[pen_type & pen_offset_text] <- TRUE
  #-- T/F flag conditions penalty_1st_conv
  raw_df$penalty_1st_conv <- FALSE
  raw_df$penalty_1st_conv[pen_text & pen_1st_down_text] <- TRUE
  raw_df$penalty_1st_conv[pen_type & pen_1st_down_text] <- TRUE
  #-- T/F flag for penalty text but not penalty play type --
  raw_df$penalty_text <- FALSE
  raw_df$penalty_text[pen_text & !pen_type & !pen_declined_text &
    !pen_offset_text & !pen_no_play_text] <- TRUE

  raw_df <- raw_df %>%
    dplyr::mutate(
      penalty_detail = case_when(
        .data$penalty_offset ~ "Off-Setting",
        .data$penalty_declined ~ "Penalty Declined",
        stringr::str_detect(.data$play_text, regex(" roughing passer ", ignore_case = TRUE)) ~ "Roughing the Passer",
        stringr::str_detect(.data$play_text, regex(" offensive holding ", ignore_case = TRUE)) ~ "Offensive Holding",
        stringr::str_detect(.data$play_text, regex(" pass interference", ignore_case = TRUE)) ~ "Pass Interference",
        stringr::str_detect(.data$play_text, regex(" encroachment", ignore_case = TRUE)) ~ "Encroachment",
        stringr::str_detect(.data$play_text, regex(" defensive pass interference ", ignore_case = TRUE)) ~ "Defensive Pass Interference",
        stringr::str_detect(.data$play_text, regex(" offensive pass interference ", ignore_case = TRUE)) ~ "Offensive Pass Interference",
        stringr::str_detect(.data$play_text, regex(" illegal procedure ", ignore_case = TRUE)) ~ "Illegal Procedure",
        stringr::str_detect(.data$play_text, regex(" defensive holding ", ignore_case = TRUE)) ~ "Defensive Holding",
        stringr::str_detect(.data$play_text, regex(" holding ", ignore_case = TRUE)) ~ "Holding",
        stringr::str_detect(.data$play_text, regex(" offensive offside | offside offense", ignore_case = TRUE)) ~ "Offensive Offside",
        stringr::str_detect(.data$play_text, regex(" defensive offside | offside defense", ignore_case = TRUE)) ~ "Defensive Offside",
        stringr::str_detect(.data$play_text, regex(" offside ", ignore_case = TRUE)) ~ "Offside",
        stringr::str_detect(.data$play_text, regex(" illegal fair catch signal ", ignore_case = TRUE)) ~ "Illegal Fair Catch Signal",
        stringr::str_detect(.data$play_text, regex(" illegal batting ", ignore_case = TRUE)) ~ "Illegal Batting",
        stringr::str_detect(.data$play_text, regex(" neutral zone infraction ", ignore_case = TRUE)) ~ "Neutral Zone Infraction",
        stringr::str_detect(.data$play_text, regex(" ineligible downfield ", ignore_case = TRUE)) ~ "Ineligible Man Down-Field",
        stringr::str_detect(.data$play_text, regex(" illegal use of hands ", ignore_case = TRUE)) ~ "Illegal Use of Hands",
        stringr::str_detect(.data$play_text, regex(" kickoff out of bounds | kickoff out-of-bounds ", ignore_case = TRUE)) ~ "Kickoff Out-of-Bounds",
        stringr::str_detect(.data$play_text, regex(" 12 men on the field ", ignore_case = TRUE)) ~ "12 Men on the Field",
        stringr::str_detect(.data$play_text, regex(" illegal block ", ignore_case = TRUE)) ~ "Illegal Block",
        stringr::str_detect(.data$play_text, regex(" personal foul ", ignore_case = TRUE)) ~ "Personal Foul",
        stringr::str_detect(.data$play_text, regex(" false start ", ignore_case = TRUE)) ~ "False Start",
        stringr::str_detect(.data$play_text, regex(" substitution infraction ", ignore_case = TRUE)) ~ "Substitution Infraction",
        stringr::str_detect(.data$play_text, regex(" illegal formation ", ignore_case = TRUE)) ~ "Illegal Formation",
        stringr::str_detect(.data$play_text, regex(" illegal touching ", ignore_case = TRUE)) ~ "Illegal Touching",
        stringr::str_detect(.data$play_text, regex(" sideline interference ", ignore_case = TRUE)) ~ "Sideline Interference",
        stringr::str_detect(.data$play_text, regex(" clipping ", ignore_case = TRUE)) ~ "Clipping",
        stringr::str_detect(.data$play_text, regex(" sideline infraction ", ignore_case = TRUE)) ~ "Sideline Infraction",
        stringr::str_detect(.data$play_text, regex(" crackback ", ignore_case = TRUE)) ~ "Crackback",
        stringr::str_detect(.data$play_text, regex(" illegal snap ", ignore_case = TRUE)) ~ "Illegal Snap",
        stringr::str_detect(.data$play_text, regex(" illegal helmet contact ", ignore_case = TRUE)) ~ "Illegal Helmet contact",
        stringr::str_detect(.data$play_text, regex(" roughing holder ", ignore_case = TRUE)) ~ "Roughing the Holder",
        stringr::str_detect(.data$play_text, regex(" horse collar tackle ", ignore_case = TRUE)) ~ "Horse-Collar Tackle",
        stringr::str_detect(.data$play_text, regex(" illegal participation ", ignore_case = TRUE)) ~ "Illegal Participation",
        stringr::str_detect(.data$play_text, regex(" tripping ", ignore_case = TRUE)) ~ "Tripping",
        stringr::str_detect(.data$play_text, regex(" illegal shift ", ignore_case = TRUE)) ~ "Illegal Shift",
        stringr::str_detect(.data$play_text, regex(" illegal motion ", ignore_case = TRUE)) ~ "Illegal Motion",
        stringr::str_detect(.data$play_text, regex(" roughing the kicker ", ignore_case = TRUE)) ~ "Roughing the Kicker",
        stringr::str_detect(.data$play_text, regex(" delay of game ", ignore_case = TRUE)) ~ "Delay of Game",
        stringr::str_detect(.data$play_text, regex(" targeting ", ignore_case = TRUE)) ~ "Targeting",
        stringr::str_detect(.data$play_text, regex(" face mask ", ignore_case = TRUE)) ~ "Face Mask",
        stringr::str_detect(.data$play_text, regex(" illegal forward pass ", ignore_case = TRUE)) ~ "Illegal Forward Pass",
        stringr::str_detect(.data$play_text, regex(" intentional grounding ", ignore_case = TRUE)) ~ "Intentional Grounding",
        stringr::str_detect(.data$play_text, regex(" illegal kicking ", ignore_case = TRUE)) ~ "Illegal Kicking",
        stringr::str_detect(.data$play_text, regex(" illegal conduct ", ignore_case = TRUE)) ~ "Illegal Conduct",
        stringr::str_detect(.data$play_text, regex(" kick catching interference ", ignore_case = TRUE)) ~ "Kick Catch Interference",
        stringr::str_detect(.data$play_text, regex(" unnecessary roughness ", ignore_case = TRUE)) ~ "Unnecessary Roughness",
        stringr::str_detect(.data$play_text, regex("Penalty, UR")) ~ "Unnecessary Roughness",
        stringr::str_detect(.data$play_text, regex(" unsportsmanlike conduct ", ignore_case = TRUE)) ~ "Unsportsmanlike Conduct",
        stringr::str_detect(.data$play_text, regex(" running into kicker ", ignore_case = TRUE)) ~ "Running Into Kicker",
        stringr::str_detect(.data$play_text, regex(" failure to wear required equipment ", ignore_case = TRUE)) ~ "Failure to Wear Required Equipment",
        stringr::str_detect(.data$play_text, regex(" player disqualification ", ignore_case = TRUE)) ~ "Player Disqualification",
        .data$penalty_flag ~ "Missing",
        TRUE ~ NA_character_
      ),
      penalty_play_text = ifelse(.data$penalty_flag, stringr::str_extract(.data$play_text, regex("Penalty(.+)", ignore_case = TRUE)), NA_character_),
      yds_penalty = ifelse(.data$penalty_flag,
        stringr::str_extract(.data$penalty_play_text, "(.{0,3})yards to the |(.{0,3})yds to the |(.{0,3})yd to the "), NA_real_
      ),
      yds_penalty = stringr::str_remove(.data$yds_penalty, " yards to the | yds to the | yd to the "),
      yds_penalty = ifelse(.data$penalty_flag & stringr::str_detect(.data$play_text, "ards\\)") & is.na(.data$yds_penalty),
        stringr::str_extract(.data$play_text, "(.{0,4})yards\\)|(.{0,4})Yards\\)|(.{0,4})yds\\)|(.{0,4})Yds\\)"), .data$yds_penalty
      ),
      yds_penalty = stringr::str_remove(.data$yds_penalty, "yards\\)|Yards\\)|yds\\)|Yds\\)"),
      yds_penalty = stringr::str_remove(.data$yds_penalty, "\\(")
    )
  suppressWarnings(
    raw_df <- raw_df %>%
      mutate(yds_penalty = stringr::str_trim(.data$yds_penalty))
  )
  ## -- Kickoff down adjustment ----
  raw_df <- raw_df %>%
    dplyr::mutate(
      orig_play_type = .data$play_type,
      down = ifelse(.data$down == 5 & stringr::str_detect(.data$play_type, "Kickoff"), 1, .data$down),
      play_type = ifelse(.data$down == 5 & stringr::str_detect(.data$play_type, "Penalty"),
        "Penalty (Kickoff)", .data$play_type
      ),
      down = ifelse(.data$down == 5 & stringr::str_detect(.data$play_type, "Penalty"), 1, .data$down),
      half = ifelse(.data$period <= 2, 1, 2)
    ) %>%
    dplyr::filter(!(.data$game_id == "302610012" & .data$down == 5 & .data$play_type == "Rush"))
  return(raw_df)
}

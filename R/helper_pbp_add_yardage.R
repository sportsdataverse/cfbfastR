#' @rdname helpers_pbp
#' @param play_df (*data.frame* required) Extracts yardage information from Play-by-Play data frame, as pulled from `cfbd_pbp_data()`
#' @details Cleans CFB (D-I) Drive-By-Drive Data to create yardage column. Requires the following columns be present:
#' \describe{
#'  \item{`play_text`}{.}
#'  \item{`play_type`}{.}
#'  \item{`rush`}{.}
#'  \item{`pass`}{.}
#'  \item{`int`}{.}
#'  \item{`int_td`}{.}
#'  \item{`kickoff_play`}{.}
#'  \item{`kickoff_tb`}{.}
#'  \item{`kickoff_downed`}{.}
#'  \item{`kickoff_fair_catch`}{.}
#'  \item{`fumble_vec`}{.}
#'  \item{`sack`}{.}
#'  \item{`punt`}{.}
#'  \item{`punt_tb`}{.}
#'  \item{`punt_downed`}{.}
#'  \item{`punt_fair_catch`}{.}
#'  \item{`punt_oob`}{.}
#'  \item{`punt_blocked`}{.}
#'  \item{`penalty_detail`}{.}
#' }
#' @return The original `play_df` with the following columns appended to it:
#' \describe{
#' \item{`yds_rushed`}{.}
#' \item{`yds_receiving`}{.}
#' \item{`yds_int_return`}{.}
#' \item{`yds_kickoff`}{.}
#' \item{`yds_kickoff_return`}{.}
#' \item{`yds_punted`}{.}
#' \item{`yds_fumble_return`}{.}
#' \item{`yds_sacked`}{.}
#' \item{`yds_penalty`}{.}
#' }
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom dplyr mutate arrange case_when
#' @import stringr
#' @export
#'

add_yardage <- function(play_df) {
  play_df$yds_rushed <- NA_real_
  play_df$yds_receiving <- NA_real_
  play_df$yds_int_return <- NA_real_
  play_df$yds_kickoff <- NA_real_
  play_df$yds_kickoff_return <- NA_real_
  play_df$yds_punted <- NA_real_
  play_df$yds_fumble_return <- NA_real_
  play_df$yds_sacked <- NA_real_
  play_df$yds_penalty <- NA_real_

  play_df <- play_df %>%
    dplyr::mutate(
      yds_rushed = dplyr::case_when(
        .data$rush == 1 & stringr::str_detect(.data$play_text, regex("run for no gain", ignore_case = TRUE)) ~ 0,
        .data$rush == 1 &
          stringr::str_detect(.data$play_text, regex("run for a loss of", ignore_case = TRUE)) ~
        -1 * as.numeric(stringr::str_extract(
          stringi::stri_extract_first_regex(.data$play_text, "(?<= run for a loss of)[^,]+"), "\\d+"
        )),
        .data$rush == 1 &
          stringr::str_detect(.data$play_text, regex("run for", ignore_case = TRUE)) ~
        as.numeric(stringr::str_extract(
          stringi::stri_extract_first_regex(.data$play_text, "(?<= run for)[^,]+"), "\\d+"
        )),
        .data$rush == 1 &
          stringr::str_detect(.data$play_text, regex("yd run", ignore_case = TRUE)) ~
        as.numeric(
          stringr::str_remove(
            stringr::str_extract(.data$play_text, regex("\\d{0,2} Yd Run", ignore_case = TRUE)),
            regex("yd run", ignore_case = TRUE)
          )
        ),
        TRUE ~ NA_real_
      ),
      yds_receiving = dplyr::case_when(
        .data$pass == 1 & stringr::str_detect(.data$play_text, regex("pass complete to", ignore_case = TRUE)) &
          stringr::str_detect(.data$play_text, regex("for no gain", ignore_case = TRUE)) ~ 0,
        .data$pass == 1 &
          stringr::str_detect(.data$play_text, regex("pass complete to", ignore_case = TRUE)) &
          stringr::str_detect(.data$play_text, regex("for a loss of", ignore_case = TRUE)) ~
        -1 * as.numeric(stringr::str_extract(
          stringi::stri_extract_first_regex(.data$play_text, "(?<= for a loss of)[^,]+"), "\\d+"
        )),
        .data$pass == 1 &
          stringr::str_detect(.data$play_text, regex("pass complete to", ignore_case = TRUE)) &
          stringr::str_detect(.data$play_text, regex(" for \\d+ y\\w*ds?", ignore_case = TRUE)) ~
        as.numeric(stringr::str_extract(
          stringi::stri_extract_first_regex(.data$play_text, "(?<= for)[^,]+"), "\\d+"
        )),
        .data$pass == 1 &
          stringr::str_detect(.data$play_text, regex("Yd pass", ignore_case = TRUE)) ~
          as.numeric(stringr::str_extract(
            stringi::stri_extract_first_regex(.data$play_text, "(\\d+)\\s+Yd\\s+pass"), "\\d+"
          )),
        .data$pass == 1 &
          stringr::str_detect(.data$play_text, regex("pass complete to", ignore_case = TRUE)) ~
          yards_gained, # 2024 has games that don't have yards in the PBP text but do have them in the yards_gained field.
        TRUE ~ NA_real_
      )
    )
  suppressWarnings(
    play_df <- play_df %>%
      dplyr::mutate(
        yds_int_return = dplyr::case_when(
          .data$pass == 1 & .data$int_td == 1 & stringr::str_detect(.data$play_text, regex("Yd Interception Return", ignore_case = TRUE)) ~
          as.numeric(stringr::str_extract(
            stringi::stri_extract_first_regex(.data$play_text, regex("(.+)Yd Interception Return", ignore_case = TRUE)), "\\d+"
          )),
          .data$pass == 1 & .data$int == 1 & stringr::str_detect(.data$play_text, regex("for no gain", ignore_case = TRUE)) ~ 0,
          .data$pass == 1 & .data$int == 1 & stringr::str_detect(.data$play_text, regex("for a loss of", ignore_case = TRUE)) ~
          -1 * as.numeric(stringr::str_extract(
            stringi::stri_extract_first_regex(.data$play_text, "(?<= for a loss of)[^,]+"), "\\d+"
          )),
          .data$pass == 1 & .data$int == 1 & stringr::str_detect(.data$play_text, regex("for a TD", ignore_case = TRUE)) ~
          as.numeric(stringr::str_extract(
            stringi::stri_extract_first_regex(.data$play_text, "(?<= return for)[^,]+"), "\\d+"
          )),
          .data$pass == 1 & .data$int == 1 & stringr::str_detect(.data$play_text, regex("for a TD", ignore_case = TRUE)) ~
          as.numeric(stringr::str_extract(
            stringi::stri_extract_first_regex(.data$play_text, "(?<= for)[^,]+"), "\\d+"
          )),
          .data$pass == 1 & .data$int == 1 ~
          as.numeric(stringr::str_extract(
            stringi::stri_extract_first_regex(str_remove(.data$play_text, regex("for a 1st", ignore_case = TRUE)), "(?<= for)[^,]+"), "\\d+"
          )),
          TRUE ~ NA_real_
        )
      )
  )

  play_df <- play_df %>%
    dplyr::mutate(
      yds_kickoff = NA_real_,
      yds_kickoff = ifelse(.data$kickoff_play == 1, as.numeric(stringr::str_extract(
        stringi::stri_extract_first_regex(.data$play_text, "(?<=kickoff for)[^,]+"), "\\d+"
      )), .data$yds_kickoff),
      yds_kickoff_return = NA_real_,
      yds_kickoff_return = dplyr::case_when(
        .data$kickoff_play == 1 & .data$kickoff_tb == 1 ~ 25,
        .data$kickoff_play == 1 & .data$fumble_vec == 0 &
          stringr::str_detect(.data$play_text, regex("for no gain|fair catch|fair caught", ignore_case = TRUE)) ~ 0,
        .data$kickoff_play == 1 & .data$fumble_vec == 0 &
          stringr::str_detect(.data$play_text, regex("out-of-bounds|out of bounds", ignore_case = TRUE)) ~ 40,
        (.data$kickoff_downed == 1 | .data$kickoff_fair_catch == 1) ~ 0,
        .data$kickoff_play == 1 ~ as.numeric(stringr::str_extract(
          stringi::stri_extract_first_regex(.data$play_text, "(?<= return for)[^,]+"), "\\d+"
        )),
        TRUE ~ NA_real_
      ),
      yds_punted = NA_real_,
      yds_punted = case_when(
        .data$punt == 1 & .data$punt_blocked == 1 ~ 0,
        .data$punt == 1 ~ as.numeric(stringr::str_extract(
          stringi::stri_extract_first_regex(.data$play_text, "(?<= punt for)[^,]+"), "\\d+"
        )),
        TRUE ~ .data$yds_punted
      ),
      yds_punt_return = dplyr::case_when(
        .data$punt == 1 & .data$punt_tb == 1 ~ 20,
        .data$punt == 1 & stringr::str_detect(
          .data$play_text,
          regex("for no gain|fair catch|fair caught|out-of-bounds|out of bounds", ignore_case = TRUE)
        ) ~ 0,
        (.data$punt_downed == 1 | .data$punt_oob == 1 | .data$punt_fair_catch == 1) ~ 0,
        .data$punt == 1 & .data$punt_blocked == 0 ~ as.numeric(stringr::str_extract(
          stringi::stri_extract_first_regex(.data$play_text, "(?<= returns for)[^,]+"), "\\d+"
        )),
        .data$punt == 1 & .data$punt_blocked == 1 ~ as.numeric(stringr::str_extract(
          stringi::stri_extract_first_regex(.data$play_text, "(?<= return for)[^,]+"), "\\d+"
        )),
        TRUE ~ NA_real_
      ),
      yds_fumble_return = dplyr::case_when(
        .data$fumble_vec == 1 & .data$kickoff_play != 1 ~ as.numeric(stringr::str_extract(
          stringi::stri_extract_first_regex(.data$play_text, "(?<= return for)[^,]+"), "\\d+"
        )),
        TRUE ~ NA_real_
      ),
      yds_sacked = dplyr::case_when(
        .data$sack == 1 ~ -1 * as.numeric(stringr::str_extract(
          stringi::stri_extract_first_regex(.data$play_text, "(?<= sacked)[^,]+"), "\\d+"
        )),
        TRUE ~ NA_real_
      )
    )
  suppressWarnings(
    play_df <- play_df %>%
      dplyr::mutate(
        yds_penalty = as.numeric(dplyr::case_when(
          .data$penalty_detail %in% c("Penalty Declined", "Penalty Offset") ~ 0,
          !is.na(.data$yds_penalty) ~ as.numeric(.data$yds_penalty),
          !is.na(.data$penalty_detail) & is.na(.data$yds_penalty) & .data$rush == 1 ~ as.numeric(.data$yards_gained) - as.numeric(.data$yds_rushed),
          !is.na(.data$penalty_detail) & is.na(.data$yds_penalty) & .data$int == 1 ~ as.numeric(.data$yards_gained) - as.numeric(.data$yds_int_return),
          !is.na(.data$penalty_detail) & is.na(.data$yds_penalty) & .data$pass == 1 & .data$sack == 0 &
            .data$play_type != "Pass Incompletion" ~ as.numeric(.data$yards_gained) - as.numeric(.data$yds_receiving),
          !is.na(.data$penalty_detail) & is.na(.data$yds_penalty) & .data$pass == 1 & .data$sack == 0 &
            .data$play_type == "Pass Incompletion" ~ as.numeric(.data$yards_gained),
          !is.na(.data$penalty_detail) & is.na(.data$yds_penalty) & .data$pass == 1 & .data$sack == 1 ~
          as.numeric(.data$yards_gained) - as.numeric(.data$yds_sacked),
          .data$play_type == "Penalty" ~ as.numeric(.data$yards_gained)
        ))
      )
  )
  return(play_df)
}

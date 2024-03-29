% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_epa.R
\name{create_epa}
\alias{create_epa}
\alias{epa_fg_probs}
\title{\strong{Create EPA}}
\usage{
create_epa(play_df, ep_model, fg_model)

epa_fg_probs(dat, current_probs, ep_model, fg_mod)
}
\arguments{
\item{ep_model}{(\strong{model}, default \code{cfbfastR}'s \code{ep_model}): FG Model to be used for prediction on field goal (FG) attempts in Play-by-Play data.frame}

\item{fg_model}{(\emph{model} default \code{cfbfastR}'s \code{fg_model}): Field Goal (FG) Model}

\item{current_probs}{(\strong{data.frame} required): Expected Points (EP) model raw probability outputs from initial prediction}

\item{fg_mod}{(\strong{model}, default \code{cfbfastR}'s \code{fg_model}): FG Model to be used for prediction on field goal (FG) attempts in Play-by-Play data.frame}

\item{clean_pbp_dat}{(\emph{data.frame} required): Clean PBP as input from \code{\link[=cfbd_pbp_data]{cfbd_pbp_data()}}}

\item{df}{(\strong{data.frame} required): Clean Play-By-Play data.frame as can be pulled from \code{\link[=clean_pbp_dat]{clean_pbp_dat()}}}
}
\description{
Adds Expected Points calculations to Play-by-Play data.frame
}
\details{
Code Description
\describe{
\item{1. \code{pred_df}:}{Use select before play model variables -> Make predictions.}
\item{2. \code{epa_fg_probs}:}{Update expected points predictions from before variables with FG make/miss probability weighted adjustment.}
\item{3. \code{pred_df_after}:}{Use select after play model variables -> Make predictions.}
\item{4. \code{join_ep}:}{Join \code{ep_before} calcs \code{pred_df} with \code{ep_after} calcs \code{pred_df_after} on c("game_id","drive_id","new_id").}
\item{5. \code{kickoffs}:}{Calculate ep_before for kickoffs as if the pre-play assumption is a touchback.}
\item{6. \code{wpa_prep}:}{Prep variables for WPA.}
}
}
\keyword{internal}

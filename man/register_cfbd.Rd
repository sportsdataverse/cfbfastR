% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cfbd_api_key.R
\name{register_cfbd}
\alias{register_cfbd}
\alias{cfbd_key}
\alias{has_cfbd_key}
\title{\strong{CFBD API Key Registration}}
\usage{
cfbd_key()

has_cfbd_key()
}
\description{
Save your API Key as a system environment variable \code{CFBD_API_KEY}
}
\details{
To get access to an API key, follow the instructions at \url{https://collegefootballdata.com/key}

\strong{Using the key:}
You can save the key for consistent usage by adding \code{CFBD_API_KEY=YOUR-API-KEY-HERE} to your .Renviron file (easily accessed via \href{https://usethis.r-lib.org/reference/edit.html}{\strong{\code{usethis::edit_r_environ()}}}).
Run \href{https://usethis.r-lib.org/reference/edit.html}{\strong{\code{usethis::edit_r_environ()}}},
a new script will pop open named \code{.Renviron}, \strong{THEN}
paste the following in the new script that pops up (with\strong{out} quotations)

\if{html}{\out{<div class="sourceCode r">}}\preformatted{CFBD_API_KEY = YOUR-API-KEY-HERE
}\if{html}{\out{</div>}}

Save the script and restart your RStudio session, by clicking \code{Session} (in between \code{Plots} and \code{Build}) and click \verb{Restart R}
(there also exists the shortcut \code{Ctrl + Shift + F10} to restart your session).

If set correctly, from then on you should be able to use any of the \code{cfbd_} functions without any other changes.

\strong{For less consistent usage:}
At the beginning of every session or within an R environment,
save your API key as the environment variable \code{CFBD_API_KEY} (\strong{with} quotations)
using a command like the following.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{Sys.setenv(CFBD_API_KEY = "YOUR-API-KEY-HERE")
}\if{html}{\out{</div>}}
}

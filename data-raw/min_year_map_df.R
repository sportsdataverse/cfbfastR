# Helper functions ----
formal_names <- function(func) {
  names(formals(getExportedValue("cfbfastR", func)))
}
get_returned_rows <- function(...) {
  # A zero row count is ambiguous. CFBD answers HTTP 204 when a season genuinely
  # holds no data, but 5xx when it is overloaded, and the wrappers turn BOTH into
  # an empty frame. Reading a 5xx as "no data" stops the backward walk early and
  # records a minimum that is too high -- silently, and in user-facing docs.
  # `purrr::quietly()` keeps the wrapper's message, which names the status, so a
  # zero is only accepted once it is corroborated by something other than a
  # server error.
  for (attempt in 1:4) {
    out <- tryCatch(tf(...), error = function(e) NULL)
    if (!is.null(out)) {
      n <- dplyr::coalesce(nrow(out$result), 0L)
      if (n > 0) {
        return(n)
      }
      msg <- paste(out$messages, out$warnings, collapse = " ")
      if (!grepl("HTTP 5|timed out|Timeout|Could not resolve", msg)) {
        return(0L)
      }
    }
    Sys.sleep(2)
  }
  0L
}

update_map <- function(df, func_name, new_year) {
  if (df[df$function_name == func_name, 'min_year'] == new_year) {
    df[
      df$function_name == func_name,
      'last_updated'
    ] <- Sys.Date()
    print(glue::glue('{func_name}: OK'))
  } else {
    df[
      df$function_name == func_name,
      'min_year'
    ] <- new_year
    df[
      df$function_name == func_name,
      'last_updated'
    ] <- Sys.Date()
    print(glue::glue('Updated {func_name}: {new_year}'))
  }
  df
}

all_objs <- getNamespaceExports("cfbfastR")

# Find all functions that have a year argument
func_with_year <- c()
for (func in all_objs) {
  if ('year' %in% formal_names(func)) {
    func_with_year[func] <- most_recent_cfb_season()
  }
}

# Find all functions that have a week argument
func_with_week <- c()
for (func in all_objs) {
  if ('week' %in% formal_names(func)) {
    func_with_week <- append(func_with_week, func)
  }
}


# Find all ESPN functions that have a team argument
espn_team_func <- c()
for (func in all_objs) {
  if ('team_id' %in% formal_names(func) & substr(func, 1, 4) == 'espn') {
    espn_team_func <- append(espn_team_func, func)
  }
}

# Onboard any exported year-taking function that is not in the map yet, so a
# newly-added wrapper picks up a minimum instead of being silently skipped
# forever. `last_updated = NA` marks it as never probed, which the filter below
# treats as due.
new_funcs <- setdiff(names(func_with_year), min_year_map_df$function_name)
if (length(new_funcs) > 0) {
  print(glue::glue('Onboarding {length(new_funcs)} new function(s): {paste(new_funcs, collapse = ", ")}'))
  min_year_map_df <- dplyr::bind_rows(
    min_year_map_df,
    tibble::tibble(
      function_name = new_funcs,
      min_year = unname(func_with_year[new_funcs]),
      last_updated = as.Date(NA),
      inherit_min_from = NA_character_
    )
  ) |>
    dplyr::arrange(function_name)
}

# Check for minimums not updated in the last 3 months
# Include all functions that pass a minimum year through to another function
functions_to_update <- 
  min_year_map_df |> 
  dplyr::filter(
      is.na(last_updated) |
      last_updated < Sys.Date() - 90 |
      function_name %in% unique(min_year_map_df$inherit_min_from)
  )

min_year_map <-
  functions_to_update |> 
  dplyr::select(function_name, min_year) |> 
  tibble::deframe()

inherit_map <- 
  min_year_map_df |> 
  dplyr::select(function_name, inherit_min_from) |> 
  dplyr::filter(!is.na(inherit_min_from)) |> 
  tibble::deframe()

for (i in seq_along(min_year_map)) {
  func <- min_year_map[i]
  func_name <- names(func)
  

  if (func_name %in% names(inherit_map)) {
    print(glue::glue('Skipping {func_name}, inherited from {inherit_map[func_name]}'))
    next
  } else {
    print(glue::glue('Updating {func_name}...'))
  }

  returned_rows <- 1
  min_year <- unname(func)
  tf <- purrr::quietly(get(func_name))
  while (returned_rows > 0) {
    min_year <- min_year - 1
    if (func_name %in% espn_team_func) {
      returned_rows <- get_returned_rows(year = min_year, team_id = 2633)
    } else if (func_name %in% func_with_week) {
      returned_rows <- get_returned_rows(year = min_year, week = 5)
    } else {
      returned_rows <- get_returned_rows(year = min_year)
    }
    Sys.sleep(1)
  }

  updated_year <- min_year + 1
  min_year_map_df <- update_map(
    df = min_year_map_df,
    func_name = func_name,
    new_year = updated_year
  )
  if (func_name %in% inherit_map) {
    for (c_func in names(inherit_map[inherit_map == func_name])) {
      print(glue::glue('Updating {c_func}, inheriting from {func_name}...'))
      min_year_map_df <- update_map(
        df = min_year_map_df,
        func_name = c_func,
        new_year = updated_year
      )
    }
  }
}

usethis::use_data(min_year_map_df, overwrite = TRUE)

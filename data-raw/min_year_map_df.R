# Check for minimums not updated in the last 3 months
# Include all functions that pass a minimum year through to another function
functions_to_update <- 
  min_year_map_df |> 
  dplyr::filter(
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

# Helper functions ----
formal_names <- function(func) {
  names(formals(getExportedValue("cfbfastR", func)))
}
get_returned_rows <- function(...) {
  dplyr::coalesce(
    nrow(
      tryCatch(
        tf(...)$result,
        error = function(e) e
      )
    ),
    0
  )
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
    func_with_year[func] <- 2025
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

usethis::use_data(min_year_map_df, overwrite = TRUE, internal = TRUE)

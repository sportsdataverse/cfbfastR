# Drop the cached xgboost boosters when the test session ends.
#
# covr saves its counters in an exit hook that runs after xgboost has freed
# its boosters, and `saveRDS()` aborts ("Booster has not been initialized or
# has already been disposed") if anything it reaches still holds one. Emptying
# the model caches at teardown, while the handles are valid, leaves nothing to
# reach.
withr::defer({
  ns <- asNamespace("cfbfastR")
  for (env in list(ns$.cfb_models, ns$.cfb_model_env)) {
    rm(list = setdiff(ls(env, all.names = TRUE), "unavailable"), envir = env)
  }
  gc()
}, testthat::teardown_env())

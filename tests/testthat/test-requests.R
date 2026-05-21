test_that("GET requests remain consistent", {
  expect_snapshot(get_sims("project"))
  expect_snapshot(get_sims("user", "self"))
  expect_snapshot(get_sims("project", 999, "survey", 999, "devices"))
})

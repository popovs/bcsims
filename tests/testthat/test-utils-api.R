test_that("sims client stays consistent", {
  expect_snapshot(sims_client())
})

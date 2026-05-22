
with_mock_dir("api", {
  test_that("when all = TRUE (default), get_sims_projects returns all projects", {
    expect_equal(nrow(get_sims_projects(all = TRUE)), 10)
    expect_equal(nrow(get_sims_projects()), 10)
  })

  test_that("when all = FALSE, get_sims_projects returns only personal projects (system_user_id == 999)", {
    expect_equal(nrow(get_sims_projects(all = FALSE)), 1)
    expect_equal(unique(unlist(get_sims_projects(all = FALSE)$members)), "Gov, BC ORG:EX")
  })

  test_that("when all = TRUE and params are provided, only projects matching the params are returned", {
    expect_equal(nrow(get_sims_projects(params = list(keyword = "wolf"))), 1)
    expect_equal(nrow(get_sims_projects(params = list(keyword = "dog"))), 2)
    # TODO: add other params tests (e.g. species code)
  })

  test_that("when all = FALSE and params are provided, only personal projects matching the params are returned", {
    expect_equal(get_sims_projects(all = FALSE, params = list(keyword = "asdfasdfasdfasdfasdf")), "Your query returned no results. Please try a different query.")
    expect_equal(nrow(get_sims_projects(all = FALSE, params = list(keyword = "dog"))), 0)
    # TODO: add other params tests (e.g. species code)

  })
})



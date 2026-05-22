
with_mock_dir("api", {
  test_that("when no args passed, get_sims_surveys returns all surveys", {
    expect_equal(nrow(get_sims_surveys()), 19)
  })

  test_that("when numeric arg passed, get_sims_surveys returns the corresponding project_id's surveys", {
    expect_equal(nrow(get_sims_surveys(1)), 6)
    expect_equal(nrow(get_sims_surveys(2)), 1)
  })

  # TODO: this behavior is confusing and should probably be fixed down the line,
  # so that's why these tests exist. Ideally you can filter on both project_id
  # AND params, but at least this warns the user it's ignored.
  test_that("when numeric arg passed, other args are ignored", {
    expect_warning(get_sims_surveys(1, params = list(keyword = "dog")))
  })

  test_that("when params arg is passed, other args are ignored", {
    expect_warning(get_sims_surveys(params = list(keyword = "cow"), project_id = 4))
  })
})

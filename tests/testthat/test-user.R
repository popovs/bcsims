# TESTS TO WRITE

# Test that the fxn returns system_user_id, user_identifier,
# identity_source, role_names, email, display_name
with_mock_dir("api", {
  test_that("get_sims_user returns expected fields", {
    expect_contains(names(get_sims_user()), "system_user_id")
    expect_contains(names(get_sims_user()), "user_identifier")
    expect_contains(names(get_sims_user()), "identity_source")
    expect_contains(names(get_sims_user()), "role_names")
    expect_contains(names(get_sims_user()), "email")
    expect_contains(names(get_sims_user()), "display_name")
  })
  test_that("system_user_id returns 999", {
    expect_equal(get_sims_user()$system_user_id, 999)
  })
})

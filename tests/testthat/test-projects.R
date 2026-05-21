test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})


# TESTS TO WRITE

# Test that pagination consistently only returns on page,
# otherwise we are missing data

# Test that all = FALSE returns only personal records

# Test that params actually filter the response
# (I know that currently the project_name param
# is buggy)

# If pagination/record limits are eventually coded in,
# test that page limits actually return the expected number
# of records

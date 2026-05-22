# Copyright 2026 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
    # keyword
    expect_equal(nrow(get_sims_projects(params = list(keyword = "wolf"))), 1)
    expect_equal(nrow(get_sims_projects(params = list(keyword = "dog"))), 2)
    # TSN
    expect_equal(nrow(get_sims_projects(params = list(itis_tsn = 180596))), 1)
    expect_equal(nrow(get_sims_projects(params = list(itis_tsn = 183815))), 3)
  })

  test_that("when all = FALSE and params are provided, only personal projects matching the params are returned", {
    # keyword
    expect_equal(get_sims_projects(all = FALSE, params = list(keyword = "wolf")), "Your query returned no results. Please try a different query.")
    expect_equal(nrow(get_sims_projects(all = FALSE, params = list(keyword = "dog"))), 1)
    # TSN
    expect_equal(get_sims_projects(all = FALSE, params = list(itis_tsn = 180596)), "Your query returned no results. Please try a different query.")
    expect_equal(nrow(get_sims_projects(all = FALSE, params = list(itis_tsn = 183815))), 1)
  })

  test_that("when nonsense params are provided, API error occurs", {
    expect_error(get_sims_projects(all = TRUE, params = list(itis_tsn = c("x"))))
    # expect_equal(class(get_sims_projects(all = TRUE, params = list(itis_tsn = "x"))), "httr2_response") # not sure how to get this to work
    expect_error(get_sims_projects(all = TRUE, params = list(itis_tsns = c(1, "x", 99999999999))))
    expect_error(get_sims_projects(all = FALSE, params = list(itis_tsns = "x")))
  })

  test_that("when no results are returned, message is printed", {
    expect_equal(get_sims_projects(all = TRUE, params = list(keyword = "asdfasdfasdfasdfasdf")), "Your query returned no results. Please try a different query.")
    expect_equal(get_sims_projects(all = FALSE, params = list(keyword = "asdfasdfasdfasdfasdf")), "Your query returned no results. Please try a different query.")

  })
})



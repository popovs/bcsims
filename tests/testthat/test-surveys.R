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

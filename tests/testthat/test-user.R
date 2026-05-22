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

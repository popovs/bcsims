#' Copyright 2026 Province of British Columbia
#'
#' Licensed under the Apache License, Version 2.0 (the "License");
#' you may not use this file except in compliance with the License.
#' You may obtain a copy of the License at
#'
#' http://www.apache.org/licenses/LICENSE-2.0
#'
#' Unless required by applicable law or agreed to in writing, software
#' distributed under the License is distributed on an "AS IS" BASIS,
#' WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#' See the License for the specific language governing permissions and
#' limitations under the License.


# Query information about yourself as a user in SIMS

#' Get current user metadata
#' @noRd
get_sims_user <- function() {
  # Build request
  # /user/self
  self <- get_sims("user", "self") |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    jsonlite::fromJSON()

  return(self)
}

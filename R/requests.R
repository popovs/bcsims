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

#' Functions to build SIMS API GET, POST, and DELETE requests
#'
#' TODO list:
#' - consider actually performing the request w `get_sims()` to reduce
#'    duplicated code bits in every other `get_sims_*` fxn.

#' Build a SIMS API URL GET request
#'
#' A utility function to build a valid GET request URL for you. See the SIMS
#' [sims-api](https://api-biohubbc.apps.silver.devops.gov.bc.ca/api-docs/) documentation for
#' all valid API endpoints. All other bcsims `get_*` functions are wrappers
#' around this function.
#'
#' @param ... URL components of the GET request, seperated by commas.
#' @examples
#' # Build URL to grab surveys from project '999':
#' # /project/{projectId}/survey/
#' get_sims("project", 999, "survey")
#'
#' @return An object of class 'httr2_request'
#'
#' @export
get_sims <- function(...) {
  # Build the base request URL
  req <- httr2::request(base_url = sims_base_api_url()) |>
    httr2::req_oauth_auth_code(client = sims_client(),
                               auth_url = sims_auth_url(),
                               redirect_uri = sims_redirect_uri()) |>
    httr2::req_method("GET") |>
    httr2::req_headers(accept = "application/json")
  # Append any dots `...` args to the URL
  url_bits <- list(...)
  # Add the url_bits to the request URL
  req <- req |>
    httr2::req_url_path_append(url_bits)
  # TODO: since the request is pretty much always performed
  # in all subsequent fxns, maybe just perform the request within
  # this fxn too? And take care of basic table formatting +
  # dealing w pagination?
  # It would require some logic, since e.g. the users request returns
  # no pages, but a list of 12 items (see `get_sims_user`)
  # THE DOWNSIDE OF THIS is that it's not as easy to pass extra
  # API params to fxns down the line. THis method is nice bc it
  # builds the base URL route and then you can tack on params at the end.
  # Return
  return(req)
}

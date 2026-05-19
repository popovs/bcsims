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

#' Functions to build SIMS API GET requests

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
  # Return
  return(req)
}




# TODO: should be option to leave project_id NULL,
# which calls 'get all surveys' method, or to supply project_id(s),
# which returns surveys for the project_id(s)
get_sims_surveys <- function(project_id, params = NULL) {
  # Build request
  # /project/{projectId}/survey/
  req <- get_sims("project", project_id, "survey") |>
    httr2::req_url_query(!!!params, .multi = "explode") # then add our params to the end of the URL

  # GET response
  resp <- httr2::req_perform(req) |>
    httr2::resp_body_string() # resp_body_json for tidyjson methods, resp_body_string for jsonlite methods.

  # Extract surveys
  surveys <- jsonlite::fromJSON(resp)[[1]] # Just grab first item. Item 2 is just the pagination information

  # survey-specific cleanup
  surveys <- surveys |>
    tidyr::as_tibble() |> # to match other tidy outputs/generally with the broader API pkg ecosystem
    dplyr::mutate(progress = dplyr::case_when(progress_id == 1 ~ "Planning",
                                              progress_id == 2 ~ "In Progress",
                                              progress_id == 3 ~ "Completed")) |>
    dplyr::mutate(start_date = as.Date(start_date),
                  end_date = as.Date(end_date)) |>
    dplyr::select(survey_id, name, start_date, end_date, progress, focal_species, focal_species_names)

  return(surveys)

}

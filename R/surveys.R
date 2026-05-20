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


#' Get a table of available surveys in SIMS
#'
#' @param project_id A single project ID number.
#' @param params A list of API parameters, e.g. `list(keyword = "bctw", keyword = "telemetry", itis_tsns = c(180701, 202411))`. See Details for a list of acceptable parameters. Currently `params` are ignored if a project_id has been supplied.
#' @param ... Not used.
#'
#' @returns A tibble of surveys.
#' @export
#'
#' @examples
#' \dontrun{
#' # Get all surveys available to the user
#' all_surveys <- get_sims_surveys()
#'
#' # Get all surveys that match a certain criteria
#' wolf_surveys <- get_sims_surveys(params = list(keyword = "wolf"))
#' caribou_surveys <- get_sims_surveys(params = list(itis_tsn = 180596))
#'
#' # Get surveys under a specific project ID
#' # Note this method ignores the `params` argument
#' caribou_surveys <- get_sims_surveys(42)
#' }
get_sims_surveys <- function(...) {
  UseMethod("get_sims_surveys")
}

#' @rdname get_sims_surveys
#' @export
get_sims_surveys.default <- function(params = NULL, ...) {
  # Build request
  # /survey/
  req <- get_sims("survey") |>
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
    dplyr::select(survey_id, project_id, name, start_date, end_date, progress, regions, focal_species)

  return(surveys)
}

#' @rdname get_sims_surveys
#' @export
get_sims_surveys.numeric <- function(project_id, ...) {
  # Build request
  # /project/{projectId}/survey/
  req <- get_sims("project", project_id, "survey")
  # TODO: Note this method will ignore the params argument, until the params
  # are standardized between the two API urls.

  # GET response
  resp <- httr2::req_perform(req) |>
    httr2::resp_body_string() # resp_body_json for tidyjson methods, resp_body_string for jsonlite methods.

  # Extract surveys
  # TODO: will this fail if there are many pages? does the request
  # need to be looped for each page?
  surveys <- jsonlite::fromJSON(resp)[[1]] # Just grab first item. Item 2 is just the pagination information

  # Add project_id as a col
  surveys$project_id <- project_id

  # survey-specific cleanup
  surveys <- surveys |>
    tidyr::as_tibble() |> # to match other tidy outputs/generally with the broader API pkg ecosystem
    dplyr::mutate(progress = dplyr::case_when(progress_id == 1 ~ "Planning",
                                              progress_id == 2 ~ "In Progress",
                                              progress_id == 3 ~ "Completed")) |>
    dplyr::mutate(start_date = as.Date(start_date),
                  end_date = as.Date(end_date)) |>
    dplyr::select(survey_id, project_id, name, start_date, end_date, progress, focal_species, focal_species_names)

  return(surveys)

}

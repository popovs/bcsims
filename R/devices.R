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


#' Get a table of devices within a given project and/or survey
#'
#' @param project_id A single project ID number.
#' @param survey_id Optional. A survey number within a given project. If no `project_id` is supplied, the function will pull devices from all surveys within a given project.
#'
#' @returns A tibble of devices.
#' @export
#'
#' @examples
#' \dontrun{
#' get_sims_devices(project_id = 1)
#'
#' get_sims_devices(project_id = 1, survey_id = 101)
#' }
get_sims_devices <- function(project_id, survey_id = NULL) {
  # Our current devices API endpoint is a bit awkward in that it
  # requires both project_id and survey_id to be provided.

  # If survey_id is NULL, query the project to grab the survey_ids
  # to then loop through the request for each survey id.
  if (is.null(survey_id)) {
    # Mark that is was NULL
    survey_supplied_null <- TRUE
    # Grab all survey ids for the given project_id
    x <- get_sims_surveys(project_id)
    survey_id <- x$survey_id
  } else {
    survey_supplied_null <- FALSE
  }

  # If only one survey_id, perform a single GET request
  if (length(survey_id) == 1) {
    # Build request
    # /project/{projectId}/survey/{surveyId}/devices
    req <- get_sims("project", project_id, "survey", survey_id, "devices")

    # GET response
    resp <- httr2::req_perform(req) |>
      httr2::resp_body_string() # resp_body_json for tidyjson methods, resp_body_string for jsonlite methods.

    # Extract devices
    # TODO: will this fail if there are many pages? does the request
    # need to be looped for each page?
    devices <- jsonlite::fromJSON(resp)[[1]] # Just grab first item. Item 2 is just the pagination information

  } else {

    # Else if multiple survey_ids, loop through that GET
    # request for each and every survey_id.
    devices <- lapply(survey_id, function(i) {
      req <- get_sims("project", project_id, "survey", i, "devices")
      resp <- httr2::req_perform(req) |>
        httr2::resp_body_string()
      # TODO: will this fail if there are many pages? does the request
      # need to be looped for each page?
      out <- jsonlite::fromJSON(resp)[[1]]
      return(out)
    })

    devices <- dplyr::bind_rows(devices)

  }

  # Return message if no devices found,
  # else return devices df.
  if (length(devices) == 0) {
    if (survey_supplied_null) {
      return(paste0("There are no devices associated with this project (project_id = ", project_id, ")."))
    } else {
      return(paste0("There are no devices associated with this survey (project_id = ", project_id, ", survey_id = ", survey_id, ")."))
    }
  } else {
    # Add supplied project_id as a column
    devices$project_id <- project_id

    # Clean up the table
    devices <- devices |>
      tidyr::as_tibble() |> # to match other tidy outputs/generally with the broader API pkg ecosystem
      dplyr::select(device_id, survey_id, project_id, dplyr::everything(), -device_make_id)

    return(devices)
  }


}


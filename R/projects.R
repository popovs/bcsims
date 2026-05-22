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

# Get a table of all available projects in SIMS
#'
#' This function grabs all projects visible to you as a SIMS user.
#'
#' @details API parameters are supplied as a named vector list.
#' For the most up-to-date list of parameters accepted by the API, see the [API documentation](https://api-biohubbc.apps.silver.devops.gov.bc.ca/api-docs/).
#'
#' * **keyword** String. Keywords to search for in the project name. Case-insensitive.
#' * **itis_tsns** Integer. ITIS TSN numbers. Multiple numbers can be supplied at once as a comma-separated vector. _Note this will eventually be superceded by BC Conservation Data Centre taxon codes._
#' * **itis_tsn** Integer. ITIS TSN number. _Note this will eventually be superceded by BC Conservation Data Centre taxon codes._
#' * **project_name** String. Partial or full match of project name. Case-insensitive.
#'
#' @param all Logical. Should records for all available projects in SIMS be returned, or only personal user projects? All projects are returned by default.
#' @param params A vector of API parameters, e.g. `list(keyword = "bctw", keyword = "telemetry", itis_tsns = c(180701, 202411))`. See Details for a list of acceptable parameters.
#'
#' @returns A tibble of projects.
#' @export
#'
#' @examples
#' \dontrun{
#' # Get all projects the user has access to
#' get_sims_projects()
#'
#' # Filter to only those with the keyword "wolf"
#' get_sims_projects(params = list(keyword = "wolf"))
#'
#' # Filter to only those with the keyword "wolf" and ITIS TSNs of caribou
#' get_sims_projects(params = list(keyword = "wolf", itis_tsns = c(180701)))
#' }
get_sims_projects <- function(all = TRUE, params = NULL) {
  # If all = TRUE, just run the API request on the whole SIMS db.

  # If all = FALSE, query only personal projects.
  # Therefore add the current user's system_user_id to the params,
  # so as to limit the query to only the current user's system_user_id projects.
  if (!all) params <- c(system_user_id = get_sims_user()$system_user_id,
                        params)

  # Build request
  # /project/<?params = param>
  req <- get_sims("project") |> # build our base SIMS request URL using the req_sims() fxn, then append 'project'
    httr2::req_url_query(!!!params, .multi = "explode") # then add our params to the end of the URL

  # GET response
  resp <- httr2::req_perform(req) |>
    httr2::resp_body_string() # resp_body_json for tidyjson methods, resp_body_string for jsonlite methods.

  # Extract projects
  # TODO: will this fail if there are many pages? does the request
  # need to be looped for each page?
  projects <- jsonlite::fromJSON(resp)[[1]] # Just grab first item. Item 2 is just the pagination information

  # Clean up output
  # Tidy up projects table
  # TODO: maybe make this a separate tidying fxn?

  # TODO: perhaps a page/n records limit - once SIMS gets huge?

  # Only continue if API result returned anything - otherwise return empty df
  if (length(projects) == 0) {

    cat("Your query returned no results. Please try a different query.")

  } else {

    # First clean up uggo members matrix-col
    members <- projects |>
      dplyr::select(project_id, members) |>
      tidyr::unnest(cols = members) |>
      dplyr::select(project_id, display_name) |> # no need to keep system_user_id at this point
      dplyr::group_by(project_id) |>
      dplyr::summarise(members = list(display_name)) # create a list-col of members (rather than matrix col)

    # Merge members col back to original df
    projects <- projects |>
      dplyr::select(-members, -types) |> # drop existing ugly matrix-col, types col
      merge(members, by = "project_id") |>
      dplyr::mutate(start_date = as.Date(start_date),
                    end_date = as.Date(end_date)) |>
      tidyr::as_tibble() # tidy it - make our list-cols explicit! To match other tidy outputs/generally with the broader API pkg ecosystem


    return(projects)
  }


}



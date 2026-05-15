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

# Set package-wide API params & declare SIMS utility fxns (e.g., listing
# projects your account has access to.)


# URLs --------------------------------------------------------------------

# getOption is helpful here bc during package developement, you can
# easily use `options()` to change the underlying URL on the fly
# if needed.
# https://r-pkgs.org/code.html#sec-code-onLoad-onAttach

# Base URL of the website itself
sims_base_url <- function() {
  getOption(
    "bcsims.sims_gui_url",
    default = "https://sims.nrs.gov.bc.ca/"
  )
}

# Base URL for all API requests
sims_base_api_url <- function() {
  getOption(
    "bcsims.sims_api_url",
    default = "https://api-biohubbc.apps.silver.devops.gov.bc.ca"
  )
}

# Base URL for generating auth token (IDIR login)
sims_token_url <- function() {
  getOption(
    "bcsims.sims_token_url",
    default = "https://loginproxy.gov.bc.ca/auth/realms/standard/protocol/openid-connect/token"
  )
}

# Base URL for opening OAuth/IDIR authentication
sims_auth_url <- function() {
  getOption(
    "bcsims.sims_auth_url",
    default = "https://loginproxy.gov.bc.ca/auth/realms/standard/protocol/openid-connect/auth"
  )
}

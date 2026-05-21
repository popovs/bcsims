# GET requests remain consistent

    Code
      get_sims("project")
    Output
      <httr2_request>
      GET https://api-biohubbc.apps.silver.devops.gov.bc.ca/project
      Headers:
      * accept: "application/json"
      Body: empty
      Policies:
      * auth_sign : <list>
      * auth_oauth: TRUE

---

    Code
      get_sims("user", "self")
    Output
      <httr2_request>
      GET https://api-biohubbc.apps.silver.devops.gov.bc.ca/user/self
      Headers:
      * accept: "application/json"
      Body: empty
      Policies:
      * auth_sign : <list>
      * auth_oauth: TRUE

---

    Code
      get_sims("project", 999, "survey", 999, "devices")
    Output
      <httr2_request>
      GET https://api-biohubbc.apps.silver.devops.gov.bc.ca/project/999/survey/999/devices
      Headers:
      * accept: "application/json"
      Body: empty
      Policies:
      * auth_sign : <list>
      * auth_oauth: TRUE


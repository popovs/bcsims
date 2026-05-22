# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
# * https://testthat.r-lib.org/articles/special-files.html

library(testthat)
library(bcsims)

test_check("bcsims")

# Misc notes on remaining issues that get flagged in R CMD CHECK
#
# "no visible binding for global variable 'foo'"
# I'm specifically choosing to ignore this issue for now because
# it feels more akin to a CRAN/check issue rather than a code
# issue. All workarounds I have found are more centered on hacky
# ways of getting `check` to be 'blind' to the issue, when in
# reality, this shouldn't be getting picked up by `check` in the
# first place, especially now that the native pipe |> has been
# introduced into base R.

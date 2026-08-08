## ---------------------------------------------------------------------------
## Single source of truth for the packages used across the dashboard project.
## Sourced from scripts/load_data.R (pre-render) and from every page's setup
## chunk, so the package list only needs to be maintained in one place.
## ---------------------------------------------------------------------------

librarian::shelf(
  tidyverse, lubridate, scales, plotly, highcharter, reactable, reactablefmtr,
  gt, gtExtras, glue, eurostat, ggiraph, countrycode, bslib, bsicons, leaflet,
  giscoR, sf, crosstalk, htmlwidgets, DT, shiny, httr, jsonlite
)

## ---------------------------------------------------------------------------
## Fetches and caches all data needed by the dashboard subpages.
## Run as a Quarto project pre-render step (see _quarto.yml). Quarto's
## project-level pre-render normally runs once per full-site render, but it
## also fires again for single-page preview/render, and Positron's preview
## re-renders on every save. To avoid re-fetching all sources needlessly, the
## snapshot is only regenerated if it's missing or older than `max_age_hours`.
## Delete data/snapshot.RData (or lower max_age_hours) to force a refresh.
## ---------------------------------------------------------------------------

snapshot_path <- "data/snapshot.RData"
max_age_hours <- 6

if (file.exists(snapshot_path) &&
    difftime(Sys.time(), file.info(snapshot_path)$mtime, units = "hours") < max_age_hours) {
  message("load_data.R: using cached ", snapshot_path, " (< ", max_age_hours, "h old), skipping fetch.")
  quit(save = "no", status = 0)
}

source("scripts/load_packages.R")

countries <- countrycode::codelist |>
    filter(eu28 == "EU") |>
    select(iso2c, country.name.de)

gdp <- eurostat::get_eurostat("nama_10_gdp", time_format = "date", filters = list(geo = "AT", na_item = "B1GQ", unit = "CP_MEUR"))

gdpgrowth <- eurostat::get_eurostat("tec00115", time_format = "date", filters = list(geo = "AT", unit = "CLV_PCH_PRE"))

gdppc <- eurostat::get_eurostat("sdg_08_10", time_format = "date", filters = list(unit = "CLV20_EUR_HAB", sinceTimePeriod = 2000))

unemp <- eurostat::get_eurostat("une_rt_m", time_format = "date", filters = list(age = "TOTAL", sex = "T", s_adj = "SA", unit = "PC_ACT", lastTimePeriod = 3)) |> drop_na()

poverty <- eurostat::get_eurostat("ilc_peps01n", time_format = "date", filters = list(geo = "AT", sex = "T", age = "TOTAL", unit = "PC", lastTimePeriod = 3)) |> drop_na()

gpg <- eurostat::get_eurostat("earn_gr_gpgr2", time_format = "date", filters = list(nace_r2 = "B-S_X_O", lastTimePeriod = 1)) |> drop_na()

annualunemp <- eurostat::get_eurostat("une_rt_a", time_format = "date", filters = list(age = "Y15-74", sex = "T", unit = "PC_ACT", lastTimePeriod = 15)) |> drop_na()

inflation <- eurostat::get_eurostat("prc_hicp_minr", time_format = "date", filters = list(coicop18 = "TOTAL", unit = "RCH_A", lastTimePeriod = 24))

tempwien <- GET(glue::glue("https://dataset.api.hub.geosphere.at/v1/station/historical/klima-v2-1d?parameters=tlmax&start=1950-01-01&end={today()}&station_ids=105"))

eumap <- gisco_get_nuts(year = 2021, epsg = 4326, nuts_level = 0, resolution = 10)

dir.create("data", showWarnings = FALSE)
save.image(file = snapshot_path)

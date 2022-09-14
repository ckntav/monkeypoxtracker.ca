setwd("/Users/chris/Desktop/monkeypoxtracker.ca")

library(tidyverse)
library(lubridate)
library(highcharter)
library(wesanderson)

# library(viridisLite)
# library(knitr)
library(rvest)
# # library(leaflet)
# library(sf)


date_mkp <- "20220914"
file_mkp <- FALSE

if (TRUE) {
  link_data_mkp <- "https://health-infobase.canada.ca/src/data/monkeypox/monkeypox-map.csv"
  rawData <- read_csv(link_data_mkp, show_col_types = FALSE)
  latest_date <- rawData %>% pull(date) %>% max
  message(" > latest date : ", latest_date)
  if (latest_date == ymd(date_mkp)) {
    download.file(link_data_mkp, destfile = file.path("_codes", "input", "rawData_csv", paste0(date_mkp, "_monkeypox-map.csv")))
    file_mkp <- TRUE
  }
}

if (file_mkp) {
  source("_codes/scripts/set_date_last_update.R")
  source("_codes/scripts/makeRDS.R")
  source("_codes/scripts/evolution_nb_cases_sum.R")
  source("_codes/scripts/evolution_nb_cases_7day_average.R")
  source("_codes/scripts/map_ca_total_cases.R")
  source("_codes/scripts/var_nb_cases_byProvince.R")
  source("_codes/scripts/widget_nb_cases_canada.R")
}

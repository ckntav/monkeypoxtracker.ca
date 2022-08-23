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


date_mkp <- "20220819"
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

source("_codes/scripts/makeRDS.R")
source("_codes/scripts/evolution_nb_cases_sum.R")
source("_codes/scripts/evolution_nb_cases_7day_average.R")





# # set_env.R
# source("_codes/scripts/set_env.R")
# 
# ###########
# date <- "20220822"
# date_santeqc_age <- "20220822"
# date_santeqc_rdv_age <- "20220822"
# date_santeqc_qc <- "20220822"
# date_santeqc_rdv_qc <- "20220822"
# date_santeqc_res <- "20220822"
# date_inspq <- "20220822"
# 
# #
# file_vax_catAge <- FALSE
# file_vax_regAdm <- FALSE
# file_vax_regRes <- FALSE
# file_vax_rdvAge <- FALSE
# file_vax_rdvResAdm <- FALSE
# 
# ##### Check and download files
# if (TRUE) {
#   # 1
#   link_vax_catAge <- "https://msss.gouv.qc.ca/professionnels/statistiques/documents/covid19/COVID19_Qc_Vaccination_CatAge.csv"
#   vax_catAge_csv <- read_csv(link_vax_catAge, show_col_types = FALSE)
#   date_vax_catAge <- vax_catAge_csv %>% pull(date) %>% max()
#   message("> date_vax_catAge: ", date_vax_catAge)
#   if (date_vax_catAge == ymd(date_santeqc_age) - ddays(1)) {
#     download.file(link_vax_catAge, destfile = file.path("_codes", "input_santeqc", paste0(date_santeqc_age, "_COVID19_Qc_Vaccination_CatAge.csv")))
#     file_vax_catAge <- TRUE
#   }
#   
#   # 2
#   link_vax_regAdm <- "https://msss.gouv.qc.ca/professionnels/statistiques/documents/covid19/COVID19_Qc_Vaccination_RegionAdministration.csv"
#   vax_regAdm_csv <- read_csv(link_vax_regAdm, show_col_types = FALSE)
#   date_vax_regAdm <- vax_regAdm_csv %>% pull(date) %>% max()
#   message("> date_vax_regAdm: ", date_vax_regAdm)
#   if (date_vax_regAdm == ymd(date_santeqc_qc) - ddays(1)) {
#     download.file(link_vax_regAdm, destfile = file.path("_codes", "input_santeqc", paste0(date_santeqc_qc, "_COVID19_Qc_Vaccination_RegionAdministration.csv")))
#     file_vax_regAdm <- TRUE
#   }
#   
#   # 3
#   link_vax_regRes <- "https://msss.gouv.qc.ca/professionnels/statistiques/documents/covid19/COVID19_Qc_Vaccination_RegionResidence.csv"
#   vax_regRes_csv <- read_csv(link_vax_regRes, show_col_types = FALSE)
#   date_vax_regRes <- vax_regRes_csv %>% pull(date) %>% max()
#   message("> date_vax_regRes: ", date_vax_regRes)
#   if (date_vax_regRes == ymd(date_santeqc_res) - ddays(1)) {
#     download.file(link_vax_regRes, destfile = file.path("_codes", "input_santeqc", paste0(date_santeqc_res, "_COVID19_Qc_Vaccination_RegionResidence.csv")))
#     file_vax_regRes <- TRUE
#   }
#   
#   # 4
#   link_vax_rdvAge <- "https://msss.gouv.qc.ca/professionnels/statistiques/documents/covid19/COVID19_Qc_RDVVaccination_CatAge.csv"
#   vax_rdvAge_csv <- read_csv(link_vax_rdvAge, show_col_types = FALSE)
#   date_vax_rdvAge <- vax_rdvAge_csv %>% pull(date)
#   message("> date_vax_rdvAge: ", date_vax_rdvAge)
#   if (date_vax_rdvAge == ymd(date_santeqc_rdv_age)) {
#     download.file(link_vax_rdvAge, destfile = file.path("_codes", "input_santeqc", paste0(date_santeqc_rdv_age, "_COVID19_Qc_RDVVaccination_CatAge.csv")))
#     file_vax_rdvAge <- TRUE
#   }
#   
#   # 5
#   link_vax_rdvResAdm <- "https://msss.gouv.qc.ca/professionnels/statistiques/documents/covid19/COVID19_Qc_RDVVaccination_RegionAdministration.csv"
#   vax_rdvResAdm_csv <- read_csv(link_vax_rdvResAdm, show_col_types = FALSE)
#   date_vax_rdvResAdm <- vax_rdvResAdm_csv %>% pull(date)
#   message("> date_vax_rdvResAdm: ", date_vax_rdvResAdm)
#   if (date_vax_rdvResAdm == ymd(date_santeqc_rdv_qc)) {
#     download.file(link_vax_rdvResAdm, destfile = file.path("_codes", "input_santeqc", paste0(date_santeqc_rdv_qc, "_COVID19_Qc_RDVVaccination_RegionAdministration.csv")))
#     file_vax_rdvResAdm <- TRUE
#   }
#   
#   #
#   print(c(file_vax_catAge, file_vax_regAdm, file_vax_regRes, file_vax_rdvAge, file_vax_rdvResAdm))
# }
# 
# # set_date.R
# source("_codes/scripts/set_date.R")
# 
# ### <date>_COVID19_Qc_Vaccination_RegionAdministration
# source("_codes/scripts_santeqc/evolution_qc_cumul_percent.R")
# 
# # source("_codes/scripts_santeqc/estimate_obj_31aout.R")
# source("_codes/scripts_santeqc/evolution_qc_perday.R")
# source("_codes/scripts_santeqc/evolution_qc_perday_1_vs_2_vs_3_vs_4.R")
# source("_codes/scripts_santeqc/evolution_qc_perday_1_vs_2_vs_3_vs_4_percent.R")
# # source("_codes/scripts_santeqc/evolution_diff.R")
# source("_codes/scripts_santeqc/estimation_doses_qc.R")
# # source("_codes/scripts_santeqc/evolution_qc_2vs1.R")
# # TODO 3vs2 # source("_codes/scripts_santeqc/evolution_qc_2vs1.R")
# 
# ### <date>_COVID19_Qc_Vaccination_CatAge.csv
# # *.R
# source("_codes/scripts_santeqc/evolution_agegroup_percent.R")
# source("_codes/scripts_santeqc/make_flourish_age_percent.R")
# # source("_codes/scripts_santeqc/estimate_pop75_adult_1dose.R")
# # source("_codes/scripts_santeqc/estimate_pop75_12p_1dose.R") 
# # source("_codes/scripts_santeqc/estimate_pop75_12p_2dose.R")
# # source("_codes/scripts_santeqc/estimate_pop80_12p_2dose.R")
# # source("_codes/scripts_santeqc/estimate_pop85_12p_2dose.R")
# # source("_codes/scripts_santeqc/estimate_pop90_12p_2dose.R")
# # source("_codes/scripts_santeqc/estimate_pop75_5_11_1dose.R")
# # source("_codes/scripts_santeqc/estimate_pop75_18p_3dose.R")
# # source("_codes/scripts_santeqc/generate_12p_delta.R")
# # source("_codes/scripts_santeqc/estimate_pop75_1dose_perAge.R")
# # source("_codes/scripts_santeqc/estimate_pop75_1dose_perAge.R")
# # source("_codes/scripts_santeqc/estimate_pop80_1dose_perAge.R")
# # source("_codes/scripts_santeqc/estimate_pop85_1dose_perAge.R")
# # source("_codes/scripts_santeqc/estimate_pop90_1dose_perAge.R")
# # source("_codes/scripts_santeqc/estimate_pop75_2dose_perAge.R")
# # source("_codes/scripts_santeqc/estimate_pop80_2dose_perAge.R")
# # source("_codes/scripts_santeqc/estimate_pop85_2dose_perAge.R")
# # source("_codes/scripts_santeqc/estimate_pop90_2dose_perAge.R")
# # source("_codes/scripts_santeqc/estimate_pop75_3dose_perAge.R")
# source("_codes/scripts_santeqc/test_streamgraph_age.R")
# # source("_codes/scripts_santeqc/test_streamgraph_age2.R")
# source("_codes/scripts_santeqc/barchart_age_aplus.R")
# source("_codes/scripts_santeqc/make_df_age_aplus_percent_2days.R")
# source("_codes/scripts_santeqc/widget_qc_v2.R")
# source("_codes/scripts_santeqc/widget_qc_donut_v5.R")
# # source("_codes/scripts_santeqc/dashboard_tweet/barchart_age_tweet3.R")
# # source("_codes/scripts_santeqc/dashboard_tweet/barchart_age_tweet4.R")
# # source("_codes/scripts_santeqc/dashboard_tweet/barchart_age_tweet5.R")
# source("_codes/scripts_santeqc/dashboard_tweet/barchart_age_tweet6_var7d.R")
# # source("_codes/scripts_santeqc/test_windrose.R")
# # source("_codes/scripts_santeqc/test_windrose_2.R")
# # source("_codes/scripts_santeqc/test_windrose_dose2.R")
# # source("_codes/scripts_santeqc/test_windrose_2_dose2.R")
# # source("_codes/scripts_santeqc/barchart_age_unvax_vs_2d.R")
# # source("_codes/scripts_santeqc/estimate_popX_2dose_perAge_nb_doses.R")
# # source("_codes/scripts_santeqc/starvax_v5.R")
# source("_codes/scripts_santeqc/analysis/evolution_nb_doses_perAge.R")
# # source("_codes/scripts_santeqc/analysis/thirdDose_eligible.R")
# # source("_codes/scripts_santeqc/analysis/evolution_effetSAQ.R")
# source("_codes/scripts_santeqc/animate/fixed_age_percent_polar_1d_2d_3d_4d_unvax_geom_rect.R")
# # source("_codes/scripts_santeqc/evolution_qc_perday_1d_5_11ans.R")
# # source("_codes/scripts_santeqc/evolution_qc_perday_2d_5_11ans.R")
# 
# # if (date_santeqc_age == date_santeqc_rdv_age & file_vax_rdvAge == TRUE) {
# #   # source("_codes/scripts_santeqc/process_rdv_age_pop80.R")
# #   # source("_codes/scripts_santeqc/process_rdv_age_popX.R")
# #   ## source("_codes/scripts_santeqc/evolution_rdv_age.R")
# #   ## source("_codes/scripts_santeqc/starvax_v2.R")
# #   ##
# 
# #   ## source("_codes/scripts_santeqc/evolution_rdv_restant.R")
# #   ## source("_codes/scripts_santeqc/process_rdv_age_expl.R")
# #   # source("_codes/scripts_santeqc/process_rdv_age_expl2.R")
# #   # source("_codes/scripts_santeqc/process_rdv_age_expl_total.R")
# #   # source("_codes/scripts_santeqc/process_rdv_age_expl_total2.R")
# # }
# 
# ### <date>_COVID19_Qc_Vaccination_RegionResidence.csv
# # source("_codes/scripts_santeqc/santeqc_regionRes/process_data_region.R")
# # source("_codes/scripts_santeqc/santeqc_regionRes/barchart_regionRes.R")
# # source("_codes/scripts_santeqc/santeqc_regionRes/evolution_regionRes_percent.R")
# # source("_codes/scripts_santeqc/santeqc_regionRes/make_flourish_region_percent.R")
# 
# ### <date>_RSS*.csv
# # *.R
# # source("_codes/scripts_inspq/evolution_region_percent.R")
# # source("_codes/scripts_inspq/make_flourish_region_percent.R")
# # source("_codes/scripts_inspq/region_percent_12p.R")
# # source("_codes/scripts_inspq/estimate_pop75_1dose_12p_perRegion.R")
# 
# ### <date>_doses_vaccin_regions.txt
# # map_qc.R
# # source("_codes/scripts/map_qc.R")
# # # bartchart_qc.R
# # source("_codes/scripts/barchart_qc.R")
# 
# # # evolution_regions.R
# # source("_codes/scripts/evolution_regions.R")
# # # barchart_race_evolution_regions.R
# # source("_codes/scripts/barchart_race_evolution_regions.R")
# 
# ### <data>_daily_vaccin_qc.txt
# # widget_qc.R
# # source("_codes/scripts/widget_qc.R")
# # widget_pop70.R
# # source("_codes/scripts/widget_pop70.R")
# # # evolution_qc.R
# # source("_codes/scripts/evolution_qc.R")
# # evolution_qc_perday.R
# # source("_codes/scripts/evolution_qc_perday_tmp.R")
# # widget_pop75.R
# # source("_codes/scripts/widget_pop75.R")
# # evolution_diff.R
# # source("_codes/scripts/evolution_diff.R")
# # evolution_pop70.R
# # source("_codes/scripts/evolution_pop70.R")
# # evolution_qc_pop75.R
# # source("_codes/scripts/evolution_qc_pop75.R")
# # widget_summer.R
# # source("_codes/scripts/widget_summer.R")
# 
# ### <date>_vaccin_perAge.csv
# # if (date_inspq == date) {
# #   # widget_qc_perAge.R
# #   source("_codes/scripts/widget_qc_perAge.R")
# #   # evolution_qc_perAge.R
# #   source("_codes/scripts/evolution_qc_perAge.R")
# #   # evolution_qc_perAge_perDay.R
# #   source("_codes/scripts/evolution_qc_perAge_perDay_mean.R")
# # }
# 
# ### <date>_vaccin_recu.txt
# # estimation_doses_qc.R
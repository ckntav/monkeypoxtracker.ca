rawData <- read_csv(file.path("_codes", "input", "rawData_csv", paste0(date_mkp, "_monkeypox-map.csv")),
                    show_col_types = FALSE)

df <- rawData %>% 
  dplyr::select(date, reporting_pt_en, num_confirmedcases_delta, num_confirmedcases_cumulative) %>%
  set_names("date", "province", "nb_cases_delta", "nb_cases_sum")

# df$province <- factor(df$province, levels = c("Canada",
#                                               "Alberta", "British Columbia", "New Brunswick",
#                                               "Ontario", "Quebec", "Saskachewan", "Yukon"))

saveRDS(df, file.path("_codes", "input", "rds", paste0(date_mkp, "_monkeypox_canada.rds")))

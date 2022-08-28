rawData <- read_csv(file.path("_codes", "input", "rawData_csv", paste0(date_mkp, "_monkeypox-map.csv")),
                    show_col_types = FALSE)

##### rds1
df <- rawData %>% 
  dplyr::select(date, reporting_pt_en, num_confirmedcases_delta, num_confirmedcases_cumulative) %>%
  set_names("date", "province", "nb_cases_delta", "nb_cases_sum")

# df$province <- factor(df$province, levels = c("Canada",
#                                               "Alberta", "British Columbia", "New Brunswick",
#                                               "Ontario", "Quebec", "Saskachewan", "Yukon"))

#
saveRDS(df, file.path("_codes", "input", "rds", paste0(date_mkp, "_monkeypox_canada.rds")))

##### rds2
mapping_province <- data.frame(
  code = c("BC", "NU", "NT", "AB", "NL", "SK", "MB", "QC", "ON", "NB", "NS", "PE", "YT"),
  province = c("British Columbia", "Nunavut", "Northwest Territories",
               "Alberta","Newfoundland and Labrador","Saskatchewan", "Manitoba",
               "Quebec", "Ontario", "New Brunswick", "Nova Scotia",              
               "Prince Edward Island", "Yukon"))

province_names <- df %>% dplyr::filter(province != "Canada") %>% pull(province) %>% unique %>% sort

df_latest_byProvince <- data.frame()
for (province_i in province_names) {
  df_province <- df %>% dplyr::filter(province == province_i) %>% 
    dplyr::filter(date == max(date)) %>% 
    dplyr::select(-nb_cases_delta) %>% 
    set_names("date", "province", "total_cases")
  
  df_latest_byProvince <- rbind(df_latest_byProvince, df_province)
}

province_zero <- mapping_province$province[!mapping_province$province %in% df_latest_byProvince$province]
for (p_zero in province_zero) {
  line <- data.frame(date = ymd(date_mkp),
                     province = p_zero,
                     total_cases = 0)
  df_latest_byProvince <- rbind(df_latest_byProvince, line)
}

df_latest_byProvince <- df_latest_byProvince %>% 
  left_join(mapping_province, bt = "province")

#
saveRDS(df_latest_byProvince, file.path("_codes", "input", "rds", paste0(date_mkp, "latest_monkeypox_canada.rds"))) 
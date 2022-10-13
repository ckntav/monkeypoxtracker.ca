#
df_latest_byProvince <- readRDS(file.path("_codes", "input", "rds", paste0(date_mkp, "latest_monkeypox_canada.rds")))

updated_province <- df_latest_byProvince %>%
  dplyr::filter(date == ymd(date_mkp), total_cases != 0) %>% 
  pull(province)

#
df <- readRDS(file.path("_codes", "input", "rds", paste0(date_mkp, "_monkeypox_canada.rds")))

#
df_var_tmp <- data.frame()
for (province_i in updated_province) {
  df_province <- df %>% dplyr::filter(province == province_i)
  date_list <- df_province$date %>% unique %>% sort(decreasing = TRUE)
  current_date <- date_list[1]
  previous_date <- date_list[2]
  
  total_cases_i_current_date <- df_province %>% dplyr::filter(date == current_date) %>% pull(nb_cases_sum)
  total_cases_i_previous_date <- df_province %>% dplyr::filter(date == previous_date) %>% pull(nb_cases_sum)
  var_total_cases_i <- total_cases_i_current_date - total_cases_i_previous_date
  
  if (length(var_total_cases_i) == 0) {
    var_total_cases_i <-  NA
  }
  
  line <- data.frame(province = province_i,
                     nb_var = var_total_cases_i,
                     since = previous_date)
  
  df_var_tmp <- rbind(df_var_tmp, line)
}

#
if (nrow(df_var_tmp != 0 & ncol(df_var_tmp) != 0)) {
  df_var <- df_latest_byProvince %>% 
    left_join(df_var_tmp, by = "province") %>% 
    dplyr::select(province, code, total_cases, nb_var, since) %>% 
    arrange(desc(nb_var), desc(total_cases)) %>% 
    mutate(nb_var = ifelse(is.na(nb_var), "", nb_var),
           since = ifelse(is.na(since), "", format(ymd(since), "%B %d, %Y"))) %>% 
    set_names("province", "code", "total confirmed cases", "variation", "since")
} else {
  df_var <- df_latest_byProvince %>%
    mutate(nb_var = NA, since = NA) %>% 
    mutate(nb_var = ifelse(is.na(nb_var), "", nb_var),
           since = ifelse(is.na(since), "", format(ymd(since), "%B %d, %Y"))) %>% 
    dplyr::select(province, code, total_cases, nb_var, since) %>%
    arrange(desc(nb_var), desc(total_cases)) %>% 
    set_names("province", "code", "total confirmed cases", "variation", "since")
}

library(formattable)

customGrey <- "#E8E8E8"
customGreen <- "#5F8575"
customRed <- "#800000"

improvement_formatter <- formatter("span", 
                                   style = x ~ style(font.weight = ifelse(x > 0, "bold", "normal"),
                                                     # font.size = ifelse(x > 0, "15px", "10px"),
                                                     # font.weight = "bold", 
                                                     color = ifelse(x > 0, customRed, "black")), 
                                   x ~ icontext(ifelse(x>0, "arrow-up", ""), x)
)

table_var <- 
formattable(df_var,
            align = c("r", "c", "c", "c", "c"),
            list(
              # `province` = formatter("span", style = ~ style(font.weight = "bold")),
              `total confirmed cases` = color_tile(customGrey, customGreen),
              `variation` = improvement_formatter
              )
            )


table_html <- format_table(table_var, align = c("r", "c", "c", "c", "c"))
file_html_mapca <- file.path("_includes", "table_variation_mkpt_byProvince.html")
fileConn_mapca <- file(file_html_mapca)
writeLines(table_html, fileConn_mapca)
close(fileConn_mapca)


#
htmlwidgets::saveWidget(widget = as.htmlwidget(table_var), file = "_pics/tmp_html/var_nb_cases_byProvince.html")
webshot::webshot(url = "_pics/tmp_html/var_nb_cases_byProvince.html", 
                 file = file.path("_pics", "var_nb_cases_byProvince", paste0(date_mkp, "_var_nb_cases_byProvince.png")),
                 vwidth = 750, vheight = 500,
                 delay = 3)
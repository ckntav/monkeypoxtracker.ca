#
df <- readRDS(file.path("_codes", "input", "rds", paste0(date_mkp, "_monkeypox_canada.rds")))
date_min <- min(df$date)
date_max <- max(df$date)

#
date_subtitle <- paste("As of" ,format(ymd(date_mkp), "%B %d, %Y"))

#
province_list <- df$province %>% unique
# province_list <- "British Columbia"

#
bigdf_7days <- data.frame()
for (province_i in province_list) {
  message("# ", province_i)
  
  df_province <- df %>% dplyr::filter(province == province_i)
  
  d_list <- df_province$date
  message(" > Number of date with data : ", length(d_list))
  
  df_7days_province <- data.frame()
  for (i in 1:length(d_list)) {
    date_i <- d_list[i]
    date_im7 <- date_i - ddays(7)
    
    # message(date_i, " ", date_i_minus7)
    isInList <- date_im7 %in% d_list
    # message(" > ", isInList)
    
    if (isInList) {
      nbCases_i <- df_province %>% dplyr::filter(date == date_i) %>% pull(nb_cases_sum)
      nbCases_im7 <- df_province %>% dplyr::filter(date == date_im7) %>% pull(nb_cases_sum)
      diffCases <- nbCases_i - nbCases_im7
      # message(" #", date_i, " | ", diffCases, " | ", diffCases/7)
      
      
      line <- data.frame("date" = date_i,
                         "province" = province_i,
                         "diffCases" = diffCases,
                         "meanCases7days" = diffCases/7)
                         
      df_7days_province <- rbind(df_7days_province, line)
    }
  }
  message(" > Number of date with 7days average : ", nrow(df_7days_province))
  bigdf_7days <- rbind(bigdf_7days, df_7days_province)
}

# In Canada
evol_nb_cases_sum_Canada_7days <- 
bigdf_7days %>%
  dplyr::filter(province == "Canada") %>% 
  dplyr::filter(date != ymd("20221014")) %>% 
  hchart("spline", hcaes(x = date, y = meanCases7days, group = province, v = province),
         dataLabels = list(enabled = TRUE, format = "{point.y:.1f}")) %>% 
  hc_tooltip(# valueDecimals = 2,
    # pointFormat = "{point.v} <br> Doses administrées : {point.z} <br> {point.y} %",
    headerFormat = "<small>{point.key}</small><table>",
    # pointFormat = "<br>{point.v} : {point.y} % ({point.z})",
    pointFormat = paste0('<tr><td style="color: {series.color}\">&#11044;</td>',
                         '<td>{point.v}</td>',
                         # '<td style="text-align: right">{point.z}</td>',
                         '<td style="text-align: right">{point.y:.2f}</td></tr>'),
    footerFormat = "</table>",
    # xDateFormat = '%A %e %B %Y', borderColor = "#0C3D78",
    crosshairs = TRUE, table = TRUE, sort = TRUE) %>% 
  hc_plotOptions(spline = list(#lineWidth = 2,
    marker = list(radius = 1,
                  symbol = "circle"))) %>%
  hc_colors("#C32123") %>% 
  hc_yAxis(title = list(text = "")) %>%
  hc_xAxis(title = list(text = ""),
           min = datetime_to_timestamp(as.Date(ymd(date_min), tz = "UTC")),
           max = datetime_to_timestamp(as.Date(ymd(date_max), tz = "UTC"))) %>%
  hc_title(text = paste("Monkeypox - Daily confirmed cases in Canada"), align = "left") %>% 
  hc_subtitle(text = paste("7-day rolling average.", date_subtitle), align = "left") %>% 
  hc_credits(text = "@vaccintrackerqc | source: Public Health Agency of Canada", enabled = TRUE)

# By province
province_names <- df %>% dplyr::filter(province != "Canada") %>% pull(province) %>% unique %>% sort
nb_province <- province_names %>% length
cols_province <- wes_palette("Zissou1", nb_province, type = "continuous") %>% as.vector
names(cols_province) <- province_names

province_names_7days <- bigdf_7days %>% dplyr::filter(province != "Canada") %>% pull(province) %>% unique %>% sort
cols_province_7days <- cols_province[province_names_7days]
names(cols_province_7days) <- NULL

#
evol_nb_cases_sum_Canada_byProvince_7days <- 
bigdf_7days %>%
  dplyr::filter(province != "Canada") %>% 
  hchart("spline", hcaes(x = date, y = meanCases7days, group = province, v = province),
         dataLabels = list(enabled = TRUE, format = "{point.y:.1f}")) %>% 
  hc_tooltip(# valueDecimals = 2,
    # pointFormat = "{point.v} <br> Doses administrées : {point.z} <br> {point.y} %",
    headerFormat = "<small>{point.key}</small><table>",
    # pointFormat = "<br>{point.v} : {point.y} % ({point.z})",
    pointFormat = paste0('<tr><td style="color: {series.color}\">&#11044;</td>',
                         '<td>{point.v}</td>',
                         # '<td style="text-align: right">{point.z}</td>',
                         '<td style="text-align: right">{point.y:.2f}</td></tr>'),
    footerFormat = "</table>",
    # xDateFormat = '%A %e %B %Y', borderColor = "#0C3D78",
    crosshairs = TRUE, table = TRUE, sort = TRUE) %>% 
  hc_plotOptions(spline = list(#lineWidth = 2,
    marker = list(radius = 1,
                  symbol = "circle"))) %>%
  hc_colors(cols_province_7days) %>% 
  hc_yAxis(title = list(text = "")) %>%
  hc_xAxis(title = list(text = ""),
           min = datetime_to_timestamp(as.Date(ymd(date_min), tz = "UTC")),
           max = datetime_to_timestamp(as.Date(ymd(date_max), tz = "UTC"))) %>%
  hc_title(text = paste("Monkeypox - Daily confirmed cases in Canada by province"), align = "left") %>% 
  hc_subtitle(text = paste("7-day rolling average.", date_subtitle), align = "left") %>% 
  hc_credits(text = "@vaccintrackerqc | source: Public Health Agency of Canada", enabled = TRUE)

#
htmltools::save_html(evol_nb_cases_sum_Canada_7days, file = "_codes/tmp_html/evol_nb_cases_sum_Canada_7days_raw.html")
html_encsc <- read_html("_codes/tmp_html/evol_nb_cases_sum_Canada_7days_raw.html")
body_encsc <- html_encsc %>% html_nodes("body")
div_encsc <- body_encsc %>% html_nodes("div") %>% as.character
script_encsc <- body_encsc %>% html_nodes("script") %>% as.character
file_html_encsc <- file.path("_includes", "evol_nb_cases_sum_Canada_7days.html")
fileConn_encsc <- file(file_html_encsc)
writeLines(c(div_encsc, "\n", script_encsc), fileConn_encsc)
close(fileConn_encsc)

#
htmltools::save_html(evol_nb_cases_sum_Canada_byProvince_7days, file = "_codes/tmp_html/evol_nb_cases_sum_Canada_byProvince_7days_raw.html")
html_encscbp <- read_html("_codes/tmp_html/evol_nb_cases_sum_Canada_byProvince_7days_raw.html")
body_encscbp <- html_encscbp %>% html_nodes("body")
div_encscbp <- body_encscbp %>% html_nodes("div") %>% as.character
script_encscbp <- body_encscbp %>% html_nodes("script") %>% as.character
file_html_encscbp <- file.path("_includes", "evol_nb_cases_sum_Canada_byProvince_7days.html")
fileConn_encscbp <- file(file_html_encscbp)
writeLines(c(div_encscbp, "\n", script_encscbp), fileConn_encscbp)
close(fileConn_encscbp)
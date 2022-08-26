#
mapid_ca <- "countries/ca/ca-all"

# basics
# camap <- hcmap(mapid_ca)
# camap

# chloropleths
mapdata <- download_map_data(mapid_ca)
# names(mapdata)

mapdata_df <- get_data_from_map(mapdata)      
# glimpse(mapdata_df)      
colnames(mapdata_df)      
      
#
# data_fake <- mapdata_df %>% 
#   dplyr::select(code = `hc-a2`) %>% 
#   mutate(value = 1e5 * abs(rt(nrow(mapdata_df), df = 10)))
#       
# glimpse(data_fake)
# 
# #
# hcmap(
#   mapid_ca,
#   data = data_fake,
#   value = "value",
#   joinBy = c("hc-a2", "code"),
#   name = "Fake data",
#   dataLabels = list(enabled = TRUE, format = "{point.code}"),
#   borderColor = "#FAFAFA",
#   borderWidth = 0.1,
#   tooltip = list(
#     # valueDecimals = 2,
#     # valuePrefix = "$",
#     valueSuffix = " cases"
#   ))



# 
mapping_province <- data.frame(
  code = c("BC", "NU", "NT", "AB", "NL", "SK", "MB", "QC", "ON", "NB", "NS", "PE", "YT"),
  province = c("British Columbia", "Nunavut", "Northwest Territories",
               "Alberta","Newfoundland and Labrador","Saskatchewan", "Manitoba",
               "Quebec", "Ontario", "New Brunswick", "Nova Scotia",              
               "Prince Edward Island", "Yukon"))
# 
df <- readRDS(file.path("_codes", "input", "rds", paste0(date_mkp, "_monkeypox_canada.rds")))

date_subtitle <- paste("As of" ,format(ymd(date_mkp), "%B %d, %Y"))

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

#
data_map <- df_latest_byProvince %>%
  left_join(mapping_province, bt = "province") %>% 
  mutate(total_cases_chr = ifelse(total_cases > 0, as.character(total_cases), ""))

# colors
# n <- 5
# 
# stops <- data.frame(
#   q = 0:n/n,
#   c = c("#440154", "#414487", "#2A788E", "#22A884", "#7AD151", "#FDE725"),
#   stringsAsFactors = FALSE
# )
# 
# stops <- list_parse2(stops)


#
map_ca_mkpt <- 
hcmap(
  mapid_ca,
  data = data_map,
  value = "total_cases",
  joinBy = c("hc-a2", "code"),
  name = "Total confirmed cases",
  dataLabels = list(enabled = TRUE, format = "{point.code}<br>{point.total_cases_chr}"),
  borderColor = "#FAFAFA",
  borderWidth = 1,
  tooltip = list(
    # valueDecimals = 2,
    # valuePrefix = "$",
    valueSuffix = " cases"
  )) %>% 
  # hc_colorAxis(stops = stops) %>% 
  hc_colorAxis(minColor = "#E8E8E8", maxColor = "#5F8575") %>% 
  hc_subtitle(text = date_subtitle, align = "left") %>% 
  hc_credits(text = "@mktracker_ca", enabled = TRUE)

print(map_ca_mkpt)

#
htmltools::save_html(map_ca_mkpt, file = "_codes/tmp_html/map_ca_mkpt_raw.html")
html_mapca <- read_html("_codes/tmp_html/map_ca_mkpt_raw.html")
body_mapca <- html_mapca %>% html_nodes("body")
div_mapca <- body_mapca %>% html_nodes("div") %>% as.character
script_mapca <- body_mapca %>% html_nodes("script") %>% as.character
file_html_mapca <- file.path("_includes", "map_ca_mkpt.html")
fileConn_mapca <- file(file_html_mapca)
writeLines(c(div_mapca, "\n", script_mapca), fileConn_mapca)
close(fileConn_mapca)


# In Canada
# evol_nb_cases_sum_Canada <- 
# df %>% dplyr::filter(province == "Canada") %>% 
#   hchart("spline", hcaes(x = date, y = nb_cases_sum, group = province, v = province),
#          dataLabels = list(enabled = TRUE)) %>%
#   hc_tooltip(# valueDecimals = 2,
#     # pointFormat = "{point.v} <br> Doses administrées : {point.z} <br> {point.y} %",
#     headerFormat = "<small>{point.key}</small><table>",
#     # pointFormat = "<br>{point.v} : {point.y} % ({point.z})",
#     pointFormat = paste0('<tr><td style="color: {series.color}\">&#11044;</td>',
#                          '<td>{point.v}</td>',
#                          # '<td style="text-align: right">{point.z}</td>',
#                          '<td style="text-align: right">{point.y} cases</td></tr>'),
#     footerFormat = "</table>",
#     # xDateFormat = '%A %e %B %Y', borderColor = "#0C3D78",
#     crosshairs = TRUE, table = TRUE, sort = TRUE) %>%
#   hc_colors("#C32123") %>% 
#   hc_yAxis(title = list(text = "")) %>%
#   hc_xAxis(title = list(text = "")) %>%
#   hc_subtitle(text = paste(date_subtitle), align = "left") %>%
#   hc_plotOptions(spline = list(#lineWidth = 2,
#     marker = list(radius = 1,
#                   symbol = "circle"))) %>%
#   hc_title(text = paste("Monkeypox - Count of confirmed cases in Canada"), align = "left") %>%
#   hc_credits(text = "@vaccintrackerqc | source: Public Health Agency of Canada", enabled = TRUE)
# # hc_credits(text = "@vaccintrackerqc | source: https://health-infobase.canada.ca/monkeypox", enabled = TRUE)
# 
# # By province
# province_names <- df %>% dplyr::filter(province != "Canada") %>% pull(province) %>% unique %>% sort
# nb_province <- province_names %>% length
# cols_province <- wes_palette("Zissou1", nb_province, type = "continuous") %>% as.vector
# names(cols_province) <- province_names
# names(cols_province) <- NULL
# 
# 
# evol_nb_cases_sum_Canada_byProvince <- 
# df %>% dplyr::filter(province != "Canada") %>% 
#   hchart("spline", hcaes(x = date, y = nb_cases_sum, group = province, v = province),
#          dataLabels = list(enabled = TRUE)) %>%
#   hc_tooltip(# valueDecimals = 2,
#     # pointFormat = "{point.v} <br> Doses administrées : {point.z} <br> {point.y} %",
#     headerFormat = "<small>{point.key}</small><table>",
#     # pointFormat = "<br>{point.v} : {point.y} % ({point.z})",
#     pointFormat = paste0('<tr><td style="color: {series.color}\">&#11044;</td>',
#                          '<td>{point.v}</td>',
#                          # '<td style="text-align: right">{point.z}</td>',
#                          '<td style="text-align: right">{point.y} cases</td></tr>'),
#     footerFormat = "</table>",
#     # xDateFormat = '%A %e %B %Y', borderColor = "#0C3D78",
#     crosshairs = TRUE, table = TRUE, sort = TRUE) %>%
#   hc_colors(cols_province) %>% 
#   hc_yAxis(title = list(text = "")) %>%
#   hc_xAxis(title = list(text = "")) %>%
#   hc_subtitle(text = paste(date_subtitle), align = "left") %>%
#   hc_plotOptions(spline = list(#lineWidth = 2,
#     marker = list(radius = 1,
#                   symbol = "circle"))) %>%
#   hc_title(text = paste("Monkeypox - Count of confirmed cases in Canada by province"), align = "left") %>%
#   hc_credits(text = "@vaccintrackerqc | source: Public Health Agency of Canada", enabled = TRUE)
# # hc_credits(text = "@vaccintrackerqc | source: https://health-infobase.canada.ca/monkeypox", enabled = TRUE)
# 
# #
# htmltools::save_html(evol_nb_cases_sum_Canada, file = "_codes/tmp_html/evol_nb_cases_sum_Canada_raw.html")
# html_encsc <- read_html("_codes/tmp_html/evol_nb_cases_sum_Canada_raw.html")
# body_encsc <- html_encsc %>% html_nodes("body")
# div_encsc <- body_encsc %>% html_nodes("div") %>% as.character
# script_encsc <- body_encsc %>% html_nodes("script") %>% as.character
# file_html_encsc <- file.path("_includes", "evol_nb_cases_sum_Canada.html")
# fileConn_encsc <- file(file_html_encsc)
# writeLines(c(div_encsc, "\n", script_encsc), fileConn_encsc)
# close(fileConn_encsc)
# 
# #
# htmltools::save_html(evol_nb_cases_sum_Canada_byProvince, file = "_codes/tmp_html/evol_nb_cases_sum_Canada_byProvince_raw.html")
# html_encscbp <- read_html("_codes/tmp_html/evol_nb_cases_sum_Canada_byProvince_raw.html")
# body_encscbp <- html_encscbp %>% html_nodes("body")
# div_encscbp <- body_encscbp %>% html_nodes("div") %>% as.character
# script_encscbp <- body_encscbp %>% html_nodes("script") %>% as.character
# file_html_encscbp <- file.path("_includes", "evol_nb_cases_sum_Canada_byProvince.html")
# fileConn_encscbp <- file(file_html_encscbp)
# writeLines(c(div_encscbp, "\n", script_encscbp), fileConn_encscbp)
# close(fileConn_encscbp)
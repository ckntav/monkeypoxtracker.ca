#
mapid_ca <- "countries/ca/ca-all"
# camap <- hcmap(mapid_ca)
# camap
mapdata <- download_map_data(mapid_ca)
# names(mapdata)
mapdata_df <- get_data_from_map(mapdata)      
colnames(mapdata_df)      
 
# 
date_subtitle <- paste("As of", format(ymd(date_mkp), "%B %d, %Y"))

df_latest_byProvince <- readRDS(file.path("_codes", "input", "rds", paste0(date_mkp, "latest_monkeypox_canada.rds")))

#
data_map <- df_latest_byProvince %>%
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
  hc_credits(text = "", enabled = TRUE, mapText = "")

print(map_ca_mkpt)

#
map_ca_mkpt_web <- map_ca_mkpt %>% 
  hc_size(height = "625")

#
htmltools::save_html(map_ca_mkpt_web, file = "_codes/tmp_html/map_ca_mkpt_raw.html")
html_mapca <- read_html("_codes/tmp_html/map_ca_mkpt_raw.html")
body_mapca <- html_mapca %>% html_nodes("body")
div_mapca <- body_mapca %>% html_nodes("div") %>% as.character
script_mapca <- body_mapca %>% html_nodes("script") %>% as.character
file_html_mapca <- file.path("_includes", "map_ca_mkpt.html")
fileConn_mapca <- file(file_html_mapca)
writeLines(c(div_mapca, "\n", script_mapca), fileConn_mapca)
close(fileConn_mapca)

#
map_ca_mkpt_tweet <- map_ca_mkpt %>%
  hc_title(text = "Total count of confirmed cases of monkeypox in Canada (by province or territory)", align = "left") %>% 
  hc_subtitle(text = date_subtitle, align = "left") %>% 
  hc_credits(text = "MonkeypoxTracker.ca | @mkptracker_ca", enabled = TRUE, mapText = "")
  
#
htmlwidgets::saveWidget(widget = map_ca_mkpt_tweet, file = "_pics/tmp_html/map_ca_mkpt_tweet.html", selfcontained = FALSE)
webshot::webshot(url = "_pics/tmp_html/map_ca_mkpt_tweet.html", 
                 file = file.path("_pics", "canada_map_tweet", paste0(date_mkp, "_map_ca_mkpt_tweet.png")),
                 vwidth = 1000, vheight = 750,
                 delay = 3)

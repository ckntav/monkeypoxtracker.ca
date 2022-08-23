df <- readRDS(file.path("_codes", "input", "rds", paste0(date_mkp, "_monkeypox_canada.rds")))

date_subtitle <- paste("As of" ,format(ymd(date_mkp), "%B %d, %Y"))

# In Canada
evol_nb_cases_sum_Canada <- 
df %>% dplyr::filter(province == "Canada") %>% 
  hchart("spline", hcaes(x = date, y = nb_cases_sum, group = province, v = province),
         dataLabels = list(enabled = TRUE)) %>%
  hc_tooltip(# valueDecimals = 2,
    # pointFormat = "{point.v} <br> Doses administrées : {point.z} <br> {point.y} %",
    headerFormat = "<small>{point.key}</small><table>",
    # pointFormat = "<br>{point.v} : {point.y} % ({point.z})",
    pointFormat = paste0('<tr><td style="color: {series.color}\">&#11044;</td>',
                         '<td>{point.v}</td>',
                         # '<td style="text-align: right">{point.z}</td>',
                         '<td style="text-align: right">{point.y} cases</td></tr>'),
    footerFormat = "</table>",
    # xDateFormat = '%A %e %B %Y', borderColor = "#0C3D78",
    crosshairs = TRUE, table = TRUE, sort = TRUE) %>%
  hc_colors("#C32123") %>% 
  hc_yAxis(title = list(text = "")) %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_subtitle(text = paste(date_subtitle), align = "left") %>%
  hc_plotOptions(spline = list(#lineWidth = 2,
    marker = list(radius = 1,
                  symbol = "circle"))) %>%
  hc_title(text = paste("Monkeypox - Count of confirmed cases in Canada"), align = "left") %>%
  hc_credits(text = "@vaccintrackerqc | source: Public Health Agency of Canada", enabled = TRUE)
# hc_credits(text = "@vaccintrackerqc | source: https://health-infobase.canada.ca/monkeypox", enabled = TRUE)

# By province
province_names <- df %>% dplyr::filter(province != "Canada") %>% pull(province) %>% unique %>% sort
nb_province <- province_names %>% length
cols_province <- wes_palette("Zissou1", nb_province, type = "continuous") %>% as.vector
names(cols_province) <- province_names
names(cols_province) <- NULL


evol_nb_cases_sum_Canada_byProvince <- 
df %>% dplyr::filter(province != "Canada") %>% 
  hchart("spline", hcaes(x = date, y = nb_cases_sum, group = province, v = province),
         dataLabels = list(enabled = TRUE)) %>%
  hc_tooltip(# valueDecimals = 2,
    # pointFormat = "{point.v} <br> Doses administrées : {point.z} <br> {point.y} %",
    headerFormat = "<small>{point.key}</small><table>",
    # pointFormat = "<br>{point.v} : {point.y} % ({point.z})",
    pointFormat = paste0('<tr><td style="color: {series.color}\">&#11044;</td>',
                         '<td>{point.v}</td>',
                         # '<td style="text-align: right">{point.z}</td>',
                         '<td style="text-align: right">{point.y} cases</td></tr>'),
    footerFormat = "</table>",
    # xDateFormat = '%A %e %B %Y', borderColor = "#0C3D78",
    crosshairs = TRUE, table = TRUE, sort = TRUE) %>%
  hc_colors(cols_province) %>% 
  hc_yAxis(title = list(text = "")) %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_subtitle(text = paste(date_subtitle), align = "left") %>%
  hc_plotOptions(spline = list(#lineWidth = 2,
    marker = list(radius = 1,
                  symbol = "circle"))) %>%
  hc_title(text = paste("Monkeypox - Count of confirmed cases in Canada by province"), align = "left") %>%
  hc_credits(text = "@vaccintrackerqc | source: Public Health Agency of Canada", enabled = TRUE)
# hc_credits(text = "@vaccintrackerqc | source: https://health-infobase.canada.ca/monkeypox", enabled = TRUE)

#
htmltools::save_html(evol_nb_cases_sum_Canada, file = "_codes/tmp_html/evol_nb_cases_sum_Canada_raw.html")
html_encsc <- read_html("_codes/tmp_html/evol_nb_cases_sum_Canada_raw.html")
body_encsc <- html_encsc %>% html_nodes("body")
div_encsc <- body_encsc %>% html_nodes("div") %>% as.character
script_encsc <- body_encsc %>% html_nodes("script") %>% as.character
file_html_encsc <- file.path("_includes", "evol_nb_cases_sum_Canada.html")
fileConn_encsc <- file(file_html_encsc)
writeLines(c(div_encsc, "\n", script_encsc), fileConn_encsc)
close(fileConn_encsc)

#
htmltools::save_html(evol_nb_cases_sum_Canada_byProvince, file = "_codes/tmp_html/evol_nb_cases_sum_Canada_byProvince_raw.html")
html_encscbp <- read_html("_codes/tmp_html/evol_nb_cases_sum_Canada_byProvince_raw.html")
body_encscbp <- html_encscbp %>% html_nodes("body")
div_encscbp <- body_encscbp %>% html_nodes("div") %>% as.character
script_encscbp <- body_encscbp %>% html_nodes("script") %>% as.character
file_html_encscbp <- file.path("_includes", "evol_nb_cases_sum_Canada_byProvince.html")
fileConn_encscbp <- file(file_html_encscbp)
writeLines(c(div_encscbp, "\n", script_encscbp), fileConn_encscbp)
close(fileConn_encscbp)
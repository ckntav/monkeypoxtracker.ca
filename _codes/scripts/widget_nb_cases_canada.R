df_canada <- readRDS(file.path("_codes", "input", "rds", paste0(date_mkp, "_monkeypox_canada.rds"))) %>% 
  dplyr::filter(province == "Canada")

#
date_list <- df_canada$date %>% unique %>% sort(decreasing = TRUE)
current_date <- date_list[1]
previous_date <- date_list[2]

#
des_current_date <- paste("as of" ,format(ymd(current_date), "%B %d, %Y"))
des_previous_date <- paste("since " ,format(ymd(previous_date), "%B %d, %Y"))
  
#
total_cases_i_current_date <- df_canada %>% dplyr::filter(date == current_date) %>% pull(nb_cases_sum)
total_cases_i_previous_date <- df_canada %>% dplyr::filter(date == previous_date) %>% pull(nb_cases_sum)
var_total_cases_i_tmp <- total_cases_i_current_date - total_cases_i_previous_date
if (var_total_cases_i_tmp >= 0) {
  var_total_cases_i <- paste0("+", var_total_cases_i_tmp)
} else {
  var_total_cases_i <- var_total_cases_i_tmp
}

# widget canada
wdgt_ca_div1 <- "<div class=\"widgetca\"><div><span class=\"widget_val\">"
wdgt_ca_div2 <- "</span><span class=\"widget_des\">total confirmed cases in Canada</span><span class=\"widget_date\">"
wdgt_ca_div3 <- "</span></div><div><span class=\"widget_val\">"
wdgt_ca_div4 <- "</span><span class=\"widget_des\">new confirmed cases in Canada</span><span class=\"widget_date\">"
wdgt_ca_div5 <- "</span></div></div>"
wdgt_ca_html <- c(wdgt_ca_div1, total_cases_i_current_date, wdgt_ca_div2, des_current_date,
                  wdgt_ca_div3, var_total_cases_i, wdgt_ca_div4, des_previous_date, wdgt_ca_div5)

file_html <- file.path("_includes", "widget_nb_cases_canada.html")
fileConn <- file(file_html)
writeLines(c(wdgt_ca_html), fileConn)
close(fileConn)
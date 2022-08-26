#####
date_last_update <- format(ymd(date_mkp), "%B %d, %Y")

#####
file_html <- file.path("_includes", "date_last_update.html")
fileConn <- file(file_html)
writeLines(date_last_update, fileConn)
close(fileConn)

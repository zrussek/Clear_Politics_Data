rm(list=ls())
library(rvest)
library(data.table)

###################
# Scrape the data #
###################

# read in the website
clear_politics <- read_html("http://www.realclearpolitics.com/epolls/2016/president/us/2016_republican_presidential_nomination-3823.html#polls")

# scrape the full table, remove html formatting, convert to data.table
full_tab_html <- html_nodes(clear_politics, "#polling-data-full td")
full_tab <- gsub("<.*?>","",full_tab_html)
full_tab_dt <- data.table(matrix(data = full_tab, ncol = 16,byrow = TRUE))

# scrape colnames, remove html formatting, set as colnames
headers <-  gsub("<.*?>","",html_nodes(clear_politics, "#polling-data-full .header .spread , #polling-data-full .header .noCenter, #polling-data-full .date, #polling-data-full .diag span"))
colnames(full_tab_dt) <- gsub("[[:space:]]+$", "", headers)

# fix Poll and Spread
polls_html<- html_nodes(clear_politics, "#polling-data-full .normal_pollster_name")
full_tab_dt$Poll <-  c("RCPAverage",gsub("[[:space:]]","",gsub("<.*?>","",polls_html)))

full_tab_dt$Spread <- gsub("[[:space:]]","",full_tab_dt$Spread)

# replace "--" with NA
strTmp <- names(full_tab_dt)[3:15]
full_tab_dt[, (strTmp) := lapply(.SD, as.numeric), .SDcols = strTmp]

####################
# Analyze the data #
####################












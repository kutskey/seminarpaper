# Country Codes ----

library(rvest)
library(dplyr)

rm(list = ls())

# URL of the website
url <- "https://www.countrycode.org/"

# Read the HTML content from the website
webpage <- read_html(url)

# Extract the table
country_table <- webpage %>%
  html_node("table") %>%
  html_table(fill = TRUE)

# split variable ISO CODES into two variables
country_table <- country_table %>%
  separate("ISO CODES", into = c("ISO2", "ISO3"), sep = "/")

# remove blank space in ISO3
country_table$ISO3 <- gsub(" ", "", country_table$ISO3)

# Save the data to a rds file
write_rds(country_table, "data_prep/country_codes.rds")
# load packages
library(tidyverse)
library(openxlsx)

# clear workspace
rm(list = ls())

# prepare conflict data ----

# load GED data
ged_data <- read_rds("data_orig/ged241.rds")

# remove all rows that do not contain a value for latitude and longitude
ged_data <- ged_data %>% filter(!is.na(`latitude`), !is.na(`longitude`))

# convert latitude and longitude to numeric
ged_data$`longitude` <- as.numeric(ged_data$`longitude`)
ged_data$`latitude` <- as.numeric(ged_data$`latitude`)
class(ged_data$`longitude`)
class(ged_data$`latitude`)

# check if values for latitude and longitude are within valid ranges
ged_data %>% filter(latitude < -90 | latitude > 90)
ged_data %>% filter(longitude < -180 | longitude > 180)

# rename variable "longitude" to "long" and "latitude" to "lat"
colnames(ged_data)[colnames(ged_data) == "longitude"] <- "lon"
colnames(ged_data)[colnames(ged_data) == "latitude"] <- "lat"

# rename best to anzahl_tote
colnames(ged_data)[colnames(ged_data) == "best"] <- "anzahl_tote"
print(colnames(ged_data))

# add variable date that is a copy of date_start
ged_data$date <- as.Date(ged_data$date_start)

# filter for region "Africa"
ged_africa <- ged_data %>% filter(region == "Africa")

# save prepared data to data_prep folder
write_rds(ged_africa, "data_prep/konflikte.rds")

# prepare dam data ----

# load FAO data
fao_data <- read.xlsx("data_orig/Africa-dams_eng_dams.xlsx")

# replace variable name with first entry of each column
colnames(fao_data) <- fao_data[1,]

# remove first row
fao_data <- fao_data[-1,]

# remove all rows that do not contain a value for "Decimal degree longitude" and "Decimal degree latitude"
fao_data <- fao_data %>% filter(!is.na(`Decimal degree longitude`), !is.na(`Decimal degree latitude`))

# convert "Decimal degree longitude" and "Decimal degree latitude" to numeric
fao_data$`Decimal degree longitude` <- as.numeric(fao_data$`Decimal degree longitude`)
fao_data$`Decimal degree latitude` <- as.numeric(fao_data$`Decimal degree latitude`)
class(fao_data$`Decimal degree longitude`)
class(fao_data$`Decimal degree latitude`)

# rename "Decemal degree latitude" and "Decimal degree longitude" to "latitude" and "longitude"
colnames(fao_data)[colnames(fao_data) == "Decimal degree longitude"] <- "lon"
colnames(fao_data)[colnames(fao_data) == "Decimal degree latitude"] <- "lat"

# check if values for latitude and longitude are within valid ranges
fao_data %>% filter(lat < -90 | lat > 90)
fao_data %>% filter(lon < -180 | lon > 180)

# add variable date to fao_data containing the year of construction
fao_data$date <- as.Date(paste0(fao_data$`Completed /operational since`, "-01-01"))
head(fao_data$date)

# rename Dam height (m) to hoehe
colnames(fao_data)[colnames(fao_data) == "Dam height (m)"] <- "hoehe"
colnames(fao_data)

# rename Reservoir capacity (million m3) to wassermenge
colnames(fao_data)[colnames(fao_data) == "Reservoir capacity (million m3)"] <- "wassermenge"
colnames(fao_data)

# save prepared data to data_prep folder
write_rds(fao_data, "data_prep/staudaemme.rds")


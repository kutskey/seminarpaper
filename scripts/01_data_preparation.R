# load packages
library(tidyverse)
library(openxlsx)


# AQUASTAT - FAO's Global Information System on Water and Agriculture ----

# clear workspace
rm(list = ls())

# load FAO data
dams_africa <- read.xlsx("data_orig/Africa-dams_eng_dams.xlsx")
dams_middle_east <- read.xlsx("data_orig/Middle East-dams_eng.xlsx")
dams_europe <- read.xlsx("data_orig/Europe-dams_eng.xlsx")

# replace variable name with first entry of each column
colnames(dams_africa) <- dams_africa[1,]
colnames(dams_middle_east) <- dams_middle_east[1,]
colnames(dams_europe) <- dams_europe[1,]


# remove first row
dams_africa <- dams_africa[-1,]
dams_middle_east <- dams_middle_east[-1,]
dams_europe <- dams_europe[-1,]


#combine all datasets
fao_data <- rbind(dams_africa, dams_middle_east, dams_europe)
rm(dams_africa, dams_middle_east, dams_europe)


# add variable year to fao_data containing the year of construction
fao_data$year <- fao_data$'Completed /operational since'

# remove all NA values in year
fao_data <- fao_data[!is.na(fao_data$year),]

# remove all values smaller than 1997 and larger than 2009
fao_data <- fao_data[fao_data$year >= 1997 & fao_data$year <= 2009,]

# join tables fao_data and country_table by country
country_codes <- read_rds("data_prep/country_codes.rds")
fao_data <- left_join(fao_data, country_codes, by = c("Country" = "COUNTRY"))
rm(country_codes)

# create a new variable conutry_year combining country and year
fao_data$country_year <- paste(fao_data$Country, fao_data$year, sep = "_")

# remove NA values in ISO3
fao_data <- fao_data[!is.na(fao_data$ISO3),]

# create variable country_year combining ISO3 and year
fao_data$country_year <- paste(fao_data$ISO3, fao_data$year, sep = "_")

# change class to numeric
fao_data$year <- as.numeric(fao_data$year)

# save prepared data to data_prep folder
write_rds(fao_data, "data_prep/fao_data.rds")


# WARICC dataset ----

# clear workspace
rm(list = ls())

# load data
WARICC_data <- read.xlsx("data_orig/WARICC dataset v10.xlsx", sheet = 1)

# create a new variable country_year combining cname and year
WARICC_data$country_year <- paste(WARICC_data$cname, WARICC_data$year, sep = "_")

# remove NA values in country_year
WARICC_data <- WARICC_data[!is.na(WARICC_data$country_year),]


# save to data_prep folder
write_rds(WARICC_data, "data_prep/WARICC_data.rds")

stop()

# De Stefano et al. Dataset ----

# clear workspace
rm(list = ls())

# load data
Stefano_BCU <- read.xlsx("data_orig/StefanoEtAl49Replication.xlsx", sheet = 2)
Stefano_Treaty <- read.xlsx("data_orig/StefanoEtAl49Replication.xlsx", sheet = 3)
Stefano_RBO <- read.xlsx("data_orig/StefanoEtAl49Replication.xlsx", sheet = 4)
Stefano_Variability <- read.xlsx("data_orig/StefanoEtAl49Replication.xlsx", sheet = 5)


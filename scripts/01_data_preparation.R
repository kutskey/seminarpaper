# load packages
library(tidyverse)
library(openxlsx)

# clear workspace
rm(list = ls())

# AQUASTAT - FAO's Global Information System on Water and Agriculture ----

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

# add variable year to fao_data containing the year of construction
fao_data$year <- fao_data$'Completed /operational since'

# remove all NA values in year
fao_data <- fao_data[!is.na(fao_data$year),]


# create a new variable conutry_year combining country and year
fao_data$country_year <- paste(fao_data$Country, fao_data$year, sep = "_")

# rename Dam height (m) to height
colnames(fao_data)[colnames(fao_data) == "Dam height (m)"] <- "height"


# rename Reservoir capacity (million m3) to capacity
colnames(fao_data)[colnames(fao_data) == "Reservoir capacity (million m3)"] <- "capacity"


# filter out all dams with a minimum capacity of X and a minimum height of Y


# save prepared data to data_prep folder
write_rds(fao_data, "data_prep/fao_data.rds")


# WARICC dataset ----

# load data
WARICC_data <- read.xlsx("data_orig/WARICC dataset v10.xlsx", sheet = 1)

# save to data_prep folder
write_rds(WARICC_data, "data_prep/WARICC_data.rds")

# De Stefano et al. Dataset ----

# load data
Stefano_BCU <- read.xlsx("data_orig/StefanoEtAl49Replication.xlsx", sheet = 2)
Stefano_Treaty <- read.xlsx("data_orig/StefanoEtAl49Replication.xlsx", sheet = 3)
Stefano_RBO <- read.xlsx("data_orig/StefanoEtAl49Replication.xlsx", sheet = 4)
Stefano_Variability <- read.xlsx("data_orig/StefanoEtAl49Replication.xlsx", sheet = 5)

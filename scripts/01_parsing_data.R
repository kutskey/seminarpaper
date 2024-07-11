# load packages
library(tidyverse)
library(openxlsx)

# clear workspace
rm(list = ls())

# preprocess conflict data ----

# load GED data
ged_data <- read_rds("data_orig/ged241.rds")

# parse
glimpse(ged_data)

# preprocess dam data ----

# load FAO data
fao_data <- read.xlsx("data_orig/Africa-dams_eng_dams.xlsx")

# parse
glimpse(fao_data)

# replace variable name with first entry of each column
colnames(fao_data) <- fao_data[1,]

# remove first row
fao_data <- fao_data[-1,]

# print variable names
colnames(fao_data)

# remove all rows that do not contain a value for "Decimal degree longitude" and "Decimal degree latitude"
fao_data <- fao_data %>% filter(!is.na(`Decimal degree longitude`), !is.na(`Decimal degree latitude`))

# count number of rows
nrow(fao_data)

# convert "Decimal degree longitude" and "Decimal degree latitude" to numeric
fao_data$`Decimal degree longitude` <- as.numeric(fao_data$`Decimal degree longitude`)
fao_data$`Decimal degree latitude` <- as.numeric(fao_data$`Decimal degree latitude`)

# print class of Decimal degree longitude and Decimal degree latitude
class(fao_data$`Decimal degree longitude`)
class(fao_data$`Decimal degree latitude`)

# rename "Decemal degree latitude" and "Decimal degree longitude" to "latitude" and "longitude"
colnames(fao_data)[colnames(fao_data) == "Decimal degree longitude"] <- "longitude"
colnames(fao_data)[colnames(fao_data) == "Decimal degree latitude"] <- "latitude"

# print variable names
colnames(fao_data)

# parse
glimpse(fao_data)

# print out number of different Major basins
length(unique(fao_data$`Major basin`))

# rename Hydroelectricity (MW) to Hydroelectricity_MW
colnames(fao_data)[colnames(fao_data) == "Hydroelectricity (MW)"] <- "Hydroelectricity_MW"

# print out how many times Hydroelectricity is x
sum(fao_data$Hydroelectricity_MW == "x", na.rm = TRUE)

# remove all rows that do not contain a value for "Hydroelectricity_MW"
fao_data <- fao_data %>% filter(!is.na(Hydroelectricity_MW))

# save preprocessed data to data_prep folder
write_rds(fao_data, "data_prep/fao_data.rds")
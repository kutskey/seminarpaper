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

# save raw data
write_rds(fao_data, "data_prep/fao_data_raw.rds")

# add variable year to fao_data containing the year of construction
fao_data$year <- fao_data$'Completed /operational since'

# remove all NA values in year
fao_data <- fao_data[!is.na(fao_data$year),]

# remove all values smaller than 1997 and larger than 2009
fao_data <- fao_data[fao_data$year >= 1997 & fao_data$year <= 2009,]

# change class to numeric
fao_data$year <- as.numeric(fao_data$year)

# create variable country with ISO code
fao_data$country <- fao_data$'ISO alpha- 3'

# create a new dummy variable dam with 1 for each observation
fao_data$dam <- 1

# create a new dummy variable country_year combining country and year
fao_data$country_year <- paste(fao_data$country, fao_data$year, sep = "_")

# manipulate the dam data so that the dam impacts the following year
# add one year to the year variable
fao_data <- fao_data %>%
  mutate(year = year + 1)

# save prepared data to data_prep folder
write_rds(fao_data, "data_prep/fao_data.rds")


# WARICC dataset ----

# clear workspace
rm(list = ls())

# load data
WARICC_data <- read.xlsx("data_orig/WARICC dataset v10.xlsx", sheet = 1)

# create variable country with cname
WARICC_data$country <- WARICC_data$cname

# create a table that shows which countries were represented in the dataset
countries <- WARICC_data %>%
  count(country)

# save the table as html
write.xlsx(countries, "output/countries_in_dataset.xlsx")


# create a new variable country_year combining cname and year
WARICC_data$country_year <- paste(WARICC_data$cname, WARICC_data$year, sep = "_")



## instead of calculating a mean for each country and year
## we split the wes variable into wes_positive for positive values and wes_negative for negative values
## then we calculate the mean for both values

# split wes
WARICC_data <- WARICC_data %>%
  mutate(wes_positive = ifelse(wes > 0, wes, 0),
         wes_negative = ifelse(wes < 0, wes, 0))

# group by country_year and calculate the mean of wes_positive and wes_negative
WARICC_data <- WARICC_data %>%
  group_by(country_year) %>%
  summarise(wes_positive = mean(wes_positive, na.rm = TRUE),
            wes_negative = mean(wes_negative, na.rm = TRUE))

# rename wes_positive to cooperation and wes_negative to conflict
WARICC_data <- WARICC_data %>%
  rename(cooperation = wes_positive,
         conflict = wes_negative)

# create two variables country and year from country_year
WARICC_data$country <- substr(WARICC_data$country_year, 1, 3)
WARICC_data$year <- as.numeric(substr(WARICC_data$country_year, 5, 8))

#### make sure that each country has observations from 1997 to 2009

# Create a complete dataset with all country-year combinations
all_countries <- unique(WARICC_data$country)
all_years <- 1997:2009

# Create a dataframe with all combinations of countries and years
complete_data <- expand.grid(country = all_countries, year = all_years)

# Merge the complete data with the original data
WARICC_data <- complete_data %>%
  left_join(WARICC_data, by = c("country", "year"))

# Replace missing conflict values with 0
WARICC_data <- WARICC_data %>%
  mutate(conflict = ifelse(is.na(conflict), 0, conflict),
         cooperation = ifelse(is.na(cooperation), 0, cooperation))

# create a new variable country_year combining cname and year
WARICC_data$country_year <- paste(WARICC_data$country, WARICC_data$year, sep = "_")

# save this dataset to data_prep
write_rds(WARICC_data, "data_prep/WARICC_data.rds")


# Stefano et al Replica ----

# clear workspace
rm(list = ls())

# load data
stefano_data_BCU <- read.xlsx("data_orig/StefanoEtAl49Replication.xlsx", sheet = 2)
stefano_data_treaty <- read.xlsx("data_orig/StefanoEtAl49Replication.xlsx", sheet = 3)
stefano_data_rbo <- read.xlsx("data_orig/StefanoEtAl49Replication.xlsx", sheet = 4)
stefano_data_variability <- read.xlsx("data_orig/StefanoEtAl49Replication.xlsx", sheet = 5)


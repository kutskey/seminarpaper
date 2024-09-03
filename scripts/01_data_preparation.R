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

# save this dataset to data_prep
write_rds(WARICC_data, "data_prep/WARICC_data.rds")

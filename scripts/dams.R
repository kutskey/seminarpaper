#load libraries
library(tidyverse)

#clear workspace
rm(list = ls())

#load AQUASTAT dataset
dams_africa <- read.xlsx("data_orig/Africa-dams_eng_dams.xlsx")
dams_middle_east <- read.xlsx("data_orig/Middle East-dams_eng.xlsx")
dams_central_asia <- read.xlsx("data_orig/C. Asia-dams_eng.xlsx")
dams_SE_asia <- read.xlsx("data_orig/SE Asia-dams_eng.xlsx")
dams_europe <- read.xlsx("data_orig/Europe-dams_eng.xlsx")
dams_oceania <- read.xlsx("data_orig/Oceania-dams_eng.xlsx")
dams_northamerica <- read.xlsx("data_orig/N. America-dams_eng.xlsx")
dams_centralamerica <- read.xlsx("data_orig/C. America and Car-dams_eng.xlsx")
dams_southamerica <- read.xlsx("data_orig/S. America-dams_eng.xlsx")

# replace variable name with first entry of each column
colnames(dams_africa) <- dams_africa[1,]
colnames(dams_middle_east) <- dams_middle_east[1,]
colnames(dams_central_asia) <- dams_central_asia[1,]
colnames(dams_SE_asia) <- dams_SE_asia[1,]
colnames(dams_europe) <- dams_europe[1,]
colnames(dams_oceania) <- dams_oceania[1,]
colnames(dams_northamerica) <- dams_northamerica[1,]
colnames(dams_centralamerica) <- dams_centralamerica[1,]
colnames(dams_southamerica) <- dams_southamerica[1,]


# remove first row
dams_africa <- dams_africa[-1,]
dams_middle_east <- dams_middle_east[-1,]
dams_central_asia <- dams_central_asia[-1,]
dams_SE_asia <- dams_SE_asia[-1,]
dams_europe <- dams_europe[-1,]
dams_oceania <- dams_oceania[-1,]
dams_northamerica <- dams_northamerica[-1,]
dams_centralamerica <- dams_centralamerica[-1,]
dams_southamerica <- dams_southamerica[-1,]

#combine all datasets
dams <- rbind(dams_africa, dams_middle_east, dams_central_asia, dams_SE_asia, dams_europe, dams_oceania, dams_northamerica, dams_centralamerica, dams_southamerica)

#save dataframe dams to data_prep folder
write_rds(dams, "data_prep/dams.rds")

# load packages
library(tidyverse)
library(openxlsx)

# load GED data
ged_data <- read_rds("data_orig/ged241.rds")

# load FAO data
fao_data <- read.xlsx("data_orig/Africa-dams_eng_dams.xlsx")
# load packages
library(tidyverse)

# clear workspace
rm(list = ls())

# load data
fao_data <- read_rds("data_prep/fao_data.rds")
WARICC_data <- read_rds("data_prep/WARICC_data.rds")
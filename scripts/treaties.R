# packages
library(openxlsx)
library(dplyr)

# clear the workspace
rm(list=ls())

# read in the data
treaties <- read.xlsx("data_orig/MasterTreatiesDB_20230213.xlsx")

# create a list of all the column names
variables <- colnames(treaties)
variables <- as.data.frame(variables)

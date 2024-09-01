#clear workspace
rm(list = ls())

#load data
dams <- read_rds("data_prep/dams.rds")
treaties <- read_rds("data_prep/treaties.rds")

#rename variable treaties$Country Name to Country
colnames(treaties)[colnames(treaties) == "Country_Name"] <- "Country"

#join tables dams and treaties by country
dams_treaties <- left_join(dams, treaties, by = c("Country" = "Country"))


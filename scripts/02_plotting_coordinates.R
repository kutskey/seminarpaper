# plot the locations of the dams and conflict events on a map

#load packages
install.packages("ggplot2")
install.packages("ggmap")
install.packages("dplyr")

library(ggplot2)
library(ggmap)
library(dplyr)

#create dataframe of fao_data only with the columns name, latitude and longitude
dam_locations <- fao_data %>% select("X2", "X24", "X25")

#remove first row of dam_locations
dam_locations <- dam_locations[-1,]

#rename columns of dam_locations
colnames(dam_locations) <- c("name", "latitude", "longitude")
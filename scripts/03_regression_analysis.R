# load packages
library(dplyr)
library(openxlsx)
library(lubridate)
library(sf)
library(geosphere)

# clear workspace
rm(list = ls())

#load data
ged <- read_rds("data_prep/ged_africa.rds")
fao <- read_rds("data_prep/fao_data.rds")

# filter events in 50km radius around dams ----

# Assuming ged and fao dataframes have columns `longitude` and `latitude`
ged_sf <- st_as_sf(ged, coords = c("longitude", "latitude"), crs = 4326)
fao_sf <- st_as_sf(fao, coords = c("longitude", "latitude"), crs = 4326)

# 50km buffer around fao points
fao_buffer <- st_buffer(fao_sf, dist = 50000)

# Transform coordinates to a projection suitable for distance calculations
fao_buffer_proj <- st_transform(fao_buffer, crs = 3857) # Web Mercator projection
ged_sf_proj <- st_transform(ged_sf, crs = 3857)

# Filter ged events within 50km of any fao location
ged_filtered <- st_join(ged_sf_proj, fao_buffer_proj, join = st_intersects)
ged_filtered <- ged_filtered[!is.na(ged_filtered$geometry), ]

# Transform back to the original coordinate system if necessary
ged_filtered <- st_transform(ged_filtered, crs = 4326)

# transform back to dataframe
ged_filtered_df <- as.data.frame(ged_filtered)

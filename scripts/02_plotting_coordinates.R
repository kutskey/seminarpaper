## plot the locations of the dams and conflict events on a map

#clear environment
rm(list=ls())

# Lade notwendige Pakete
library(tidyverse)
library(sf)
library(tmap)
library(leaflet)

# Lade fao_data.rds in R
fao_data <- read_rds("data_prep/fao_data.rds")
ged_africa <- read_rds("data_prep/ged_africa.rds")

# Erstelle die Karte mit sf und tmap ----

# konvertiere in sf objekt

fao_sf <- st_as_sf(fao_data, coords = c("longitude", "latitude"), crs = 4326)
ged_sf <- st_as_sf(ged_africa, coords = c("longitude", "latitude"), crs = 4326)

# Switch tmap mode to "view" for interactive maps
tmap_mode("view")

# erstelle die Karte
map <- tm_basemap("OpenStreetMap") +
  tm_shape(fao_sf) + 
  tm_dots(col = "red", size = 0.1) +
  tm_shape(ged_sf) + 
  tm_dots(col = "blue", size = 0.1)

# save map as html
tmap_save(map, "plots/map.html")

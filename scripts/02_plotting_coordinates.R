## plot the locations of the dams and conflict events on a map

#clear environment
rm(list=ls())

# Lade notwendige Pakete
library(tidyverse)
library(sf)
library(tmap)

# Lade fao_data.rds in R
fao_data <- read_rds("data_prep/fao_data.rds")

# Erstelle die Karte mit sf und tmap ----

# konvertiere in sf objekt

data_sf <- st_as_sf(fao_data, coords = c("longitude", "latitude"), crs = 4326)

# erstelle die Karte
tm <- tm_shape(data_sf) +
  tm_dots(size = 0.1, col = "red") +
  tm_basemap("OpenStreetMap")

# speichere die Karte als html
tmap_save(tm, filename = "plots/map_of_dams.html")

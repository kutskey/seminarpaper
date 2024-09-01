library(tmap)
library(sf)

rm(list = ls())

# Lade fao_data.rds in R
fao_data <- read_rds("data_prep/fao_data.rds")


# Erstelle die Karte mit sf und tmap ----

# konvertiere in sf objekt

#remove na values for Decimal degree longitude and Decimal degree latitude
fao_data <- fao_data[!is.na(fao_data$'Decimal degree longitude'),]

fao_sf <- st_as_sf(fao_data, coords = c("Decimal degree longitude", "Decimal degree latitude"), crs = 4326)


# Switch tmap mode to "view" for interactive maps
tmap_mode("view")

# erstelle die Karte
map <- tm_basemap("OpenStreetMap") +
  tm_shape(fao_sf) + 
  tm_dots(col = "red", size = 0.1)

# save map as html
tmap_save(map, "output/map.html")

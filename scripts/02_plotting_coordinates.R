## plot the locations of the dams and conflict events on a map

# dataframe vorbereiten ----
#clear environment
rm(list=ls())

# Lade notwendige Pakete
library(tidyverse)
library(openxlsx)

# Lade FAO-Daten
fao_data <- read.xlsx("data_orig/Africa-dams_eng_dams.xlsx")

# Überprüfe die Struktur der geladenen Daten
str(fao_data)

# Erstelle DataFrame von fao_data nur mit den Spalten name, latitude und longitude
# Stelle sicher, dass die Spaltennamen korrekt sind
dam_locations <- fao_data %>% select(X2, X24, X25)

# Entferne die erste Zeile von dam_locations (falls diese keine Datensätze enthält)
dam_locations <- dam_locations[-1,]

# Überprüfe die Struktur der Daten vor der Umbenennung
str(dam_locations)

# Benenne die Spalten von dam_locations um
colnames(dam_locations) <- c("name", "latitude", "longitude")

# Überprüfe die Struktur der Daten nach der Umbenennung
str(dam_locations)

# Wandle latitude und longitude von Zeichenketten in numerische Werte um
dam_locations$latitude <- as.numeric(dam_locations$latitude)
dam_locations$longitude <- as.numeric(dam_locations$longitude)

# Entferne Zeilen mit fehlenden Werten
dam_locations <- na.omit(dam_locations)

# Überprüfe die Struktur der bereinigten Daten
str(dam_locations)

# Erstelle die Karte mit sf und tmap ----

# lade packages

library(sf)
library(tmap)

# konvertiere in sf objekt

data_sf <- st_as_sf(dam_locations, coords = c("longitude", "latitude"), crs = 4326)

# erstelle die Karte
tm <- tm_shape(data_sf) +
  tm_dots(size = 0.1, col = "red") +
  tm_basemap("OpenStreetMap")

# speichere die Karte als html
tmap_save(tm, filename = "plots/map_of_dams.html")

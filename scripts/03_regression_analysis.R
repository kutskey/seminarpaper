# load packages
library(dplyr)
library(sf)
library(sp)
library(lubridate)
library(tidyr)

# clear workspace
rm(list = ls())

#load data
violence_events <- read_rds("data_prep/ged_africa.rds")
dams <- read_rds("data_prep/fao_hydroelectricity.rds")

# Convert dams dataframe to spatial points
dams_sf <- st_as_sf(dams, coords = c("longitude", "latitude"), crs = 4326)

# Convert violence_events dataframe to spatial points
violence_sf <- st_as_sf(violence_events, coords = c("longitude", "latitude"), crs = 4326)

# Create buffers around dams
dams_buffer <- st_buffer(dams_sf, dist = 100000)  # dist in meters (100 km)

# Step 5

# Convert date columns to Date objects
dams_sf$date <- as.Date(dams_sf$date)
violence_sf$date <- as.Date(violence_sf$date)

stop()
# Join violence events with dam information to get the construction dates
violence_events_dams <- st_join(violence_sf, dams_sf, join = st_intersects) # not working

# Filter out events that happened before the dam was built
violence_events_dams <- violence_events_dams %>%
  filter(date.y > date.x)  # date.y is the event date, date.x is the dam construction date
  
# Step 6

# Create a binary variable indicating the presence of a dam within 100km
violence_sf$near_dam <- ifelse(st_within(violence_sf, dams_buffer, sparse = FALSE), 1, 0)

# Step 7

# Prepare the dataset for regression analysis
violence_events_final <- violence_sf %>%
  mutate(event = 1) %>%
  select(date, near_dam, event)

# step 8

# Perform logistic regression
model <- glm(event ~ near_dam, data = violence_events_final, family = binomial)
summary(model)

# Step 9

# Interpret the results
summary(model)

# Optional

## Plot dams and violence events
plot(st_geometry(dams_sf), col = "blue", pch = 19, cex = 1.5, main = "Dams and Political Violence Events")
plot(st_geometry(violence_sf), col = ifelse(violence_sf$near_dam == 1, "red", "black"), add = TRUE)


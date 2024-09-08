# load packages
library(tidyverse)
library(stargazer)
library(tmap)
library(sf)
library(ggplot2)
library(plm)

# clear workspace
rm(list = ls())


#create a table with the following structure ----
# country_year | country | year | dam | cooperation | conflict

# load prepared dam data
fao_data <- read_rds("data_prep/fao_data.rds")

# load water events data
WARICC_data <- read_rds("data_prep/WARICC_data.rds")

# left join the dam data by country_year but include only the columns country, year and dam
data <- left_join(WARICC_data, fao_data %>% select(country_year, country, year, dam), by = "country_year")



# remove duplicates by variable country_year
data <- data %>% distinct(country_year, .keep_all = TRUE)


# if dam is NA then set dam to 0
data$dam[is.na(data$dam)] <- 0

# count values for dam
data %>%
  count(dam)

# drop country.y and year.y
data <- data %>% select(-country.y, -year.y)

# rename country.x and year.x to country and year
data <- data %>% rename(country = country.x, year = year.x)

# print out some info about the data -----------


# count dams in the dataset
dams_count <- data %>%
  count(dam)

data_dams <- data %>%
  filter(dam == 1)

# minimum height of dams in fao_data
min_height <- min(fao_data$'Dam height (m)')

# number of dams in turkey
dams_turkey <- fao_data %>%
  filter(country == "TUR") %>%
  count(dam)

# create a map of geolocated dams----

# load data
fao_data <- read_rds("data_prep/fao_data.rds")

# remove na values for latitude and longitude
fao_data <- fao_data[!is.na(fao_data$'Decimal degree longitude'),]
fao_data <- fao_data[!is.na(fao_data$'Decimal degree latitude'),]


# create sf object
fao_sf <- st_as_sf(fao_data, coords = c("Decimal degree longitude", "Decimal degree latitude"), crs = 4326)


# Switch tmap mode to "view" for interactive maps
tmap_mode("view")

# erstelle die Karte
map <- tm_basemap("OpenStreetMap") +
  tm_shape(fao_sf) + 
  tm_dots(col = "red", size = 0.1)

# save map as html
tmap_save(map, "output/map.html")

# count dams in turkey
fao_data %>%
  filter(country == "TUR") %>%
  count()

# count the number of countries in data
countries <- data %>%
  count(country)


# plot the data ----------


# plot the data, use x=dam and y=cooperation
ggplot(data, aes(x = dam, y = cooperation)) +
  geom_point() +
  #make the points bigger if there are more than 1 point
  geom_jitter(width = 0.05, height = 0.05) +
  labs(title = "Dam and Cooperation",
       x = "Dam",
       y = "Cooperation") +
  theme_minimal()

# save the plot as jpg
ggsave("output/plot_cooperation.jpg")


# plot the data, use x=dam and y=conflict

ggplot(data, aes(x = dam, y = conflict)) +
  geom_point() +
  #make the points bigger if there are more than 1 point
  geom_jitter(width = 0.05, height = 0.05) +
  labs(title = "Dam and Conflict",
       x = "Dam",
       y = "Conflict") +
  theme_minimal()
  

# save the plot as jpg
ggsave("output/plot_conflict.jpg")

# run regression model -------



# run regression model with dam as independent variable and cooperation/conflict as dependent variable
# control for year with fixed effects

model_cooperation <- plm(cooperation ~ dam, data = data, index = c("country", "year"), 
                         model = "within")
model_conflict <- plm(conflict ~ dam, data = data, index = c("country", "year"), 
                      model = "within")

# HTML output
stargazer(model_cooperation, type = "html", title = "Regression Results", 
          out = "output/regression_table_cooperation.html")
stargazer(model_conflict, type = "html", title = "Regression Results", 
          out = "output/regression_table_conflict.html")













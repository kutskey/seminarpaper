# load packages
library(tidyverse)
library(stargazer)

# clear workspace
rm(list = ls())

# load data
fao_data <- read_rds("data_prep/fao_data.rds")
WARICC_data <- read_rds("data_prep/WARICC_data.rds")




########### in this section i will triplicate the rows to have 3 years for each dam #########

# Create the additional rows
df_additional <- fao_data %>%
  mutate(year = year + 1)
df_additional <- df_additional %>%
  mutate(country_year = paste(ISO_alpha_3, year, sep = "_"))

# Create the additional rows
df_additional2 <- fao_data %>%
  mutate(year = year + 2)
df_additional2 <- df_additional2 %>%
  mutate(country_year = paste(ISO_alpha_3, year, sep = "_"))

# Combine the original DataFrame with the new one
df_combined <- bind_rows(fao_data, df_additional, df_additional2)

# sort df_combined by Name of the Dam
df_combined <- df_combined[order(df_combined$'Name of dam'),]


########### in this section i will join the data #############


join_data <- left_join(WARICC_data, df_combined, by = "country_year")

# delete dublicates by country_year
join_data <- join_data[!duplicated(join_data$country_year),]

# create a new binary variable dam, if Name of dam is NA then value is FALSE, else is TRUE
join_data$dam <- !is.na(join_data$'Name of dam')


######## finally run regression model ########

# change TRUE to 1 and FALSE to 0
join_data$dam <- as.numeric(join_data$dam)


# dependent variable is "wes" and independent variable is "dam"

model <- lm(wes ~ dam, data = join_data)

# print out regression table
summary(model)



# HTML output
stargazer(model, type = "html", title = "Regression Results", out = "output/regression_table.html")




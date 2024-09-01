fao_data <- read_rds("data_prep/fao_data.rds")

turkey_dams <- fao_data %>% 
  filter(Country == "Turkey")

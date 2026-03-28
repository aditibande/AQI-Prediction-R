library(readxl)
library(tidyverse)

data <- read_excel("data/MP_AQI_CLEAN_FINAL.xlsx")

data_long <- data %>%
  pivot_longer(cols = -District,
               names_to = "Year",
               values_to = "AQI")

data_long$Year <- as.numeric(substr(data_long$Year,1,4))

predict_2027 <- data_long %>%
  group_by(District) %>%
  summarise(model = list(lm(AQI ~ Year))) %>%
  mutate(AQI_2027 = map_dbl(model,
         ~ predict(.x, newdata = data.frame(Year = 2027))))

print(predict_2027)

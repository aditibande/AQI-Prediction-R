library(ggplot2)
library(dplyr)

overall_trend <- data_long %>%
  group_by(Year) %>%
  summarise(Avg_AQI = mean(AQI, na.rm = TRUE))

ggplot(overall_trend, aes(x = Year, y = Avg_AQI)) +
  geom_line() +
  geom_point()

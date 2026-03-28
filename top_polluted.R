top_2027 <- predict_2027 %>%
  arrange(desc(AQI_2027)) %>%
  head(10)

print(top_2027)

library(shiny)
library(ggplot2)
library(dplyr)
library(readxl)

# Load data
data <- read_excel("MP_AQI_CLEAN_FINAL.xlsx")

# Convert to long format
data_long <- data %>%
  tidyr::pivot_longer(cols = -District,
                      names_to = "Year",
                      values_to = "AQI")

data_long$Year <- as.numeric(substr(data_long$Year,1,4))

# UI
ui <- fluidPage(
  titlePanel("AQI Prediction Dashboard"),
  
  selectInput("district", "Select District:",
              choices = unique(data_long$District)),
  
  textOutput("prediction"),
  
  plotOutput("trendPlot")
)

# Server
server <- function(input, output) {
  
  selected_data <- reactive({
    data_long %>% filter(District == input$district)
  })
  
  # Prediction model
  output$prediction <- renderText({
    df <- selected_data()
    
    model <- lm(AQI ~ Year, data = df)
    pred <- predict(model, newdata = data.frame(Year = 2027))
    
    paste("Predicted AQI for 2027:", round(pred, 2))
  })
  
  # Plot
  output$trendPlot <- renderPlot({
    ggplot(selected_data(), aes(x = Year, y = AQI)) +
      geom_line(color = "blue") +
      geom_point() +
      ggtitle(paste("AQI Trend:", input$district)) +
      theme_minimal()
  })
}

# Run app
shinyApp(ui = ui, server = server)

library(shiny)

# Load trained model (make sure best_model.rds is in the same folder as app.R)
best_model <- readRDS("best_model.rds")

ui <- fluidPage(
  titlePanel("📶 Live QoE Predictor"),
  h4("Auto-updating every 5 seconds"),
  verbatimTextOutput("prediction")
)

server <- function(input, output, session) {
  
  output$prediction <- renderText({
    # Refresh every 5 seconds
    invalidateLater(5000, session)
    
    # Simulate live network values
    throughput <- runif(1, 1, 30)   # Mbps
    delay <- runif(1, 10, 500)      # ms
    jitter <- runif(1, 1, 100)      # ms
    loss <- runif(1, 0, 15)         # %
    
    # Prepare new data
    new_data <- data.frame(
      Throughput_Mbps = throughput,
      Delay_ms = delay,
      Jitter_ms = jitter,
      Packet_Loss_Pct = loss
    )
    
    # Predict QoE
    pred <- predict(best_model, newdata = new_data)
    
    paste0(
      "📊 Predicted QoE: ", pred,
      "\nThroughput: ", round(throughput,2), " Mbps",
      "\nDelay: ", round(delay,2), " ms",
      "\nJitter: ", round(jitter,2), " ms",
      "\nLoss: ", round(loss,2), " %"
    )
  })
}

shinyApp(ui, server)

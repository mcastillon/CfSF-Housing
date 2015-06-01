options(stringsAsFactors = F)

library(shiny)
library(data.table)
library(plyr)
library(dplyr)
library(zoo)
library(forecast)

shinyServer(function(input, output, session) {
  ### Zillow Median Rent dataset
  zillow <- fread("~/CfSF Housing/Data/zillow_rentmedian.csv")
  
  setnames(zillow, tolower(colnames(zillow)))
  
  ### Only Interested in San Francisco 2010 - Present w/at least 1 years worth of data
  sf <- filter(zillow, countyname == "San Francisco") %>%
    select(-starts_with("2010")) %>%
      mutate(num_valid_months = rowSums(!is.na(.)) - 5) %>%
        filter(num_valid_months > 11)
  rownames(sf) <- sf$regionname
  
  ### create time series object
  sf_zoo <- zoo(t(select(sf, starts_with("2")))) %>%
    na.approx(rule = 2)
  index(sf_zoo) <- as.yearmon(colnames(select(sf, starts_with("2"))))
  colnames(sf_zoo) <- sf$region
  ### quarterly numbers are more reliable than monthly due to sample size
  sf_zoo_qtr <- aggregate(sf_zoo, as.yearqtr, mean)

  #### feed ui with neighborhood names
  updateSelectInput(session, "neighborhood", choices = names(sf_zoo))
  
  #### generate ARIMA forecast for the next year and a half 
  output$rent_plot <- renderPlot({
    rent_arima <- auto.arima(sf_zoo[, input$neighborhood])
    forecast_arima <- forecast(rent_arima, h = 12)
    plot(forecast_arima, xlab = "Year", ylab = "Median Rent",
         main = paste("ARIMA Forecast of Median Zillow Rent for",
                      input$neighborhood), flwd = 4, lwd = 4,
         cex.sub = 5)
  }, height = 600, width = 900)
})

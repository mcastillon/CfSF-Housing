options(stringsAsFactors = F)
setwd("~/Github/CfSf Housing")

library(shiny)
library(data.table)
library(plyr)
library(dplyr)
library(zoo)
library(forecast)

shinyServer(function(input, output, session) {
  ### Zillow Median Rent dataset
  zillow <- fread("Data/zillow_rentmedian.csv")
  
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
  ### unfortunately most neighborhoods only have reliable data from 2011 onwards
  index(sf_zoo) <- colnames(select(sf, starts_with("2")))
  colnames(sf_zoo) <- sf$region
  ### aggregating by yearmon allows for the years to be labeled
  sf_zoo_mon <- aggregate(sf_zoo, as.yearmon, mean)

  #### feed ui with neighborhood names
  updateSelectInput(session, "neighborhood", choices = names(sf_zoo_mon))
  
  #### generate ARIMA (Autoregressive Integrated Moving Average) forecast for the next year
  output$rent_plot <- renderPlot({
    rent_arima <- auto.arima(sf_zoo_mon[, input$neighborhood])
    forecast_arima <- forecast(rent_arima, h = 12)
    plot(forecast_arima, xlab = "Year", ylab = "Median Rent",
         main = paste("ARIMA Forecast of Median Zillow Rent for",
                      input$neighborhood), flwd = 4, lwd = 4,
         cex.sub = 5)
  }, height = 600, width = 900)
})

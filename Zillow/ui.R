library(shiny)

shinyUI(
  fluidPage(
    titlePanel("San Francisco Zillow Rent Forecaster"),
  
    sidebarLayout(
      sidebarPanel(
        selectInput(
            inputId = "neighborhood",
            label = "SF Neighborhood",
            choices = "Mission"
          )
        )
      ,
    
    mainPanel(
        plotOutput("rent_plot")
      )
    )
  )
)
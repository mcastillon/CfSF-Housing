In this Shiny app, a user can select a San Francisco neighborhood and visualize it's median rent for 2011 - 2014.
The data is provided by Zillow (http://www.zillow.com/research/data/), and the dataset taken is for Neighborhood-Median rent list price.
Note: Zillow median rent listings are not necessarily representative of the city as a whole, and are often determined from small sample sizes.

You will need the R packages shiny, dplyr, forecast, data.table, and zoo.
In order to run the app, you enter directory and run the following in R command line.

shiny::runApp("Zillow")
gdpmetro <- fread("Data/GDPMetro/allgmp.csv", header = T)
all_industry <- filter(gdpmetro, Description=="All industry total")

yrs <- list(2010:2014)
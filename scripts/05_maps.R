library(tidyverse)
library(lubridate)

#importing dataset
murders <- read_csv("output_data/locatedmurders.csv")
murders$date <- mdy(murders$date)

#fixing addresses
murders$address <- paste0(murders$address, ", Youngstown, OH")

library(ggmap)

#filtering out addresses of intersections, which ggmap can't handle
ggmurders <- murders %>% 
  filter(str_detect(murders$address, "&")==FALSE)

write_csv(ggmurders, "output_data/locatedmurders.csv")

#creating a dataframe that has only the intersections
intmurders <- murders %>% 
  filter(str_detect(murders$address, "&")==TRUE)

write_csv(intmurders, "output_data/intersectionmurders.csv")
#I manually went through and added the lat and lon values for these observations because
#ggmap wouldn't properly return intersections
murders2 <- read_csv("output_data/intersectionmurders.csv")
murders2$date <- mdy(murders2$date)

#adding latitude and longitude data
ggmurders <- mutate_geocode(ggmurders, address)

youngstownloc <- geocode("Youngstown, OH")

#joining all murders into one file
ggmurders <- rbind(murders, murders2)
ggmurders$address <- substr(ggmurders$address, 1, nchar(ggmurders$address)-16)


library(leaflet)

#created a palette
palette <- colorFactor(c("#13ED3F", "#DC143C"), domain=c("Solved", "Unsolved"))

#created information for popups
popupmurders <- paste0("<b>Date: </b>", as.character(ggmurders$date), "</br>",
                       "<b>Location: </b>", as.character(ggmurders$address), "</br>",
                       "<b>Victim Name: </b>", as.character(ggmurders$v_name), "</br>",
                       "<b>Age: </b>", as.character(ggmurders$v_age), "</br>",
                       "<b>Gender: </b>", as.character(ggmurders$v_gender), "</br>",
                       "<b>Race: </b>", as.character(ggmurders$v_race))
                      
#map
map <- leaflet(ggmurders) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  setView(youngstownloc$lon, youngstownloc$lat, zoom=12) %>% 
  addCircleMarkers(~lon, ~lat, weight=3, radius=5, color=~palette(solved_label),
                   popup=popupmurders, clusterOptions = markerClusterOptions(maxClusterRadius=1, spiderfyDistanceMultiplier=2),
                   stroke=F, fillOpacity=0.5) %>% 
  addLegend("bottomright", colors=c("#13ED3F", "#DC143C"), labels=c("Solved", "Unsolved"),
           title="Youngstown Murders 2001-2017")
  
map




library(dplyr)
library(tidyr)
library(leaflet)
library(sf)

raw_stations <- read.csv("data/raw/stations.csv", stringsAsFactors = F)

stations <- raw_stations |>
  filter(end_date == "") |>
  select(
    stationid,
    locationtext,
    lon,
    lat,
    milepost,
    agency
  )

stations_map <- stations |>
  leaflet() |>
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(
    lng = stations$lon,
    lat = stations$lat,
    color = "navy",
    radius = 2,
    popup = paste("Highway: ", stations$highwayname, "<br>",
                  "Direction: ", stations$direction, "<br>",
                  "Station ID: ", stations$stationid, "<br>",
                  "Description: ", stations$locationtext)
  ) %>%
  addCircleMarkers(
    lng = wsdot_given_locations$longitude,
    lat = wsdot_given_locations$latitude,
    color = 'red',
    radius = 2,
    popup = paste("Highway: ", wsdot_given_locations$highway_name, "<br>",
                  "Direction: ", wsdot_given_locations$link_direction, "<br>",
                  "Agency ID: ", wsdot_given_locations$station_id, "<br>",
                  "Description: ", wsdot_given_locations$location_name)
  )


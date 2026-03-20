library(dplyr)
library(tidyr)
library(leaflet)
library(sf)
library(tigris)

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
  # filter(lon != -1) |>
  leaflet() |>
  addProviderTiles(providers$CartoDB.Positron) |>
  addCircleMarkers(
    lng = stations$lon,
    lat = stations$lat,
    color = "purple",
    radius = 2,
    popup = paste("Stationid: ", stations$stationid, "<br>",
                  "Description: ", stations$locationtext, "<br>",
                  "Agency: ", stations$agency, "<br>",
                  "MP: ", stations$milepost)
  )
stations_map

va_counties <- counties(state = "VA")

va_counties <- st_transform(va_counties, crs = '+proj=longlat +datum=WGS84')


va_county_map <- va_counties |>
  leaflet() |>
  addProviderTiles(providers$CartoDB.Positron) |>
  addPolygons(
    highlightOptions = highlightOptions(color = "white", weight = 2,
                                        bringToFront = T),
    popup = paste(
      "NAME: ", va_counties$NAME, "<br>"
    )
  )
va_county_map

# read_sf(dsn = ".", layer = "Precinct_Split_March2024_Final")


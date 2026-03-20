# joins, group, select, summarize

library(dplyr)
library(tidyr)
library(ggplot2)


clean_df <- readRDS("data/clean_data.rds")
raw_detectors <- read.csv("data/raw/detectors.csv", stringsAsFactors = F)
# raw_stations <- read.csv("data/raw/stations.csv", stringsAsFactors = F)

# use import dataset function
# library(readr)
# stations <- read_csv("data/raw/stations.csv")

# bring up distinct()

detectors <- raw_detectors |>
  # filter(is.na(end_date))
  filter(end_date == "") |>
  select(detectorid, stationid)

df_stids <- clean_df |>
  left_join(detectors, by = c("detector_id" = "detectorid"))

stations_df <- df_stids |>
  group_by(
    stationid,
    starttime
    ) |>
  summarise(
    mean_speed = mean(speed),
    tot_volume = sum(volume),
    mean_occ = mean(occupancy)
  )

# install viridis
library(viridis)


# layer this process

st_speed_occ_fig <- stations_df |>
  ggplot(aes(x = mean_speed, y = mean_occ)) +
  geom_point(aes(color = factor(stationid))) +
  scale_color_viridis(discrete=TRUE) + 
  theme_bw() +
  facet_grid(stationid ~ .)
st_speed_occ_fig

ggplotly(st_speed_occ_fig)


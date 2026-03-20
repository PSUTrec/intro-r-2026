# load libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)
  
clean_df <- readRDS("data/clean_data.rds")
raw_detectors <- read.csv("data/raw/detectors.csv", stringsAsFactors = F)

head(clean_df$starttime)

# format starttime with US/Pacific timezone
clean_df$starttime <- ymd_hms(clean_df$starttime, tz = "US/Pacific")

# get unique detector and station ids
det_st_ids <- raw_detectors |>
  select(
    detectorid,
    stationid
  ) |>
  distinct()

# aggregate data from detector level to station level

stations_df <- clean_df |>
  left_join(det_st_ids, by = c("detector_id" = "detectorid")) |>
  group_by(
    stationid,
    starttime
  ) |>
  summarise(
    mean_speed = mean(speed),
    tot_volume = sum(volume),
    mean_occ = mean(occupancy)
  ) |>
  as.data.frame()

sta_1059 <- stations_df |>
  filter(stationid == 1059) |>
  right_join(starttime_seq, by = "starttime") |>
  ggplot(aes(x = starttime, y = tot_volume)) +
  geom_line(color = "skyblue") +
  geom_point(color = "darkblue") +
  scale_x_datetime(
    date_breaks = "1 day",
    date_labels = "%Y-%m-%d",
    guide = guide_axis(angle = 45)
  ) +
  xlab(NULL) +
  theme_bw() +
  geom_hline(yintercept = mean(stations_df$tot_volume),
             color = "pink")
sta_1059

starttime_seq <- seq(
  from = ymd_hms("2026-02-01 00:00:00", tz = "US/Pacific"),
  to = ymd_hms("2026-02-16 00:00:00", tz = "US/Pacific"),
  by = "15 min"
) |>
  as.data.frame()
colnames(starttime_seq) <- c("starttime")

figure_function <- function(stid, measure){
  sta_1059 <- stations_df |>
    filter(stationid == stid) |>
    right_join(starttime_seq, by = "starttime") |>
    ggplot(aes(x = starttime, y = {{measure}})) +
    geom_line(color = "skyblue") +
    geom_point(color = "darkblue", size = 0.5) +
    scale_x_datetime(
      date_breaks = "1 day",
      date_labels = "%Y-%m-%d",
      guide = guide_axis(angle = 45)
    ) +
    xlab(NULL) +
    theme_bw()
  sta_1059
}

figure_function(3142, mean_speed)


source("R/figure_function.R")
figure_function(10755, mean_occ)









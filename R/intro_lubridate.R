library(dplyr)
library(tidyr)
library(lubridate)
library(plotly)

clean_df <- readRDS("data/clean_data.rds")
raw_detectors <- read.csv("data/raw/detectors.csv", stringsAsFactors = F)
raw_stations <- read.csv("data/raw/stations.csv", stringsAsFactors = F)

head(clean_df$starttime)
head(ymd_hms(clean_df$starttime, tz = "US/Pacific"))

clean_df$starttime <- ymd_hms(clean_df$starttime, tz = "US/Pacific")

det_st_ids <- raw_detectors |>
  select(
    detectorid,
    stationid
    ) |>
  distinct()

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
  geom_point(color = "darkblue", size = 1) +
  # scale_x_datetime(
    # breaks = scales::pretty_breaks(n=20),
    # date_labels = "%Y-%m-%d %H:%M:%S") +
  scale_x_datetime(
    date_breaks = "1 day", 
    date_labels = "%Y-%m-%d",
    guide = guide_axis(angle = 45)
    ) +
  xlab(NULL)
ggplotly(sta_1059) |>
  layout(xaxis = list(tickangle = 105))

starttime_seq <- seq(
  from = ymd_hms("2026-02-01 00:00:00", tz = "US/Pacific"), 
  to = ymd_hms("2026-02-15 23:45:00", tz = "US/Pacific"),
  by ="15 min"
  ) |>
  as.data.frame()
colnames(starttime_seq) <- c("starttime")




station_figure <- function(stid, y){
  
  figure <- stations_df |>
    filter(stationid == stid) |>
    right_join(starttime_seq, by = "starttime") |>
    ggplot(aes(x = starttime, y = {{y}})) +
    geom_line(color = "skyblue") +
    geom_point(color = "darkblue", size = 1) +
    # scale_x_datetime(
    # breaks = scales::pretty_breaks(n=20),
    # date_labels = "%Y-%m-%d %H:%M:%S") +
    scale_x_datetime(
      date_breaks = "1 day", 
      date_labels = "%Y-%m-%d",
      guide = guide_axis(angle = 45)
    ) +
    xlab(NULL)
  
}

test_fig <- station_figure(1059, mean_speed)
test_fig

# load libraries
library(
  tidyr,
  dplyr,
  lubridate
)

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
  ggplot(aes(x = starttime, y = tot_volume)) +
  geom_line() +
  geom_point()
sta_1059

# Load libraries
library(ggplot2)
library(tidyr)
library(dplyr)

# Load raw data
raw_15min <- read.csv("data/raw/agg_15min_data.csv", stringsAsFactors = F)

# Preliminary data exploration
str(raw_15min)
head(raw_15min)
tail(raw_15min)

summary(raw_15min)

# call out column
raw_15min[, 2]

# call out row
raw_15min[2, ]

mean(raw_15min$volume)
# mean(raw_15min$speed) # check for NA's
hist(raw_15min$occupancy)
# hist(raw_15min$speed)

table(raw_15min$detector_id)

# summarytools
dfSummary()

# filter out occupancy > 20
occ_20plus <- raw_15min |>
  filter(occupancy > 20)

# filter out occupancy <10 and speed > 80
occ10_speed80 <- raw_15min |>
  filter(occupancy < 10 & speed > 80)
table(occ10_speed80$detector_id)

det_101185 <- occ10_speed80 |>
  filter(detector_id == 101185)
not_101185 <- occ10_speed80 |>
  filter(detector_id != 101185)

# filter using vector
dets_oc10_sp80 <- occ10_speed80 |>
  filter(detector_id %in% c(101170, 101179, 101185))

# or create object vector first
det_ids <- c(101170, 101179, 101185)
# then filter by object
dets_oc10_sp80 <- occ10_speed80 |>
  filter(detector_id %in% det_ids)

# filter out na's
complete_df <- raw_15min |>
  filter(!is.na(speed))

# plot speed versus occ
speed_occ_fig1 <- complete_df |>
  ggplot(aes(x = speed, y = occupancy)) +
  geom_point()
speed_occ_fig1

speed_occ_fig2 <- complete_df |>
  ggplot(aes(x = speed, y = occupancy, color = detector_id)) +
  geom_point()
speed_occ_fig2

# convert detector_id into factor
complete_df$detector_id <- as.factor(complete_df$detector_id)

speed_occ_fig3 <- complete_df |>
  ggplot(aes(x = speed, y = occupancy, color = detector_id)) +
  geom_point()
speed_occ_fig3

# demonstrate facet wrap, grip, and then filter out subset of data
speed_occ_fig4 <- complete_df |>
  filter(detector_id %in% det_ids) |>
  ggplot(aes(x = speed, y = occupancy)) +
  geom_point() +
  facet_grid(detector_id ~ .)
speed_occ_fig4

# example for class to do, just plot speed versus occupancy
oc10_sp80_fig1 <- occ10_speed80 |>
  ggplot(aes(x = speed, y = occupancy)) +
  geom_point()
oc10_sp80_fig1

# Load libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(summ)

# Load raw data
raw_15min <- read.csv("data/raw/agg_15min_data.csv", stringsAsFactors = F)

# structure of data
str(raw_15min)

# Preliminary data exploration
head(raw_15min)
tail(raw_15min)

summary(raw_15min)
# dfSummary(raw_15min)

raw_15min[2, ]
raw_15min[ , 2]
raw_15min[2, 3]

mean(raw_15min$speed)
mean(raw_15min$volume)
hist(raw_15min$volume)

# learn about filters
occ_20plus <- raw_15min |>
  filter(occupancy < 20)

occ10_sp80 <- raw_15min |>
  filter(occupancy < 10 & speed > 80)
table(occ10_sp80$detector_id)

# working with NA's
blank_example <- raw_15min |>
  filter(is.na(speed))
complete_df <- raw_15min |>
  filter(!is.na(speed))

sub_det <- c(101185, 101176, 101179)

subset_o10s80 <- occ10_sp80 |>
  filter(detector_id %in% sub_det)

saveRDS(complete_df, "data/clean_data.rds")

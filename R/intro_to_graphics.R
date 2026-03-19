# load libraries
library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)

# load clean dataset
clean_df <- readRDS("data/clean_data.rds")

speed_occ_fig <- clean_df |>
  ggplot(aes(x = speed, y = occupancy, color = as.factor(detector_id))) +
  geom_point()
speed_occ_fig

# clean_df$detector_id <- as.factor(clean_df$detector_id)

speed_occ_fig2 <- clean_df |>
  filter(detector_id < 101100) |>
  filter(speed > 40) |>
  ggplot(aes(x = speed, y = volume, color = as.factor(detector_id))) +
  geom_point()
speed_occ_fig2

det_speed_fig <- clean_df |>
  filter(detector_id < 101100) |>
  ggplot(aes(x = detector_id, y = speed)) +
  geom_point() +
  geom_boxplot(aes(group = detector_id))
det_speed_fig

det_speed_figly <- ggplotly(speed_occ_fig2)
det_speed_figly

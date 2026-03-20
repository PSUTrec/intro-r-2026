library(ggplot2)
library(dplyr)

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
require(lubridate)
require(tidyr)
require(dplyr)
require(ggplot2)
require(data.table)



all_metric <- fread("./rzdelta_scaled_values.csv")
all_bench <- fread("./rzdelta_time_bench.csv")

metric_graph <- 
  all_metric %>%
  ggplot() + 
  geom_line(aes(x=ngenomes,y=value,  color=metric), size=1) +
  ggtitle(label = "Values of r,z, and \u03b4 with cumulative salmonella genomes") +
  labs(color="", x="Number of Concatenated Salmonella Genomes", y="Scaled Metric Value") +
  theme_bw() + 
  theme(legend.position=c(.9,.25))


metric_graph

ggplot2::ggsave(filename = "rzdelta.png", 
                plot = metric_graph,
                device = "png"
                )


wallclock_graph <- all_bench %>% 
  ggplot() + geom_line(aes(x=ngenomes,y=value, color=metric), size=1) + 
  labs(y="WallClock Time (sec)", color="", x="Number of Concatenated Salmonella Genomes") +
  ggtitle("Timing Metrics for r,z, and \u03b4 with cumulative salmonella genomes") +
  theme_bw() + 
  theme(legend.position=c(.1,.75))

wallclock_graph

ggplot2::ggsave(filename = "rzdelta_time.png", 
                plot = wallclock_graph,
                device = "png"
)

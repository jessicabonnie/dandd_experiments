#!/usr/bin/env Rscript

require(lubridate)
require(tidyr)
require(dplyr)
require(ggplot2)
require(data.table)
library(forcats)
library(latex2exp)

all_metric <- fread("./rzdelta_scaled_values.csv")
all_bench <- fread("./rzdelta_time_bench.csv")

#print(all_metric$metric)
# all_metric$metric <- factor(all_metric$metric,
#                                levels=c('r', 'z', 'delta'),
#                                labels=c(unname(TeX('$r$')),
#                                         unname(TeX('$z$')),
#                                         unname(TeX('$\\delta$'))))

pdf(file='f2_rzdelta.pdf', width=4, height=3)
ggplot(all_metric) +
    geom_line(aes(x=ngenomes, y=value, color=metric), size=1) +
    scale_color_discrete(labels = unname(TeX(c("$r$", "$z$", "$\\delta$")))) +
    labs(color="", x="Number of Salmonella Genomes", y="0-1 normalized measure") +
    theme_bw() +
    theme(legend.position=c(.8,.25))
dev.off()

pdf(file='f2_rzdelta_time.pdf', width=4, height=3)
all_bench$metric <- fct_relevel(all_bench$metric, 'r', 'z')
ggplot(all_bench) +
    geom_line(aes(x=ngenomes, y=value, color=metric), size=1) +
    labs(y="Wall time (sec)", color="", x="Number of Salmonella Genomes") +
    scale_color_discrete(labels = unname(TeX(c("$r$", "$z$", "$\\delta$")))) +
    theme_bw() +
    theme(legend.position=c(.15,.75))
dev.off()

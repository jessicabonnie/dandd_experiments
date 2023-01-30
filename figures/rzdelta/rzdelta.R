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

r_vals <- (all_metric %>% filter(metric == 'r') %>% arrange(value))$value
z_vals <- (all_metric %>% filter(metric == 'z') %>% arrange(value))$value
d_vals <- (all_metric %>% filter(metric != 'r' & metric != 'z') %>% arrange(value))$value

summary(r_vals - z_vals)
summary(z_vals - d_vals)
summary(r_vals - d_vals)

# > summary(r_vals - z_vals)
#      Min.   1st Qu.    Median      Mean   3rd Qu.      Max.
# -0.027272 -0.009205  0.000000 -0.003186  0.003312  0.010307
# > summary(z_vals - d_vals)
#       Min.    1st Qu.     Median       Mean    3rd Qu.       Max.
# -0.0273759 -0.0131273 -0.0029493 -0.0039276  0.0009673  0.0215961
# > summary(r_vals - d_vals)
#       Min.    1st Qu.     Median       Mean    3rd Qu.       Max.
# -1.707e-02 -1.076e-02 -6.896e-03 -7.114e-03 -2.799e-03  8.531e-06

# Above: in support of the claim "with no two of the normalized
# measures ever differing by more than $\pm 0.0273$."

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

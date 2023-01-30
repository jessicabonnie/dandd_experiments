#!/usr/bin/env Rscript

library(ggplot2)
library(dplyr)

afdf <- fread("./kij_j_df.csv")

gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}


afgraph <- ggplot(
          afdf, aes(x=as.numeric(unik), y=nRF, color=tool_and_method, shape=tool_and_method)) + 
          theme_bw() + #legend.position = c(.85, .8),
          theme(legend.title="", legend.position = c(.85, .8) ) +
          ggtitle('Distance: 1 - Jaccard' ) +
          geom_point(size=2,alpha=.7) + 
          facet_wrap(~species, nrow = 2) + 
          scale_shape_manual(values=c(15,17,19,8)) +
          scale_color_manual(values = c(gg_color_hue(4)[1:3],"red")) +
          theme_bw() 

ggsave(filename = "afproject.png", 
               plot = afgraph,
               device = "png"
)

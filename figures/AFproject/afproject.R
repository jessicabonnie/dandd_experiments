#!/usr/bin/env Rscript

library(ggplot2)
library(dplyr)

afdf <- read.csv("./kij_j_df.csv", header=T)
afdf <- afdf[!grepl('Dashing', afdf$tool_and_method),]

facet_names <- list(
  'ecoli'="29 E. coli genomes",
  'fish'="25 fish mitochondria"
)

facet_label <- function(y, x) { return(facet_names[x]); }

pdf(file='f4_afproject.pdf', width=7.5, height=2.5)
ggplot(
      afdf, aes(x=as.numeric(unik), y=nRF, color=tool_and_method, shape=tool_and_method)) +
      geom_point(size=1.25,alpha=.8) +
      facet_wrap(~species, nrow=1) +
      scale_shape_manual(values=c(15,17,19,8)) +
      scale_y_continuous(limits=c(0, 1)) +
      labs(x='k') +
      theme_bw() +
      theme(legend.title=element_blank(), legend.position = c(.85, .75))
dev.off()

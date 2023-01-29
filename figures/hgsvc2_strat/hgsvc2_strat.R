
require(tidyr)
require(ggplot2)
require(data.table)
require(dplyr)

summary <-fread('./HVSVC2_progu120_dashing_summary.csv')
gcount=max(summary$ngen)
norder=120
title="Mean Values of \u03b4* over 120 Orderings of 34 HGSVC2 Haplotypes"


hgst <- ggplot()  +
      geom_line(data=ungroup(summary), aes(y=mean, x=ngen, color=dataset)) +
    scale_linetype_manual(name=paste0("Fit (",norder," Orderings)"),values=c(2)) +
    theme_bw() +
    scale_x_continuous(breaks= scales::pretty_breaks(10)) +
    # scale_color_discrete(name = "Random Genome Ordering") +
    xlab("Number of Genomes in Set") +
    ylab("Value of \u03b4*") +
    ggtitle(label=title)  +
    scale_y_continuous(labels = scales::label_number_auto())

hgst 


ggplot2::ggsave(
  filename = "hgstrat_plot.png", 
  plot = hgst,
  device = "png"
  )

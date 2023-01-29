## Draw delta progu graphs for overlapping samples from HGHVC2 and pangenome datasets
require(tidyr)
require(ggplot2)
require(data.table)
require(openssl)
require(dplyr)
require(optparse)
require(callr)
require(codetools)

## Prep data
# overlap<-read.csv('./overlap_progu90_8_dashing.csv') %>% 
#   mutate(dataset="Pangenome")
# hgsvc2<-read.csv('./hgoverlap_progu90_8_dashing.csv') %>% 
#   mutate( dataset="HGSVC2")

# progu=rbind(overlap,hgsvc2)

summary <- fread('./overlap_summary.csv')
gcount=max(summary$ngen)
norder=90
tp <-
  ggplot() + 
  geom_line(data=ungroup(summary), aes(y=mean, x=ngen, color=dataset)) +
  scale_linetype_manual(name=paste0("Fit (",norder," Orderings)"),values=c(2)) +
  theme_bw() +
  scale_x_continuous(breaks= scales::pretty_breaks(10)) +
  # scale_color_discrete(name = "Random Genome Ordering") +
  xlab("Number of Genomes in Set") +
  ylab("Value of \u03b4*") +
  ggtitle(label="8 Overlapping Haplotypes between Pangenome and HGHVC2")  +
  scale_y_continuous(labels = scales::label_number_auto())

tp

ggplot2::ggsave(filename = "overlap_plot.png", 
                plot = tp,
                device = "png"
               )

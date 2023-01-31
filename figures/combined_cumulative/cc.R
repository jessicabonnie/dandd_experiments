#!/usr/bin/env Rscript

require(ggplot2)
require(dplyr)
library(latex2exp)
library(forcats)
library(cowplot)

df <- read.csv('../hgsvc2_strat/hgsvc2_u120_clean.csv')
gcount <- max(df$ngen)
norder <- 120

pa <- read.csv('../pangenome/female_progu30_56_dashing.csv') %>% mutate(dataset="Pangenome")


plotCumulativeUnion <- function(progu, title, summarize=TRUE, nshow=10) {
  gcount=max(progu$ngen)
  norder=max(progu$ordering)
  progu$delta <- progu$delta / 1.0e9

  summary <- summarize(group_by(progu, ngen, dataset), mean=mean(delta))
  print(names(summary))

  tp <- ggplot()

  if (nshow > 0) {
    progu <- progu %>%
      mutate(Indicator=ordering <= nshow) %>%
      # filter(ordering %in% c(1:20)) %>%
      mutate(ngen=as.integer(ngen),kval=as.factor(kval))
    tp <- tp +
      geom_line(data=summary, aes(y=mean, x=ngen, linetype="Mean")) +
      geom_line(data=filter(progu,Indicator),
                aes(y=delta, x=ngen,# linetype="Individual Ordering",
                    group=ordering, color=as.factor(ordering)), size=.5) +
      scale_shape_discrete(name="argmax(k)") +
      guides(color = 'none')
  }
  else {
    tp <- tp +
      geom_line(data=ungroup(summary), aes(y=mean, x=ngen, color=dataset))
  }

  tp <- tp +
    scale_linetype_manual(name=paste0("Fit (",norder," Orderings)"),values=c(2)) +
    theme_bw() +
    theme(legend.position=c(.6,.2), legend.title = element_blank()) +
    scale_x_continuous(breaks= scales::pretty_breaks(10)) +
    xlab("Number of HPRC haplotypes") +
    ylab(unname(TeX("Mean $\\delta$ (billions)"))) +
    scale_y_continuous(labels = scales::label_number_auto())

  return(tp)
}

pdf(file='f3_combcum.pdf', width=8, height=3)
p1 <- ggplot(df, aes(y=mean/1e9, x=ngen, color=dataset))  +
    geom_line() +
    scale_linetype_manual(name=paste0("Fit (",norder," Orderings)"),values=c(2)) +
    theme_bw() +
    scale_x_continuous(breaks= scales::pretty_breaks(10)) +
    theme(legend.position=c(.6,.2), legend.title = element_blank()) +
    xlab("Number of HGSVC2 Haplotypes") +
    ylab(unname(TeX("Mean $\\delta$ (billions)"))) +
    scale_color_discrete(labels = unname(TeX(c("SNVs + Indels ($\\alpha$=0.943)",
                                               "SNVs + SVs + Indels  ($\\alpha$=0.944)",
                                               "SNVs Only ($\\alpha=0.939$)")))) +
    scale_y_continuous(labels = scales::label_number_auto())

p2 <- plotCumulativeUnion(progu=pa, title="56 Female Pangenome Haplotypes, 30 orderings", nshow=5)
plot_grid(p1, p2, labels = c('A', 'B'))
dev.off()

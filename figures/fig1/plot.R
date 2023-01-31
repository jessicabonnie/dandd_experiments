#!/usr/bin/env Rscript

# setwd('~/git/dandd_experiments/figures/fig1')

library(dplyr)
library(ggplot2)
library(forcats)
library(latex2exp)

m <- read.csv('combined_ksweep_kmc.csv', header=T)

m$dkk <- m$delta_pos
m <- m %>% group_by(species) %>% summarize(species, kval, dkk, max_dkk=max(dkk))
m <- m %>% filter(kval <= 37)
m$dkk_norm <- m$dkk / m$max_dkk
argm_ecoli <- m$kval[which(m$species == 'ecoli' & m$dkk_norm == 1.0)]
argm_human <- m$kval[which(m$species == 'human' & m$dkk_norm == 1.0)]
argm_salmo <- m$kval[which(m$species == 'salmonella' & m$dkk_norm == 1.0)]
fct_relevel(m$species, 'human', 'ecoli', 'salmonella')
m$species <- factor(m$species, levels=c('human', 'ecoli', 'salmonella'),
                               labels=c(paste0("Human (k* = ", argm_human, ")"),
                                        paste0("E. coli (k* = ", argm_ecoli, ")"),
                                        paste0("Salmonella (k* = ", argm_salmo, ")")))

pdf(file='f1_dkksweep.pdf', width=4, height=3)
ggplot(m, aes(x=kval, y=dkk_norm, color=species)) + geom_line() + theme_bw() +
    theme(legend.position = c(0.651, 0.22), legend.title = element_blank()) +
    labs(x=unname(TeX('$k$')), y=unname(TeX('0-1 Normalized $d_k(S)/k$')))
dev.off()

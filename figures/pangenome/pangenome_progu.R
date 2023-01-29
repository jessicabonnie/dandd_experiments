require(tidyr)
require(ggplot2)
require(dplyr)

females<-read.csv('female_progu30_56_dashing.csv') %>% mutate(dataset="Pangenome")
xx <- plotCumulativeUnion(progu=females, title="56 Female Pangenome Haplotypes, 30 orderings", nshow=5)


ggplot2::ggsave(filename = "pangenome_progu.png", 
                plot = xx,
                device = "png"
)



plotCumulativeUnion <- function(progu, title, summarize=TRUE, nshow=10){
  gcount=max(progu$ngen)
  norder=max(progu$ordering)
  
  summary <- summarize(group_by(progu, ngen, dataset), mean=mean(delta))
  print(names(summary))
  
  tp <-
    ggplot() 
  
  if (nshow > 0){
    progu <- progu %>%
      mutate(Indicator=ordering <= nshow) %>%
      # filter(ordering %in% c(1:20)) %>%
      mutate(ngen=as.integer(ngen),kval=as.factor(kval))
    tp <- tp +
      geom_line(data=summary, aes(y=mean, x=ngen, linetype="Mean")) +
      geom_point(data=filter(progu,Indicator),aes(y=delta, x=ngen, shape=kval), size=.5) +
      geom_line(data=filter(progu,Indicator),
                aes(y=delta, x=ngen,# linetype="Individual Ordering",
                    group=ordering, color=as.factor(ordering)), size=.5) +
      scale_shape_discrete(name="argmax(k)") +
      guides(color = 'none')
  }
  else{
    tp <- tp +
      geom_line(data=ungroup(summary), aes(y=mean, x=ngen, color=dataset)) 
  }
  
  tp <- tp + 
    scale_linetype_manual(name=paste0("Fit (",norder," Orderings)"),values=c(2)) +
    theme_bw() +
    scale_x_continuous(breaks= scales::pretty_breaks(10)) +
    # scale_color_discrete(name = "Random Genome Ordering") +
    xlab("Number of Genomes in Set") +
    ylab("Value of \u03b4*") +
    ggtitle(label=title)  +
    scale_y_continuous(labels = scales::label_number_auto())
  
  return(tp)
}

alpha <- function(progu.df){
  # progu.df <- group_by (ngenmutate(progu.df, av)
  avg.progu <- progu.df %>%
    group_by(ordering) %>% 
    mutate(delta_delta=delta - lag(delta, default = delta[1])) %>%
    ungroup() %>% group_by(ngen) %>% 
    summarize(mean_delta=mean(delta), mean_delta_delta2 = mean(delta_delta)) %>%
    mutate(mean_delta_delta1 = mean_delta - lag(mean_delta, default = mean_delta[1]))
  new_item <- avg.progu$mean_delta_delta1
  N=length(new_item)
  # ALPHA
  x = 2:N
  model = lm(log(new_item[x])~log(x))
  alpha = abs(model$coefficients[2])
  return(alpha)
}


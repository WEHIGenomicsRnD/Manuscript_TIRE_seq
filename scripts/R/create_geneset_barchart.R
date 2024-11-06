geom_GeneSet_Barchart <- function(camera_result, num_genes=10) {
  # Input is a camera object generated with 
  # e.g camera(v,idx,design,contrast=contr.matrix[,1])
  camera_tb <- as_tibble(camera_result, rownames = "Gene")
  # Cleanup the labels from the gene set annotation
  camera_tb <- camera_tb %>% 
    mutate(Count = if_else(Direction == "Down", -NGenes, NGenes)) %>% 
    mutate(Sig = -log(FDR)) %>% 
    mutate(gene = sub("^HALLMARK_", " ", Gene) %>% 
             gsub("_", " ", .) %>%
             str_to_title() %>% 
             {paste0(tolower(word(.,)), substr(gsub("\\s", "", .), nchar(word(., 1)) + 1, nchar(.)))} %>%
             gsub("\\s", "", .)) %>%  
    arrange(FDR) %>% 
    head(num_genes)
  
  # Generate the plot
  plt <- ggplot(data=camera_tb, aes(x=Count, y=reorder(gene, Sig), fill = Sig)) +
    geom_bar(stat="identity") +
    scale_fill_viridis(option="inferno",begin = 0.3,end = 0.9)+
    xlab("Number of genes") + ylab("") + labs(fill= "-log10 (adj.P.val)") +
    theme(
      axis.text.x = element_text(size = 0.5),  # Change x-axis text size
      axis.text.y = element_text(size = 1)   # Change y-axis text size
    ) +
    theme_Publication()
  
  return(plt)
}
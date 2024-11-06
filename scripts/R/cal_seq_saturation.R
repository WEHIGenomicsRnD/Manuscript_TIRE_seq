# 10x genomics defines sequencing saturation as “Sequencing Saturation = 1 - (n_deduped_reads / n_reads)”.  
# Reading soome forums it appears to be the umi count matrix divided by the read count matrix - 1. 

calc_seq_saturation <- function(path_to_output_of_zUMIs) {
  zUMI = readRDS(path_to_output_of_zUMIs)
  mtx.read <- zUMI[['readcount']][['exon']][['all']]
  mtx.umi <- zUMI[['umicount']][['exon']][['all']]
  sum.read <- sum(mtx.read)
  sum.umi <- sum(mtx.umi)
  seq.sat <- 1 - (sum.umi / sum.read)
  seq.sat <- round(seq.sat * 100, digits = 2)
  
  # Calculate saturation per cell
  cell.sat <- (1 - colSums(mtx.umi) / colSums(mtx.read)) * 100
  cell.sat <- round(cell.sat, 2)
  
  # Package overall saturation with cell saturation
  saturation <- list(seq.sat, cell.sat)
  names(saturation) <- c("overall_saturation", "per_cell_saturation")
  return(saturation)
}

# Test
# path <- here::here("data/NN182/raw/zUMIs_output/expression", 'NN182_Bergamasco.dgecounts.rds')
# saturation <- calc_seq_saturation(path)

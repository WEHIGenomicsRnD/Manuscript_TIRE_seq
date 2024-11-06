
# Read data
plateBC <- read.csv(here::here(
  "metadata/references/i7_only_Kit_TT_Set_A.csv"
))

wellBC <- read.csv(here::here(
  "metadata/references/version2_read1_wellBC.csv"
))

# Define the vectors
vector1 <- plateBC$i7_8nt
vector2 <- wellBC$rev_comp_seq

# Get all combinations
combinations <- expand.grid(vector1, vector2)

# Concatenate the combinations
combinations <- as.data.frame(paste(combinations$Var1, combinations$Var2, sep=""))

# Write the result to a CSV file
write.csv(combinations, file = here::here("metadata/references/version2_all_sample_BCs.csv"), 
          row.names = FALSE, quote = F)

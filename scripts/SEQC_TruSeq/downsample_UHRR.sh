#!/bin/bash
#SBATCH --partition=regular
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --time=6:00:00
#SBATCH -e logs/seqtk-%j.err
#SBATCH -o logs/seqtk-%j.out
#SBATCH --job-name=seqtk

# SEQ 35,713,800

# TIRE-Seq 222,700,405	reads
# Prime-seq 263,664,864	reads
# Downsample to constant 222,700,405

# SETUP
module load micromamba/latest;
eval "$(micromamba shell hook --shell bash)"
#micromamba create --prefix /vast/projects/G000448_Protein_display/envs/ngsQC \
#    -c bioconda fastq-screen rseqc qualimap seqtk;
micromamba activate /vast/projects/G000448_Protein_display/envs/ngsQC;

# Input files
INPUT_DIR="/vast/projects/G000448_Protein_Design/BulkRNA_Manuscript/Public/"
input_R1=${INPUT_DIR}"SEQC_UHRR_combined_R1.fastq.gz"
input_R2=${INPUT_DIR}"SEQC_UHRR_combined_R1.fastq.gz"

# Random seed for reproducibility
seed=123
# Number of reads to sample
n_reads=222700405

# Output files
OUTPUT_DIR="/vast/projects/G000448_Protein_Design/BulkRNA_Manuscript/Public/downsample_fastq/";
output_R1=${OUTPUT_DIR}"SEQC_UHRR_combined_DS_R1.fastq.gz";
output_R2=${OUTPUT_DIR}"SEQC_UHRR_combined_DS_R1.fastq.gz";

mkdir $OUTPUT_DIR

# Downsample
zcat $input_R1 | seqtk sample -s$seed - $n_reads | gzip > $output_R1;
zcat $input_R2 | seqtk sample -s$seed - $n_reads | gzip > $output_R2;

echo "Downsampling complete. Output files: $output_R1 and $output_R2";
# ----
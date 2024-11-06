#!/bin/bash
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=64G
#SBATCH --time=6:00:00
#SBATCH -e logs/seqtk-%j.err
#SBATCH -o logs/seqtk-%j.out
#SBATCH --job-name=seqtk

# Prime-seq = MB2_PRM0003_YN sequenced on 2 runs:
# S000514 40M
# S000493 149.8M
# combined = 189.8M / 192 samples = 988k reads per well

# TIRE-Seq
# S000553 160.0M / 96 samples = 1.66M reads per well
# Therefore need to downsample this to 988k * 96 = 94,848,000 reads for the library

# SETUP
module load micromamba/latest;
eval "$(micromamba shell hook --shell bash)"
#micromamba create --prefix /vast/projects/G000448_Protein_display/envs/ngsQC \
#    -c bioconda fastq-screen rseqc qualimap seqtk;
micromamba activate /vast/projects/G000448_Protein_display/envs/ngsQC;

# Input files
INPUT_DIR="/stornext/Projects/GenomicsRnD/brown.d/S000553/fastq/TIRE/"
input_R1=${INPUT_DIR}"TURBO_YN_Tcell_GEX_PLT1_S3_R1_001.fastq.gz"
input_R2=${INPUT_DIR}"TURBO_YN_Tcell_GEX_PLT1_S3_R2_001.fastq.gz"

# Random seed for reproducibility
seed=123
# Number of reads to sample
n_reads=94848000

# Output files
OUTPUT_DIR="/vast/projects/G000448_Protein_display/BulkRNA_Manuscript/TIRE/Tcell/downsample_fastq/";
output_R1=${OUTPUT_DIR}"TURBO_YN_Tcell_GEX_DS_S3_R1_001.fastq.gz";
output_R2=${OUTPUT_DIR}"TURBO_YN_Tcell_GEX_DS_S3_R2_001.fastq.gz";

# Downsample
zcat $input_R1 | seqtk sample -s$seed - $n_reads | gzip > $output_R1;
zcat $input_R2 | seqtk sample -s$seed - $n_reads | gzip > $output_R2;

echo "Downsampling complete. Output files: $output_R1 and $output_R2";
# ----
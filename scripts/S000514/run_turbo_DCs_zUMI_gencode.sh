#!/bin/bash
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=250G
#SBATCH --time=47:00:00
#SBATCH -e logs/gcd_TIRE-%j.err
#SBATCH -o logs/gcd_TIRE-%j.out
#SBATCH --job-name=gcd_TIRE

#------------- Set up combined fastq file for manuscript TIRE-Seq Brain runs
S442="/stornext/Projects/GenomicsRnD/brown.d/S000442/fastq/";
S446="/stornext/Projects/GenomicsRnD/brown.d/S000446/fastq/";
S514="/stornext/Projects/GenomicsRnD/brown.d/S000514/fastq/TIRE/";

# Have to do Brain and DCs separately as they are split over multiple plate barcodes
Brain="/vast/scratch/users/brown.d/BulkRNA_Manuscript/TIRE/Brain";
DCs="/vast/scratch/users/brown.d/BulkRNA_Manuscript/TIRE/DCs"
#--------------------

bash /stornext/Projects/GenomicsRnD/brown.d/zUMIs/zUMIs.sh -c -y \
    /stornext/Home/data/allstaff/b/brown.d/Projects/G000278_TurboCapSeq/config/zUMI/S000514/S000514_DCs_zUMI_gencode.yaml;

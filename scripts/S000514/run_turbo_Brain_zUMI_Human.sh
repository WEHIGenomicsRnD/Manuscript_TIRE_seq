#!/bin/bash
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=240G
#SBATCH --time=12:00:00
#SBATCH -e logs/zUMI_Hs-%j.err
#SBATCH -o logs/zUMI_Hs-%j.out
#SBATCH --job-name=zUMI_Brain-Hs

#------------- Set up combined fastq file for manuscript TIRE-Seq Brain runs
S446="/stornext/Projects/GenomicsRnD/brown.d/S000446/fastq/";
S514="/stornext/Projects/GenomicsRnD/brown.d/S000514/fastq/TIRE/";

# Have to do Brain and DCs separately as they are split over multiple plate barcodes
Brain="/vast/scratch/users/brown.d/BulkRNA_Manuscript/TIRE/Brain";
DCs="/vast/scratch/users/brown.d/BulkRNA_Manuscript/TIRE/DCs"
#--------------------

#-------- Link fastq files to data directory -----------
# ln -s ${S446}TURBO_Brain_TMZ_S1_R*_001.fastq.gz $Brain;
# ln -s ${S514}TIRE_Brain_TMZ_S2_R*_001.fastq.gz $Brain;
#-------------------------------

#-------- Combine fastq files in data directory -----------
# cat ${Brain}/TURBO_Brain_TMZ_S1_R1_001.fastq.gz \
#     ${S514}TIRE_Brain_TMZ_S2_R1_001.fastq.gz >\
#     ${Brain}/TIRE_combine_S02_R1_001.fastq.gz;
#     
# cat ${Brain}/TURBO_Brain_TMZ_S1_R2_001.fastq.gz \
#     ${S514}TIRE_Brain_TMZ_S2_R2_001.fastq.gz >\
#     ${Brain}/TIRE_combine_S02_R2_001.fastq.gz;
#-------------------------------

bash /stornext/Projects/GenomicsRnD/brown.d/zUMIs/zUMIs.sh -c -y \
    /stornext/Home/data/allstaff/b/brown.d/Projects/G000278_TurboCapSeq/config/zUMI/S000514/S000514_TMZ_zUMI-Hs.yaml;

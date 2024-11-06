#!/bin/bash
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=500G
#SBATCH --time=12:00:00
#SBATCH -e logs/zUMI_Mm-%j.err
#SBATCH -o logs/zUMI_Mm-%j.out
#SBATCH --job-name=zUMI_DCs-Mm

#------------- Set up combined fastq file for manuscript TIRE-Seq Brain runs
S442="/stornext/Projects/GenomicsRnD/brown.d/S000442/fastq/";
S446="/stornext/Projects/GenomicsRnD/brown.d/S000446/fastq/";
S514="/stornext/Projects/GenomicsRnD/brown.d/S000514/fastq/TIRE/";

# Have to do Brain and DCs separately as they are split over multiple plate barcodes
Brain="/vast/scratch/users/brown.d/BulkRNA_Manuscript/TIRE/Brain";
DCs="/vast/scratch/users/brown.d/BulkRNA_Manuscript/TIRE/DCs"
#--------------------

#-------- Link fastq files to data directory -----------
# ln -s ${S442}S000442_TURBO_S1_R*_001.fastq.gz $DCs;
# ln -s ${S446}TURBO_DCs_S1_R*_001.fastq.gz $DCs;
# ln -s ${S514}TIRE_DCs_S1_R*_001.fastq.gz $DCs;
#-------------------------------

#-------- Combine fastq files in data directory -----------
cat ${DCs}/S000442_TURBO_S1_R1_001.fastq.gz \
    ${DCs}/TIRE_DCs_S1_R1_001.fastq.gz \
    ${DCs}/TURBO_DCs_S1_R1_001.fastq.gz >\
    ${DCs}/TIRE_DCs_combine_S01_R1_001.fastq.gz;

cat ${DCs}/S000442_TURBO_S1_R2_001.fastq.gz \
    ${DCs}/TIRE_DCs_S1_R2_001.fastq.gz \
    ${DCs}/TURBO_DCs_S1_R2_001.fastq.gz >\
    ${DCs}/TIRE_DCs_combine_S01_R2_001.fastq.gz;
#-------------------------------

#---------- If need to generate mouse reference --------
# module load STAR/2.7.3a;
# #If fail try 2.7.1a
# 
# cd /vast/scratch/users/brown.d/S000514;
# cp /stornext/Projects/score/Indexes/refdata-gex-mm10-2020-A/fasta/genome.fa .
# 
# STAR --runMode genomeGenerate \
#     --runThreadN 12 \
#     --genomeDir mm10-2020-A_STAR5idx_noGTF \
#     --limitGenomeGenerateRAM 400000000000 \
#     --genomeFastaFiles genome.fa;
#     
# module unload STAR;
#----------------------

bash /stornext/Projects/GenomicsRnD/brown.d/zUMIs/zUMIs.sh -c -y \
    /stornext/Home/data/allstaff/b/brown.d/Projects/G000278_TurboCapSeq/config/zUMI/S000514/S000514_DCs_zUMI-Mm.yaml;

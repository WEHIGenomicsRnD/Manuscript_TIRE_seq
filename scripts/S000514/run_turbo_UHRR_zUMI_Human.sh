#!/bin/bash
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=240G
#SBATCH --time=47:00:00
#SBATCH -e logs/zUMI_Hs-%j.err
#SBATCH -o logs/zUMI_Hs-%j.out
#SBATCH --job-name=zUMI_U-Hs

# Link data to manuscript data dir
TIRE="/vast/scratch/users/brown.d/BulkRNA_Manuscript/TIRE";
#ln -s /stornext/Projects/GenomicsRnD/brown.d/S000514/fastq/TIRE/UHRR_Turbo_S11_R2_001.fastq.gz $TIRE;
#ln -s /stornext/Projects/GenomicsRnD/brown.d/S000514/fastq/TIRE/UHRR_Turbo_S11_R1_001.fastq.gz $TIRE;

bash /stornext/Projects/GenomicsRnD/brown.d/zUMIs/zUMIs.sh -c -y \
    /stornext/Home/data/allstaff/b/brown.d/Projects/G000278_TurboCapSeq/config/zUMI/S000514/S000514_UHRR_zUMI-Hs.yaml;

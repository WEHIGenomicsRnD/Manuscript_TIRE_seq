#!/bin/bash
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=500G
#SBATCH --time=24:00:00
#SBATCH -e logs/zUMI_Hs-%j.err
#SBATCH -o logs/zUMI_Hs-%j.out
#SBATCH --job-name=zUMI_Brain-Hs

STORNEXT="/stornext/Projects/GenomicsRnD/brown.d/S000521/fastq/TIRE/";
SCRATCH="/vast/scratch/users/brown.d/S000521/fastq/TIRE/";
zUMI="/vast/scratch/users/brown.d/S000521/zUMI_temp"

if [ ! -d "$zUMI" ]; then
    mkdir -p "$zUMI"
fi

# cat ${STORNEXT}TURBO_Brain_bat2_TMZ_GEX_PLT1_S16_I1_001.fastq.gz \
#     ${STORNEXT}TURBO_Brain_bat2_TMZ_GEX_PLT2_S17_I1_001.fastq.gz >\
#     ${SCRATCH}TURBO_Brain_bat2_TMZ_GEX_S1_I1_001.fastq.gz
#     
# cat ${STORNEXT}TURBO_Brain_bat2_TMZ_GEX_PLT1_S16_R1_001.fastq.gz \
#     ${STORNEXT}TURBO_Brain_bat2_TMZ_GEX_PLT2_S17_R1_001.fastq.gz >\
#     ${SCRATCH}TURBO_Brain_bat2_TMZ_GEX_S1_R1_001.fastq.gz
#     
# cat ${STORNEXT}TURBO_Brain_bat2_TMZ_GEX_PLT1_S16_R2_001.fastq.gz \
#     ${STORNEXT}TURBO_Brain_bat2_TMZ_GEX_PLT2_S17_R2_001.fastq.gz >\
#     ${SCRATCH}TURBO_Brain_bat2_TMZ_GEX_S1_R2_001.fastq.gz

bash /stornext/Projects/GenomicsRnD/brown.d/zUMIs/zUMIs.sh -c -y \
    /stornext/Home/data/allstaff/b/brown.d/Projects/G000278_TurboCapSeq/config/zUMI/S000521/S000521_TMZ_zUMI-Hs.yaml;

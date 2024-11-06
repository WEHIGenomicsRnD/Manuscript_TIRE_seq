#!/bin/bash
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=500G
#SBATCH --time=24:00:00
#SBATCH -e logs/zUMI_Mx-%j.err
#SBATCH -o logs/zUMI_Mx-%j.out
#SBATCH --job-name=zUMI_Brain-Mx

STORNEXT="/stornext/Projects/GenomicsRnD/brown.d/S000521/fastq/TIRE/";
SCRATCH="/vast/scratch/users/brown.d/S000521/fastq/TIRE/";
zUMI="/vast/scratch/users/brown.d/S000521/zUMI_temp"

if [ ! -d "$zUMI" ]; then
    mkdir -p "$zUMI"
fi

bash /stornext/Projects/GenomicsRnD/brown.d/zUMIs/zUMIs.sh -c -y \
    /stornext/Home/data/allstaff/b/brown.d/Projects/G000278_TurboCapSeq/config/zUMI/S000521/S000521_TMZ_zUMI-Mixed.yaml;

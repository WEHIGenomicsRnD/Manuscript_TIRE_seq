#!/bin/bash
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=500G
#SBATCH --time=24:00:00
#SBATCH -e logs/zUMI_ds-%j.err
#SBATCH -o logs/zUMI_ds-%j.out
#SBATCH --job-name=zUMI_dsTcell

STORNEXT="/stornext/Projects/GenomicsRnD/brown.d/S000553/fastq/TIRE/";
SCRATCH="/vast/scratch/users/brown.d/S000553/fastq/TIRE/";
zUMI="/vast/scratch/users/brown.d/S000553/zUMI_temp"

if [ ! -d "$zUMI" ]; then
    mkdir -p "$zUMI"
fi

bash /vast/projects/G000448_Protein_display/envs/zUMIs/zUMIs.sh -c -y \
    /stornext/Home/data/allstaff/b/brown.d/Projects/G000278_TurboCapSeq/config/zUMI/S000553/S000553_Tcell_downsample_zUMI-Hs.yaml;

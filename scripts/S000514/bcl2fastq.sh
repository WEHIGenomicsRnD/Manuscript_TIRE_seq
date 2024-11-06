#!/bin/bash
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=100G
#SBATCH --time=10:00:00
#SBATCH -e logs/bclfq-%j.err
#SBATCH -o logs/bclfq-%j.out
#SBATCH --job-name=bfq

module load bcl2fastq/2.20.0;

FLOWCELL_DIR="/vast/scratch/users/brown.d/S000514/240607_VH00914_421_AACJ5LNHV_8838_danielB_S514";
OUTPUT_DIR="/vast/scratch/users/brown.d/S000514/fastq";
INTEROP_DIR=${FLOWCELL_DIR}"/InterOp";
SAMPLE_SHEET_PATH="/stornext/Home/data/allstaff/b/brown.d/Projects/G000233_DRAC-Seq/metadata/S000514/S000514_bcl2fastq.csv";

bcl2fastq --create-fastq-for-index-reads \
 --no-lane-splitting \
 --minimum-trimmed-read-length=8 \
 --mask-short-adapter-reads=8 \
 --ignore-missing-positions \
 --ignore-missing-controls \
 --ignore-missing-filter \
 --ignore-missing-bcls \
 -r 6 -w 6 \
 -R ${FLOWCELL_DIR} \
 --output-dir=$OUTPUT_DIR \
 --interop-dir=$INTEROP_DIR \
 --sample-sheet=$SAMPLE_SHEET_PATH;

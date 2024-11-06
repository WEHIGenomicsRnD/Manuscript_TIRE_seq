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

module load bcl2fastq/2.20.0.422;

FLOWCELL_DIR="/stornext/Sysbio/data/ppilot/WEHITemp/240924_VH00915_500_AAG2WHGM5_9285_danielB_S553";
OUTPUT_DIR="/vast/scratch/users/brown.d/S000553/fastq";
INTEROP_DIR=${FLOWCELL_DIR}"/InterOp";
SAMPLE_SHEET_PATH="/stornext/Home/data/allstaff/b/brown.d/Projects/G000278_TurboCapSeq/metadata/S000553/S000553_bcl2fastq.csv";

bcl2fastq --no-lane-splitting \
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

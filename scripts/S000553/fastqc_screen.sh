#!/bin/bash
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=100G
#SBATCH --time=6:00:00
#SBATCH -e fqc-%j.err
#SBATCH -o fqc-%j.out
#SBATCH --job-name=fqc

module load fastqc/0.12.1;
module load micromamba/latest;
module load MultiQC/1.24

eval "$(conda shell.bash hook)";
conda activate /stornext/Projects/GenomicsRnD/brown.d/ngsQC;

#----  Setup if deleted by vast scratch
#conda create --prefix /stornext/Projects/GenomicsRnD/brown.d/ngsQC fastq-screen rseqc qualimap
#conda activate stornext/Projects/GenomicsRnD/brown.d/ngsQC
#conda install -c bioconda fastq-screen

RUN="S000553";
TIRE_DIR="/vast/scratch/users/brown.d/"${RUN}"/fastq/TIRE/";
OUTPUT_DIR="/vast/scratch/users/brown.d/"${RUN}"/fastq/Fastqc";
OUTPUT_DIR_FQS="/vast/scratch/users/brown.d/"${RUN}"/fastq/FastqScreen";
READ1=${TIRE_DIR}"/*R1_001.fastq.gz"

mkdir $OUTPUT_DIR;
mkdir $OUTPUT_DIR_FQS;

#---- FASTQC
fastqc --outdir $OUTPUT_DIR \
 --threads 12 \
 ${TIRE_DIR}*fastq.gz;

#---- FASTQ SCREEN

fastq_screen --conf /stornext/Projects/score/Indexes/fastq_screen/FastQ_Screen_Genomes/fastq_screen.conf \
    --outdir $OUTPUT_DIR_FQS \
    --threads 12 \
    $READ1;

#---- MULTI-QC

multiqc $OUTPUT_DIR $OUTPUT_DIR_FQS;

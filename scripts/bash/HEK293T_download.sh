#!/bin/bash
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=32G
#SBATCH --time=47:00:00
#SBATCH -e logs/sra-%j.err
#SBATCH -o logs/sra-%j.out
#SBATCH --job-name=sra

# Load the SRA Toolkit module if required by your system.
module load sra-toolkit/3.1.0

# GSM3476823	pcDNA1_S1_R1_001
# GSM3476824	pcDNA2_S2_R1_001
# GSM3476825	pcDNA3_S3_R1_001

# 100 ng of total RNA was used to generate RNA-Seq libraries using Illumina TruSeq stranded mRNA LT kit (Cat# RS-122-2101)
# 75 bp single reads, following manufactures protocol (Cat# 15048776 Rev.E). 
# NextSeq 500 sequencer using high output V2 reagents


# Define the numeric range for the runs
start=8200116
end=8200118

# Create directories for storing SRA files and FASTQ files
mkdir -p sra_files fastq_files

echo "Starting SRA download and conversion for paired-end data..."

# Loop through each accession number in the range
for i in $(seq $start $end); do
    acc="SRR${i}"
    echo "Processing $acc ..."
    
    # Download the SRA file using prefetch, saving it to the sra_files directory
    echo "Downloading $acc with prefetch..."
    prefetch --output-directory sra_files "$acc"
    if [ $? -ne 0 ]; then
         echo "Error: prefetch failed for $acc. Skipping..."
         continue
    fi
    
    # Define the SRA file path
    sra_file="sra_files/${acc}/${acc}.sra"
    sra_dir="sra_files/${acc}"
    
    # Check that the SRA file exists and is non-empty
    if [ ! -s "$sra_file" ]; then
        echo "Error: $sra_file not found or empty. Skipping $acc."
        continue
    fi
    
    # Convert the downloaded SRA file to FASTQ using fasterq-dump with the specified options.
    echo "Converting $acc to FASTQ..."
    fastq-dump --origfmt --defline-qual '+' \
    --split-files --split-3 --skip-technical \
    -v -O fastq_files "$sra_dir"
    if [ $? -ne 0 ]; then
         echo "Error: fasterq-dump failed for $acc. Skipping..."
         continue
    fi
    
    echo "Finished processing $acc."
done

# Gzip the fastqs
echo "Gzipping FASTQ files..."
pigz fastq_files/*.fastq

echo "All tasks completed successfully."

# wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR820/006/SRR8200116/SRR8200116.fastq.gz
# wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR820/007/SRR8200117/SRR8200117.fastq.gz
# wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR820/008/SRR8200118/SRR8200118.fastq.gz


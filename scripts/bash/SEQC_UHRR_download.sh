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
# For example:
module load sra-toolkit/3.1.0

# List of SRA run accessions
accessions=("SRR896663" "SRR896664" "SRR896665" "SRR896666")

# Create directories for storing SRA files and FASTQ files
# mkdir -p sra_files fastq_files

echo "Starting SRA download and conversion for paired-end data..."

# Loop through each accession
for acc in "${accessions[@]}"; do
    echo "Processing $acc ..."
    
    # Download the SRA file using prefetch, saving it to the sra_files directory
    echo "Downloading $acc with prefetch..."
    prefetch --output-directory sra_files "$acc"
    
    # Define the SRA file path
    sra_file="sra_files/${acc}.sra"
    
    # Check that the SRA file exists and is non-empty
    if [ ! -s "$sra_file" ]; then
        echo "Error: $sra_file not found or empty. Skipping $acc."
        continue
    fi
    
    # Convert the downloaded SRA file to FASTQ using fasterq-dump with the working options.
    echo "Converting $acc to FASTQ..."
    fasterq-dump --threads 4 --split-files --split-3 --skip-technical -v -O fastq_files "$sra_file"
    
    if [ $? -ne 0 ]; then
        echo "Error: fasterq-dump failed for $acc."
        # Optionally, exit or continue based on your error-handling strategy.
    fi
    
    echo "Finished processing $acc."
done

echo "Concatenating paired-end FASTQ files..."

# Concatenate all first-read FASTQ files into one combined file.
cat fastq_files/*_1.fastq > combined_R1.fastq

# Concatenate all second-read FASTQ files into one combined file.
cat fastq_files/*_2.fastq > combined_R2.fastq

# If there are any orphan reads from --split-3, you can optionally concatenate them as well.
if ls fastq_files/*_3.fastq 1> /dev/null 2>&1; then
    cat fastq_files/*_3.fastq > combined_orphan.fastq
fi

echo "All tasks completed successfully."

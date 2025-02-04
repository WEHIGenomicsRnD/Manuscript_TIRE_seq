#!/bin/bash
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=16G
#SBATCH --time=47:00:00
#SBATCH -e logs/sra-%j.err
#SBATCH -o logs/sra-%j.out
#SBATCH --job-name=sra

# Load the SRA Toolkit module if required by your system.
module load sra-toolkit/3.1.0

# Define the numeric range for the runs (SRR896663 to SRR896726)
start=896663
end=896726

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
    fasterq-dump --threads 4 --split-files --split-3 --skip-technical -v -O fastq_files "$sra_dir"
    if [ $? -ne 0 ]; then
         echo "Error: fasterq-dump failed for $acc. Skipping..."
         continue
    fi
    
    echo "Finished processing $acc."
done

echo "Concatenating paired-end FASTQ files..."

# Concatenate all first-read FASTQ files into one combined file.
cat fastq_files/*_1.fastq > combined_R1.fastq
if [ $? -ne 0 ]; then
    echo "Error: concatenation for combined_R1.fastq failed."
    exit 1
fi

# Concatenate all second-read FASTQ files into one combined file.
cat fastq_files/*_2.fastq > combined_R2.fastq
if [ $? -ne 0 ]; then
    echo "Error: concatenation for combined_R2.fastq failed."
    exit 1
fi

# Optionally, if there are orphan reads (from --split-3), concatenate them.
if ls fastq_files/*_3.fastq 1> /dev/null 2>&1; then
    cat fastq_files/*_3.fastq > combined_orphan.fastq
    if [ $? -ne 0 ]; then
         echo "Error: concatenation for combined_orphan.fastq failed."
         exit 1
    fi
fi

echo "Gzipping concatenated FASTQ files..."

gzip combined_R1.fastq
if [ $? -ne 0 ]; then
    echo "Error: gzip failed for combined_R1.fastq."
    exit 1
fi

gzip combined_R2.fastq
if [ $? -ne 0 ]; then
    echo "Error: gzip failed for combined_R2.fastq."
    exit 1
fi

if [ -f combined_orphan.fastq ]; then
    gzip combined_orphan.fastq
    if [ $? -ne 0 ]; then
         echo "Error: gzip failed for combined_orphan.fastq."
         exit 1
    fi
fi

echo "All tasks completed successfully."
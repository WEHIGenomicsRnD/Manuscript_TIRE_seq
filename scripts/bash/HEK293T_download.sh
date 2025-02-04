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
    fasterq-dump --threads 4 --split-files --split-3 --skip-technical -v -O fastq_files "$sra_dir"
    if [ $? -ne 0 ]; then
         echo "Error: fasterq-dump failed for $acc. Skipping..."
         continue
    fi
    
    echo "Finished processing $acc."
done

echo "Concatenating paired-end FASTQ files..."

# Concatenate all first-read FASTQ files into one combined file.
cat fastq_files/*_1.fastq > HEK_combined_R1.fastq
if [ $? -ne 0 ]; then
    echo "Error: concatenation for combined_R1.fastq failed."
    exit 1
fi

# Concatenate all second-read FASTQ files into one combined file.
cat fastq_files/*_2.fastq > HEK_combined_R2.fastq
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

gzip HEK_combined_R1.fastq
if [ $? -ne 0 ]; then
    echo "Error: gzip failed for combined_R1.fastq."
    exit 1
fi

gzip HEK_combined_R2.fastq
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
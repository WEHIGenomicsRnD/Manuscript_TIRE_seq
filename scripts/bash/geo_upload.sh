#!/bin/bash
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=32G
#SBATCH --time=47:00:00
#SBATCH -e logs/geo-%j.err
#SBATCH -o logs/geo-%j.out
#SBATCH --job-name=geo

cd /vast/projects/G000448_Protein_display/BulkRNA_Manuscript/TIRE/GEO_upload;

lftp ftp://geoftp:inAlwokhodAbnib5@ftp-private.ncbi.nlm.nih.gov
cd uploads/dbrown1@orcid_2fe5ees0
mirror -R ./
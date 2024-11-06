# Repository related to the TIRE-seq manuscript

## Overview
This repository contains the analysis pipeline and supporting data for the TIRE-seq (Transcriptomics with Integrated RNA Extraction sequencing) methodology.
TIRE-seq is a streamlined workflow that enables high-throughput RNA extraction and transcriptomic analysis for large-scale perturbation studies.

## Data
Processed data files are available in the *data/* directory

## Metadata
Sequencing run specific metadata is available in the metadata folder.  
It will be easier to extract experimental metadata from the SingleCellExperiment or DGEList object

```
colData(SingleCellExperiment)
DGEList$samples
```

## Analysis Scripts
The *notebooks/* directory contains R scripts for:

* Construction of SingleCellExperiment and DEGList objects
* Quality control
* Clustering
* Differential expression analysis

The order of analyses are prefixed by number

## License
This project is licensed under GNU GENERAL PUBLIC LICENSE
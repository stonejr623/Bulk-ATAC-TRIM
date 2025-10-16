# Bulk-ATAC-TRIM
Comparison of bulk ATAC-seq in BMDMs to determine patterns in trained immunity (TRIM) reprogramming

This repository demonstrates an end-to-end bulk ATAC-seq analysis workflow, using publicly available datasets, covering the major processing and analysis steps — from raw FASTQ files to differential peak calling and annotation.

The data used in this demonstration is sourced from GEO: SRP515812. 

This study investigates TRIM developed in response to various small molecule stimuli. Control and experimental chromatin accessibility are evaluated to determine stimulus-specific changes, then comparisons are done between stimuli. 

## Quality Control and Trimming
Quality control is performed on raw fastq files using the program fastqc

`bash fastqc.sh`

Trimming is performed using standard parameters on trimmomatic

`bash trimmomatic.sh`

After trimming, run quality control again to ensure the proper amount of surviving reads

##  Read Mapping
Reads are mapped to the reference genome GRCm39 using the program Bowtie2

`bash mapping.sh`

## Peak Calling
Find peaks in the aligned reads using the program MACS2

'bash peak_calling.sh`

## Peak Annotation
Genomic locations are annotations are added to peaks using the program HOMER

`bash peak_annotation.sh`

## Differential Analysis
Comparisons between control and experimental accessibility are done using DeSeq2

` Rscript deseq.R`

#!/bin/bash
#SBATCH --mem=300G
#SBATCH --cpus-per-task=8
#SBATCH -p defq

module load fastqc
module load multiqc
module load java
module load trimmomatic

#find path to trimmomatic.jar file
jar="/path/to/trimmomatic-0.39.jar"
adapters="/path/to/adapters/TruSeq3-PE"

#make output directories if necessary
mkdir -p trimmed_files reports

#read accession number file into a list
mapfile -t acclist < acclist.txt

#run quality control on all raw files
for acc in "${acclist[@]}"; do
        files = "./raw_fastq/{$acc}_*.fastq.gz"
        fastqc -o ./reports -t 8 $files
done
echo "All individual qc reports created."

#aggregate all output reports using multiqc
multiqc -n multiQC_report.html ./reports
echo "MultiQC report created"

#use trimmomatic to do standard trimming of reads
for acc in "${acclist[@]}"; do
        file1= "./raw_fastq/{$acc}_1.fastq.gz"
        file2= "./raw_fastq/{$acc}_2.fastq.gz"

        java -jar $jar PE \
                -threads 8 \
                -phred33 \
                $file1 $file2 \
                "{$acc}_R1_P.fastq.gz"  "{$acc}_R2_P.fastq.gz" \
                "{$acc}_R1_U.fastq.gz"  "{$acc}_R2_U.fastq.gz" \
                ILLUMINACLIP:/path/to/adapters/TruSeq3-PE.fa:2:30:10 \
                SLIDINGWINDOW:4:20 \
                MINLEN:36
done
echo "All files trimmed"

#move paired trimmed reads to keep, remove unpaired reads
mv *P.fastq.gz ./trimmed_files
rm *U.fastq.gz
echo "Files moved to directory: trimmed_files"

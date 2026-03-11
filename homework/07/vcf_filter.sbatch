#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-andrealitt       #specify the account to use
#SBATCH --job-name=vcf_filter                             # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of discrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              # number of cores to allocate
#SBATCH --time=0-00:30:00                 # Maximum job run time
#SBATCH --output=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/07/filter_hw/vcf_filter-%j.out
#SBATCH --error=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/07/filter_hw/vcf_filter-%j.err

# load module and activate mamba
module load Mamba/23.11.0-0
eval "$(conda shell.bash hook)"

# activate your vcftools environment
conda activate vcftools

# multi_sample.vcf.gz contains all genomic positions where at least one sample differs from the reference genome or other samples
# Each row reprsents a variant site (SNP or indel) and includes information such as genotype, read deapth, and quality for each read
# Differences among samples are reflected in their genotype calls at each site
# --remove-indv: I removed one indivdiual because they had 100% missing data across all sites
# --remove-indels: Removes insertions and deltions
# -- minQ 40 Keeps only variants with a Phred quality score of >= 40
# -- mac 2: Minor allele count: A 2 Removes singletons that are likely sequencing errors or miscalled bases
# max-missing-count 1: Allow at most one missing genotype so that at least 8 of the 9 individuals have data at each site
# Minimum Mean Depth: Includes only sites with mean depth values (over all included individuals) greater than or equal to this value
# --thin 50 keep only variants 50 bp apart to reduce biases of LD
# recode: Write a new VCF file contatining the filtered data to the output file specified below
 
# Run multiple VCF filtering tools
vcftools \
--gzvcf /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/07/multi_sample.vcf.gz \
--remove-indv /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/sort_hw/Diglossa_mystacalis_163119_sorted.bam \
--remove-indels \
--minQ 40 \
--mac 2 \
--max-missing-count 1 \
--min-meanDP 5 \
--thin 50 \
--recode \
--out /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/07/filter_hw/final

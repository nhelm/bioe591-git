#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-andrealitt       #specify the account to use
#SBATCH --job-name=vcf_filter_summary                             # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of discrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              # number of cores to allocate
#SBATCH --time=0-00:30:00                 # Maximum job run time
#SBATCH --output=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/07/filter_hw/vcf_summary_het-%j.out
#SBATCH --error=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/07/filter_hw/vcf_summary_het-%j.err

# load module and activate mamba
module load Mamba/23.11.0-0
eval "$(conda shell.bash hook)"

# activate your vcftools environment
conda activate vcftools

# Run VCF Summary Statistic: Heterozygosity
vcftools \
--vcf /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/07/filter_hw/final.recode.vcf \
--het \
--out /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/07/filter_hw/het_summary

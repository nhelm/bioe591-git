#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-andrealitt       #specify the account to use
#SBATCH --job-name=multi_vcf                             # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              # number of cores to allocate
#SBATCH --time=0-00:30:00                 # Maximum job run time
#SBATCH --output=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/06/hw_06/multi_vcf-%j.out
#SBATCH --error=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/06/hw_06/multi_vcf-%j.err

# load module and activate mamba
module load Mamba/23.11.0-0
eval "$(conda shell.bash hook)"

# activate your bcftools environment
conda activate bcftools

# run mpileup pipeline to call for ALL samples creating a multi_sample.vcf
bcftools mpileup \
-f /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/index/hemoglobin_references.fasta \
/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/sort_hw/*_sorted.bam \
| bcftools call -mv -Ov -o /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/06/hw_06/multi_sample.vcf

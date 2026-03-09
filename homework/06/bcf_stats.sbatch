#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-andrealitt       #specify the account to use
#SBATCH --job-name=bcf_stats                             # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              # number of cores to allocate
#SBATCH --time=0-00:30:00                 # Maximum job run time
#SBATCH --output=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/06/hw_06/bcf_stats-%j.out
#SBATCH --error=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/06/hw_06/bcf_stats-%j.err

# load module and activate mamba
module load Mamba/23.11.0-0
eval "$(conda shell.bash hook)"

# activate your bcftools environment
conda activate bcftools

# run grep to view bcftools summary stats of .vcf file
bcftools stats /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/06/hw_06/multi_sample.vcf | grep ^SN > /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/06/hw_06/multi_sample_stats.txt

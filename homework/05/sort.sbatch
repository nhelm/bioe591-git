#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-andrealitt       #specify the account to use
#SBATCH --job-name=sort                             # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              # number of cores to allocate
#SBATCH --time=0-00:30:00                 # Maximum job run time
#SBATCH --output=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/sort_hw/sort-%j.out
#SBATCH --error=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/sort_hw/sort-%j.err

# load module and activate mamba
module load Mamba/23.11.0-0
eval "$(conda shell.bash hook)"

# activate your align environment
conda activate align

# run bam sort
READDIR="/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/align_hw"
OUTDIR="/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/sort_hw"


for SAM in ${READDIR}/*.sam
do
    SAMPLE=$(basename ${SAM} .sam)

    samtools view -b ${SAM} | samtools sort -o ${OUTDIR}/${SAMPLE}_sorted.bam
    samtools index ${OUTDIR}/${SAMPLE}_sorted.bam
done

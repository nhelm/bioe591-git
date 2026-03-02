#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-andrealitt       #specify the account to use
#SBATCH --job-name=align                             # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=4              # number of cores to allocate
#SBATCH --time=0-00:30:00                 # Maximum job run time
#SBATCH --output=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/align_hw/align-%j.out
#SBATCH --error=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/align_hw/align-%j.err

# load module and activate mamba
module load Mamba/23.11.0-0
eval "$(conda shell.bash hook)"

# activate your align environment
conda activate align

# run align
REF="/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/index/hemoglobin_references.fasta"
READDIR="/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/04/trimmed_reads/04_homework_helmstetter"
OUTDIR="/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/align_hw"


for R1 in ${READDIR}/*_R1_001.fastq.gz
do
    SAMPLE=$(basename ${R1} _R1_001.fastq.gz)
    R2=${READDIR}/${SAMPLE}_R2_001.fastq.gz

    bwa mem -t ${SLURM_CPUS_PER_TASK} \
        ${REF} \
        ${R1} \
        ${R2} \
        > ${OUTDIR}/${SAMPLE}.sam

done

#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-andrealitt        #specify the account to use
#SBATCH --job-name=04_homework_helmstetter                             # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              # number of cores to allocate
#SBATCH --time=0-00:30:00                 # Maximum job run time
#SBATCH --output=04_hw_helm-%j.out
#SBATCH --error=04_hw_helm-%j.err

# load module and activate mamba
module load Mamba/23.11.0-0
eval "$(conda shell.bash hook)"

# activate your fastp environment
conda activate fastp

# Initiate a loop that iterates over R1 files, then infers the corresponding R2 filename by substituting the name, and processes each R1/R2 as a paired-end sample. The loop does not search for the R2s, it assumes they exist.
for r1 in ~/bioe-591-genomics/course-materials/data/raw_reads/Diglossa_mystacalis/*_R1_001.fastq.gz; do 
  r2="${r1/_R1_001.fastq.gz/_R2_001.fastq.gz}"

# Extract the sample ID by removing the path and R1 suffix (see below). This is done so you have a consistent naming scheme (see below). 
  sample=$(basename "$r1" | sed 's/_R1_001\.fastq\.gz$//')

# Run fastp on paired end reads, "r1" and "r2" that were defined above. Outputs for each file (R1 and R2 trimmed reads, html, and json files are named  with the "sample" name defined above.
  fastp -i "$r1" -I "$r2" \
    -o ~/bioe-591-genomics/students/Helmstetter/hw_output/04/trimmed_reads/04_homework_helmstetter/${sample}_R1_001.fastq.gz \
    -O ~/bioe-591-genomics/students/Helmstetter/hw_output/04/trimmed_reads/04_homework_helmstetter/${sample}_R2_001.fastq.gz \
    -h ~/bioe-591-genomics/students/Helmstetter/hw_output/04/trimmed_reads/04_homework_helmstetter/${sample}.fastp.html \
    -j ~/bioe-591-genomics/students/Helmstetter/hw_output/04/trimmed_reads/04_homework_helmstetter/${sample}.fastp.json 
done


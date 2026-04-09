#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-andrealitt       #specify the account to use
#SBATCH --job-name=admixture                             # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=4              # number of cores to allocate
#SBATCH --time=0-00:30:00                 # Maximum job run time
#SBATCH --output=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/10/log/admix-%j.out
#SBATCH --error=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/10/log/admix-%j.err

module load Mamba/23.11.0-0;
eval "$(conda shell.bash hook)"
conda activate admixture

plink2 \
  --vcf /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/10/data/IDGS.recode.vcf \
  --allow-extra-chr \
  --make-bed \
  --out /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/10/output/IDGS

# This next part takes the chromosomes names and makes them integers because admixture expects numeric chromosomes
awk 'BEGIN{OFS="\t"} {if(!($1 in a)) a[$1]=++i; $1=a[$1]; print}' \
/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/10/output/IDGS.bim \
> /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/10/output/IDGS.int.bim

cp /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/10/output/IDGS.bed \
   /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/10/output/IDGS.int.bed

cp /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/10/output/IDGS.fam \
   /home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/10/output/IDGS.int.fam

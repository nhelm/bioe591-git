#!/bin/bash
#SBATCH --account=priority-andrealitt        
#SBATCH --job-name=ngsrelate                            
#SBATCH --partition=priority              
#SBATCH --nodes=1                       
#SBATCH --ntasks-per-node=1             
#SBATCH --cpus-per-task=1              
#SBATCH --time=0-10:00:00                 
#SBATCH --output=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/09/log/ngsrelate-%j.out
#SBATCH --error=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/09/log/ngsrelate-%j.err

module load Mamba/23.11.0-0;
eval "$(conda shell.bash hook)"

conda activate ngsrelate

# define base path (keeps it clean)
BASE=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/09/data
FILE=Koala_MaxMissing10.recode

# gzip the vcf
bcftools view -Oz -o $BASE/${FILE}.vcf.gz $BASE/${FILE}.vcf

# index the vcf
tabix -p vcf $BASE/${FILE}.vcf.gz

# generate sample ID file
bcftools query -l $BASE/${FILE}.vcf.gz > $BASE/${FILE}.sample_ids.txt

# run ngsRelate
ngsRelate \
  -h $BASE/${FILE}.vcf.gz \
  -T GT \
  -c 1 \
  -O $BASE/${FILE}.ngsrelate.out \
  -z $BASE/${FILE}.sample_ids.txt

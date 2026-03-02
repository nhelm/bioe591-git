#!/bin/bash
#SBATCH --account=priority-andrealitt
#SBATCH --job-name=markdown
#SBATCH --partition=priority
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-00:05:00
#SBATCH --output=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/markdown_results/mrkdwn-%j.out
#SBATCH --error=/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/markdown_results/mrkdwn-%j.err

module load Mamba/23.11.0-0
eval "$(conda shell.bash hook)"
conda activate align

READDIR="/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/stat_hw"
OUTDIR="/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/05/markdown_results"

STATS_AVG=$(
  for f in ${READDIR}/*_stats.txt
  do
    sed -n '7p' "$f" | awk -F'[()%]' '{print $2}'
  done | awk '{sum+=$1; n++} END {if(n>0) print sum/n; else print "NA"}'
)

DEPTH_AVG=$(
  cat ${READDIR}/*_depth.txt | awk '{sum+=$1; n++} END {if(n>0) print sum/n; else print "NA"}'
)

cat > "${OUTDIR}/05_homework_helmstetter.md" <<EOF
# Nolan Helmstetter HW 05  
03/02/2026  

The average percentage of reads mapped was ${STATS_AVG}%.  

The average depth of coverage was ${DEPTH_AVG}.  
EOF

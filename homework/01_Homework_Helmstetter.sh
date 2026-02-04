cd ~/Desktop/BIOE591_Genomics/HW1/
curl -L -O https://raw.githubusercontent.com/elinck/genomics_eco_con/main/data/week_1.tar.gz # download a resource at a url
tar -xzf week_1.tar.gz # this command unzips a "tarball"
cd week_1 # enter the data directory

mkdir fastq fasta metadata # Make three new directories

mv *.gz fastq/ # move .gz files to fastq folder
mv *.fasta fasta/ # move .fasta files to fasta folder
mv *.csv metadata/ # move .csv files to metadata folder

# Count the number of files in each directory
ls -1 fastq/ | wc -l # list files in a directory, 1 per line; send output to wc function, count lines
ls -1 fasta/ | wc -l
ls -1 metadata/ | wc -l

ls week_1 # check to see what's in this folder now

echo "DONE!"
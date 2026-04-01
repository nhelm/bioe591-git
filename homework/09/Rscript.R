install.packages("related", repos="http://R-Forge.R-project.org")
install.packages("adegenet")
install.packages("vcfR")
install.packages("pegas")

library(related)
library(adegenet)
library(vcfR)
library(pegas)
library(tidyr)
library(reshape2)
library(ggplot2)
library(tibble)

# View Directory
getwd()

# Load VCF.recode created using ngsrelate.sbatch
# On Tempest /home/g27n141/bioe-591-genomics/students/Helmstetter/scripts/ngsrelate.sbatch

vcf <- read.vcfR(file = "/home/g27n141//bioe-591-genomics/students/Helmstetter/hw_output/09/data/Koala_MaxMissing10.recode.vcf", verbose = TRUE)
vcf
vcf@meta
vcf@fix
vcf@gt

# Create genind object
genind_obj <- vcfR2genind(vcf)

genind_obj
head(genind_obj@tab)
summary(genind_obj@loc.n.all)

# Calculate observed and expected heterozygoisty at each locus (SNP).
# Each locus can be one of two nucleotides, based on the reference you evaluate how many indidviduals
# are homozygous for the reference versis alternative and how many are heterozygous for that.
af_summary <- adegenet::summary(genind_obj) # here it is important to specify which package's summary function is used!
af_summary # view object
H_o <- af_summary$Hobs
H_e <- af_summary$Hexp
head(H_o)
head(H_e)
het_df<-data.frame(locus=names(H_o), H_o=H_o, H_e = H_e)
head(het_df)

# Calculate inbreeding coefficient F_IS, 1 -Ho/He
Fis_per_locus <- 1 - (H_o / H_e)
Fis_per_locus
mean(Fis_per_locus, na.rm = TRUE)

# Calculate whether loci are in HWE using pegas
loci_obj <- genind2loci(genind_obj)
hwe_results <- pegas::hw.test(loci_obj, B = 100)
head(hwe_results)

# Isolate significant deviations from HWE by filtering p-value to a threshold
hwe_results %>% as.tibble() %>% filter(Pr.exact<0.05)

##################
# Calculating Kinship coefficients
##################

# Related needs it's own custom data format.

gt_filtered <- vcfR::extract.gt(vcf, element = "GT")

# Perform a tedious set of operations to cover these data—presented as character 
# strings—into a dataframe of integers:

# sample ids
sample_ids <- colnames(gt_filtered)

gt_to_alleles <- function(gt_vector) {
  # split "0/1" or "0|1" into two integer alleles, returning a 2-column matrix (samples x 2 alleles)
  allele1 <- integer(length(gt_vector))
  allele2 <- integer(length(gt_vector))
  
  for (i in seq_along(gt_vector)) {
    g <- gt_vector[i]
    if (is.na(g) || g %in% c("./.", ".", "./", "/.")) {
      allele1[i] <- 0
      allele2[i] <- 0
    } else {
      parts <- as.integer(strsplit(g, "[/|]")[[1]])
      allele1[i] <- parts[1] + 1L    # shift: 0->1 (ref), 1->2 (alt)
      allele2[i] <- parts[2] + 1L
    }
  }
  cbind(allele1, allele2)
}

allele_list <- vector("list", nrow(gt_filtered))

for (v in seq_len(nrow(gt_filtered))) {
  allele_list[[v]] <- gt_to_alleles(gt_filtered[v, ])
}

# combine: each element is (n_samples x 2); bind column-wise
allele_matrix <- do.call(cbind, allele_list)

# add individual IDs as the first column
coancestry_input <- data.frame(IndID = sample_ids, allele_matrix,
                               stringsAsFactors = FALSE)

# column names: IndID, L1_a, L1_b, L2_a, L2_b, ...
locus_names <- paste0(rep(paste0("L", seq_len(nrow(gt_filtered))),
                          each = 2),
                      rep(c("_a", "_b"), nrow(gt_filtered)))
colnames(coancestry_input) <- c("IndID", locus_names)

# View what you created: You end up with each individual (IndID), and whether they are homozygous or heterozygous compared 
# the reference. 1/1 is homozy for reference, 1/2 heterozygous with 1 reference allele, 2/2 homozygous for alternative allele
coancestry_input[1:5, 1:7]

?related::coancestry()

# Calculate several related and inbreeding coefficients

kin_results <- related::coancestry(
  genotype.data = coancestry_input,
  wang          = 1,      # 1 = compute; 0 = skip
  dyadml        = 1,
  quellergt     = 1
)

# View Results
kin_results$relatedness

#save.image("/home/g27n141/bioe-591-genomics/students/Helmstetter/hw_output/09/r_env.RData")



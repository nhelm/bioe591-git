# VCF Filtering Discussion

## Filtering Choices

`--remove-indv` 
This filter removed a specific individual from the dataset that had 100% missing genotype data across all loci in the VCF.

`--remove-indels` 
This filter removed variants caused by insertions and deletions. Consequently, only SNPs remain in the dataset for further analysis.

`--minQ 40` 
This filter removes variants (SNPs) with a Phred quality score lower than 40. This is fairly conservative based on the literature (Ewing & Green 1998).

`--mac 2` 
This filter removed singletons by retaining only loci where the minor allele count (mac) was $\ge 2$ across all individuals. This was done to avoid variants observed in only a single individual, which are likely the result of sequencing errors. 

`--max-missing-count 1` 
This filter retains only loci where at most 1 individual has a missing genotype. While somewhat conservative, this enables us to have a more robust sample size across all loci.

`--min-meanDP 5` 
This filter retains only loci where the mean read depth across all individuals was $\ge 5$.

`--thin 50` 
This filter retained only SNPs that were > 50 base pairs apart, reducing non-independence among nearby SNPs (i.e., linkage disequilibrium).

## Summary Statistic: Heterozygosity

I ran the `--het` function to explore heterozygosity among individuals (Table 1). Because my sample size was
small ($n = 8$), summary statistics should be interpreted cautiously. However, most individuals showed
relatively high levels of heterozygosity across SNPs, and inbreeding coefficients (column F in table 1) were
close to zero, suggesting little evidence of inbreeding. 

**Table 1.** Heterozygosity among *Diglossa mystacalis* individuals estimated using 65 SNPs derived from reduced-representation exon capture data targeting hemoglobin genes.
| INDV | O(HOM) | E(HOM) | N_SITES | F |
|------|--------|--------|--------|--------|
| Diglossa_mystacalis_163116 | 47 | 41.7 | 65 | 0.22747 |
| Diglossa_mystacalis_163980 | 40 | 41.7 | 65 | -0.07296 |
| Diglossa_mystacalis_167557 | 40 | 41.7 | 65 | -0.07296 |
| Diglossa_mystacalis_167858 | 40 | 41.7 | 65 | -0.07296 |
| Diglossa_mystacalis_171226 | 42 | 41.7 | 65 | 0.01288 |
| Diglossa_mystacalis_171311 | 39 | 41.7 | 65 | -0.11588 |
| Diglossa_mystacalis_220326 | 37 | 41.7 | 65 | -0.20172 |
| Diglossa_mystacalis_220327 | 45 | 41.7 | 65 | 0.14163 |


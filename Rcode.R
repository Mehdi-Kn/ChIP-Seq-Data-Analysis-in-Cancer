# Load necessary libraries
# 'DiffBind' is used for analyzing differential binding in ChIP-Seq data.
# 'ChIPseeker' helps annotate these binding sites with genomic features.
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(c("DiffBind", "csaw", "ChIPseeker"))

library(DiffBind)
library(csaw)
library(ChIPseeker)

# Load ChIP-Seq data from a sample sheet
# The sampleSheet.csv should contain all relevant information about your samples, such as the condition (e.g., cancer vs. normal).
samples <- dba(sampleSheet="samplesheet.csv")

# Count reads in peaks
# This step counts the number of sequencing reads that fall within predefined genomic regions (peaks).
samples <- dba.count(samples)

# Set up contrasts for differential binding analysis
# We are setting up a contrast to compare binding between cancer and normal samples.
samples <- dba.contrast(samples, categories=DBA_CONDITION)

# Perform differential binding analysis
# This analysis identifies regions of the genome where protein binding differs significantly between conditions.
samples <- dba.analyze(samples)

# Annotate peaks with genomic features
# Annotation provides context to the identified peaks, linking them to genes or other functional genomic elements.
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene # Make sure to use the correct TxDb object for your organism and genome version
peakAnno <- annotatePeak(dba.peakset(samples), TxDb=txdb)

# Visualize the peak annotations
# This plot shows the distribution of peaks relative to genomic features like promoters and gene bodies.
plotPeakAnnotation(peakAnno)

# Save the annotated peaks
# Saving the results allows for further downstream analysis or for use in publications.
write.csv(as.data.frame(peakAnno), file = "Annotated_Peaks.csv")

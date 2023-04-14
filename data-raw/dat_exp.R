## code to prepare `DATASET` dataset goes here
library(tidyverse)

library(AnnotationDbi)
library(org.Hs.eg.db)



# This is taken from cBioportal WebSite
stable_id_table <- structure(list(datatype = c("CONTINUOUS", "Z-SCORE", "Z-SCORE",
                            "Z-SCORE", "CONTINUOUS", "CONTINUOUS", "Z-SCORE", "CONTINUOUS",
                            "Z-SCORE", "Z-SCORE", "CONTINUOUS", "DISCRETE", "Z-SCORE", "CONTINUOUS",
                            "Z-SCORE"), stable_id = c("mrna_U133", "mrna_U133_Zscores", "rna_seq_mrna_median_Zscores",
                                                      "mrna_median_Zscores", "rna_seq_mrna", "rna_seq_v2_mrna", "rna_seq_v2_mrna_median_Zscores",
                                                      "mirna", "mirna_median_Zscores", "mrna_merged_median_Zscores",
                                                      "mrna", "mrna_outliers", "mrna_zbynorm", "rna_seq_mrna_capture",
                                                      "rna_seq_mrna_capture_Zscores"), description = c("Affymetrix U133 Array",
                                                                                                       "Affymetrix U133 Array", "RNA-seq data", "mRNA data", "RNA-seq data",
                                                                                                       "RNA-seq data", "RNA-seq data", "MicroRNA data", "MicroRNA data",
                                                                                                       "?", "mRNA data", "mRNA data of outliers", "?", "data from Roche mRNA Capture Kit",
                                                                                                       "data from Roche mRNA Capture Kit")), class = c("tbl_df", "tbl",
                                                                                                                                                       "data.frame"), row.names = c(NA, -15L))

# Just modified some data and generated randoms counts.
genes <-
  c(
    "CAMK1",
    "PANX2",
    "P2RX1",
    "EPB41L3",
    "METRN",
    "PCP2",
    "COQ7-DT",
    "ZNF823",
    "PHF7",
    "BCAR1P2",
    "NBPF11",
    "LOC729998",
    "HINT3",
    "ATP2B3",
    "MUC1",
    "SLC35E1",
    "ALOX12B",
    "COL6A2",
    "TMEM109",
    "HYOU1",
    "RBBP4P3",
    "FIGNL1",
    "PDS5A",
    "STAG3L4",
    "LINC01337",
    "STXBP5-AS1",
    "KLHL25",
    "SLC1A6",
    "DHX58",
    "NOTCH4",
    "TRBJ2-2",
    "PGAP3",
    "SCNN1A",
    "UNC13B",
    "CSH2",
    "FGF20",
    "LOC100996696",
    "MYLK4",
    "GPS2P1",
    "IL17REL",
    "DPP3",
    "CEBPZ",
    "INSL5",
    "SETDB2",
    "SPTBN1",
    "ARSA",
    "ARRDC1-AS1",
    "LIMS2",
    "HTR3A",
    "LOC105372180",
    "NSMF",
    "MAT1A",
    "C11orf16",
    "PDIA2",
    "LINC00847",
    "RPL10AP13",
    "CARMIL2",
    "TRAV24",
    "ACHE",
    "RTF1",
    "EIF4G1",
    "OR51M1",
    "ATG2B",
    "USP6NL",
    "FAM87B",
    "POLR1F",
    "LINC02620",
    "SLC25A40",
    "FZD3",
    "PRNCR1",
    "SLC25A28",
    "USP31",
    "ZNF592",
    "LRFN5",
    "CNP",
    "ZNF75D",
    "CCSAP",
    "LOC102724023",
    "BMP4",
    "GPS2P2",
    "CTSC",
    "SMIM10L2B",
    "SOCS3",
    "SFXN2",
    "RPL34P23",
    "MOB4",
    "HIKESHI",
    "AVP",
    "MAP2K4",
    "PIN1",
    "HNRNPF",
    "PCYOX1L",
    "HACD1",
    "BRCA2",
    "TVP23A",
    "MMRN1",
    "TMEM35A",
    "LOC100996384",
    "ATP6V0D2",
    "HTR6"
  )


df_samples <-
  structure(
    list(
      PATIENT_ID = c(
        "A",
        "A",
        "A",
        "A",
        "A",
        "A",
        "B",
        "B",
        "B",
        "B",
        "C",
        "C",
        "C",
        "C",
        "D",
        "D",
        "D",
        "D",
        "E",
        "E",
        "E",
        "E",
        "E",
        "E",
        "F",
        "F",
        "F",
        "F"
      ),
      SAMPLE_ID = c(
        "A_48h_VEH",
        "A_48h_VEH",
        "A_48h_DRUG_A",
        "A_48h_DRUG_A",
        "A_48h_DRUG_B",
        "A_48h_DRUG_B",
        "B_48h_VEH",
        "B_48h_VEH",
        "B_48h_DRUG_A",
        "B_48h_DRUG_A",
        "C_48h_VEH",
        "C_48h_VEH",
        "C_48h_DRUG_A",
        "C_48h_DRUG_A",
        "D_48h_VEH",
        "D_48h_VEH",
        "D_48h_DRUG_A",
        "D_48h_DRUG_A",
        "E_48h_VEH",
        "E_48h_VEH",
        "E_48h_DRUG_A",
        "E_48h_DRUG_A",
        "E_48h_DRUG_B",
        "E_48h_DRUG_B",
        "F_48h_VEH",
        "F_48h_VEH",
        "F_48h_DRUG_A",
        "F_48h_DRUG_A"
      ),
      CANCER_TYPE = c(
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma",
        "Lymphoma"
      ),
      CANCER_TYPE_DETAILED = c(
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma",
        "Peripheral T-cell Lymphoma"
      )
    ),
    class = "data.frame",
    row.names = c(NA, -28L)
  )

df_samples <- df_samples |>
  separate(SAMPLE_ID, into = c("CELLLINE", "TIME_TREAT", "TREAT"), remove = FALSE, extra = "merge") |>
  dplyr::select(c("SAMPLE_ID", "PATIENT_ID", "CELLLINE", "TIME_TREAT", "TREAT",
           "CANCER_TYPE", "CANCER_TYPE_DETAILED"))


counts <- matrix(ceiling(rnorm(length(df_samples$SAMPLE_ID) * length(genes), mean = 1000, sd = 700)),
  ncol = length(df_samples$SAMPLE_ID), nrow = length(genes)
)


colnames(counts) <- df_samples$SAMPLE_ID


entrez_genes <- mapIds(org.Hs.eg.db,
                       keys =  genes,
                       keytype = "SYMBOL",
                       column = "ENTREZID",
                       columns =  c("SYMBOL","ENTREZID"),
                       multiVals = "first"
)

entrez_genes_df <- data.frame( Hugo_Symbol = names(entrez_genes), Entrez_Gene_Id = entrez_genes)

df_expr <- cbind(entrez_genes_df, counts)

row.names(df_expr) <-  NULL

df_samples_datatype <- tribble(
  ~var_int, ~description, ~datatype, ~attr_priority, ~attr_name,
  "Sample ID", "sample id", "STRING", 1, "SAMPLE_ID",
  "Patient ID", "patient id", "STRING", 1, "PATIENT_ID",
  "Cancer Type", "cancer type", "STRING", 1, "CANCER_TYPE",
  "Cancer Type Detailed", "cancer type detailed", "STRING", 1, "CANCER_TYPE_DETAILED",
  "Cellline", "cellline id", "STRING", 1, "CELLLINE",
  "Time Treat", "time of administration of treatment", "STRING", 1, "TIME_TREAT",
  "Treatment", "drug admnistered", "STRING", 1, "TREAT"
)

df_patients_datatype <-     tribble(
  ~var_int, ~description, ~datatype, ~attr_priority, ~attr_name,
  "Patient ID", "patient id", "STRING", 1, "PATIENT_ID",
  "Cellline", "cellline id", "STRING", 1, "CELLLINE"
)

usethis::use_data(df_samples, stable_id_table, df_expr, df_patients_datatype, df_samples_datatype, internal = FALSE, overwrite = TRUE)




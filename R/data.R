#' Stable Id Table
#'
#' For historical reasons, cBioPortal expects the stable_id to be one of those listed in the following static set.
#' The stable_id for continuous RNA-seq data has two options: rna_seq_mrna or rna_seq_v2_mrna.
#' These options were added to distinguish between two different TCGA pipelines, which perform different types of normalization (RPKM and RSEM).
#' However, for custom datasets either one of these stable_id can be chosen.
#' @source <https://docs.cbioportal.org/file-formats/#supported-stable_id-values-for-mrna_expression>
"stable_id_table"


#' counts
#'
#' Am example of count matrix with 100 genes and 28 samples. Counts have been generated randomly.
"counts"

#' df_samples
#'
#' An example dataframe of sample info related to the `counts` matrix.
"df_samples"

#' df_samples_datatype
#'
#' An example dataframe of the sample datatype to be used
"df_samples_datatype"

#' df_patients_datatype
#'
#' An example dataframe of the sample datatype to be used
"df_patients_datatype"


#' Stable Id Table
#'
#' For historical reasons, cBioPortal expects the stable_id to be one of those listed in the following static set.
#' The stable_id for continuous RNA-seq data has two options: rna_seq_mrna or rna_seq_v2_mrna.
#' These options were added to distinguish between two different TCGA pipelines, which perform different types of normalization (RPKM and RSEM).
#' However, for custom datasets either one of these stable_id can be chosen.
#' @source <https://docs.cbioportal.org/file-formats/#supported-stable_id-values-for-mrna_expression>
"stable_id_table"
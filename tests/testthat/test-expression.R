library(cbiopourer)
library(tidyverse)
library(fs)
data("df_samples_datatype")
data("df_samples")
data("df_patients_datatype")
data("df_expr")
df_patients <- df_samples[, c("PATIENT_ID", "CELLLINE")]

cancer_study_identifier <- "ptcls_example_2023"

dir_out <- tempdir()

create_expression(
  folder_path = dir_out,
  cancer_study_identifier = cancer_study_identifier,
  genetic_alteration_type = "MRNA_EXPRESSION",
  datatype = "CONTINUOUS",
  stable_id = "rna_seq_mrna",
  source_stable_id = NULL,
  show_profile_in_analysis_tab = FALSE,
  profile_name = "mRNA expression",
  profile_description = "Expression levels",
  df_expr = df_expr,
  gene_panel = NULL
)


expected_meta_expression <- read.delim(path(dir_out, "meta_expression.txt"), header = FALSE)
expected_data_expression <- read.delim(path(dir_out, "data_expression.txt"))


test_that("clinical sample tabs", {
  expect_snapshot(expected_meta_expression)
  expect_snapshot(expected_data_expression)
})

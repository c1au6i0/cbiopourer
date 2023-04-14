library(cbiopourer)
library(testthat)
data("df_samples_datatype")
data("df_samples")
data("df_expr")


test_that("check_clinical", {
  expect_message(check_clinical(clinical_dat = df_samples,
                                clinical_meta = df_samples_datatype,
                                datatype = "SAMPLE_ATTRIBUTES"), "data checked")

  expect_error(check_clinical(clinical_dat = df_samples,
                                clinical_meta = df_samples_datatype,
                                datatype = "ciao"))
  expect_error(check_clinical(clinical_dat = df_samples[, -1],
                              clinical_meta = df_samples_datatype,
                              datatype = "SAMPLE_ATTRIBUTES"), "not present")

})

test_that("check_expr", {
  expect_silent(check_expr(df_expr))
  expect_error(check_expr(df_expr$A_48h_VEH), "data.frame")
  expect_error(check_expr(df_expr[, !names(df_expr) %in%  c("Hugo_Symbol", "Entrez_Gene_Id")]), "Hugo_Symbol")

})




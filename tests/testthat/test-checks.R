library(cbiopourer)
data("df_samples_datatype")
data("df_samples")
data("counts")

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
  expect_silent(check_expr(counts))
  expect_error(check_expr(as.data.frame(counts)), "matrix")

})

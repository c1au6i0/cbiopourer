library(cbiopourer)
data("df_samples_datatype")
data("df_samples")

test_that("check_clinical", {
  expect_message(check_clinical(clinical_dat = df_samples,
                                clinical_meta = df_samples_datatype,
                                datatype = "SAMPLE_ATTRIBUTES"), "data checked")

  expect_error(check_clinical(clinical_dat = df_samples,
                                clinical_meta = df_samples_datatype,
                                datatype = "ciao"))
})



# check_clinical(clinical_dat = df_samples,
#                clinical_meta = df_samples_datatype,
#                datatype = "SAMPLE_ATTRIBUTES")
# df_samples_datatype
# df_samples
# check_clinical(clinical_dat = df_samples,
#                clinical_meta = df_samples_datatype,
#                datatype = "ciao")

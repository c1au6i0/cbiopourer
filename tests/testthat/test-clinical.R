library(cbiopourer)
library(fs)
data("df_samples_datatype")
data("df_samples")
data("df_patients_datatype")
df_patients <- df_samples[, c("PATIENT_ID", "CELLLINE")]

cancer_study_identifier <- "ptcls_example_2023"

dir_out <- tempdir()

# @@@@@@@@@@@@@@@@
# Clinical ----
# @@@@@@@@@@@@@@@@

# @@@@@@@@@@@@@@@@
#  ___SAMPLE ----
# @@@@@@@@@@@@@@@@

suppressMessages(
  create_clinical(
    folder_path = dir_out,
    cancer_study_identifier = cancer_study_identifier,
    datatype = "SAMPLE_ATTRIBUTES",
    clinical_meta = df_samples_datatype,
    clinical_dat = df_samples)
)

expected_meta_clinical_sample <-read.delim(path(dir_out, "meta_clinical_sample.txt"))
expected_data_clinical_sample <- read.delim(path(dir_out, "data_clinical_sample.txt"))


test_that("clinical sample tabs", {
  expect_snapshot(expected_meta_clinical_sample)
  expect_snapshot(expected_data_clinical_sample)
})

# @@@@@@@@@@@@@@@@
#  ___PATIENT ----
# @@@@@@@@@@@@@@@@

suppressMessages(
  create_clinical(
    folder_path = dir_out,
    cancer_study_identifier = cancer_study_identifier,
    datatype = "PATIENT_ATTRIBUTES",
    clinical_meta = df_patients_datatype,
    clinical_dat = df_patients)
)

expected_meta_clinical_patient <- read.delim(path(dir_out, "meta_clinical_patient.txt"), header = FALSE)
expected_data_clinical_patient <- read.delim(path(dir_out, "data_clinical_patient.txt"), header = FALSE)

test_that("clinical patient tabs", {
  expect_snapshot(expected_meta_clinical_patient)
  expect_snapshot(expected_data_clinical_patient)
})

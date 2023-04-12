library(cbiopourer)
library(fs)
data("df_samples_datatype")
data("df_samples")
data("counts")


cancer_study_identifier <- "ptcls_example_2023"

dir_out <- tempdir()

suppressMessages(
create_meta_study(
  folder_path = dir_out,
  type_of_cancer = "ptcls",
  cancer_study_identifier = cancer_study_identifier,
  name = "Peripheral T-cell Example",
  description = "Bulk RNA example"
))

expected_meta <- read.delim(path(dir_out, "meta_study.txt"), header = FALSE)

test_that("meta_study", {
   expect_snapshot(expected_meta)
   expect_error(
      create_meta_study(
        folder_path = dir_out,
        type_of_cancer = "ptcls"),
      "required")
})

test_that("snapshot_meta", {
  expect_snapshot(expected_meta)
})

# @@@@@@@@@@@@@@@@
# Cancer Type ----
# @@@@@@@@@@@@@@@@

suppressMessages(
create_cancer_type(
  folder_path = dir_out,
  type_of_cancer = "ptcls",
  name = "Peripheral T-cell Lymphoma",
  dedicated_color = "HotPink",
  parent_type_of_cancer = "Lymphoma"
))


suppressWarnings(
expected_meta_cancer_type <- read.delim(path(dir_out, "meta_cancer_type.txt"), header = FALSE)
)
expected_cancer_type <- read.delim(path(dir_out, "data_cancer_type.txt"), header = FALSE)

test_that("cancer_type", {
  expect_snapshot(expected_meta_cancer_type)
  expect_snapshot(expected_cancer_type)
  expect_error(
    create_cancer_type(
      folder_path = dir_out,
      name = "Peripheral T-cell Lymphoma",
      dedicated_color = "HotPink",
      parent_type_of_cancer = "Lymphoma"
    ),
    "required")
})

library(cbiopourer)
library(fs)
data("df_samples_datatype")
data("df_samples")
data("counts")


cancer_study_identifier <- "ptcls_example_2023"

dir_out <- tempdir()

create_meta_study(
  folder_path = dir_out,
  type_of_cancer = "ptcls",
  cancer_study_identifier = cancer_study_identifier,
  name = "Peripheral T-cell Example",
  description = "Bulk RNA example"
)

expected_tab <- read.delim(path(dir_out, "meta_study.txt"))

test_that("meta_study", {
   expect_snapshot(expected_tab)
   expect_error(
      create_meta_study(
        folder_path = dir_out,
        type_of_cancer = "ptcls"),
      "required")
})

test_that("snapshot_meta", {
  expect_snapshot(expected_tab)
})



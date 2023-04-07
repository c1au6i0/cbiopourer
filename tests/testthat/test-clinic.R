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

expected_meta <- read.delim(path(dir_out, "meta_study.txt"))

test_that("meta_study", {
   expect_snapshot(expected_meta)
   expect_error(
      create_meta_study(
        folder_path = dir_out,
        type_of_cancer = "ptcls"),
      "required")
})

test_that("snapshot_meta", {
  expect_snapshot(expected_tab)
})

# @@@@@@@@@@@@@@@@
# Cancer Type ----
# @@@@@@@@@@@@@@@@

create_cancer_type(
  folder_path = dir_out,
  type_of_cancer = "ptcls",
  name = "Peripheral T-cell Lymphoma",
  dedicated_color = "HotPink",
  parent_type_of_cancer = "Lymphoma"
)


expected_meta_cancer_type <- read.delim(path(dir_out, "meta_cancer_type.txt"))
expected_cancer_type <- read.delim(path(dir_out, "cancer_type.txt"))


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



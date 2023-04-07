
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cbiopourer

<!-- badges: start -->
<!-- badges: end -->

The goal of `cbiopourer`is to facilitate the creation of the files used
for ingesting studies into cBioportal. It helps pour data into
cBioportal. A detailed explanation of the file formats can be found in
<https://docs.cbioportal.org/file-formats/#expression-data>

## Installation

You can install the development version of cbiopourer from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("c1au6i0/cbiopourer")
```

## Use

The meta study, meta clinical and the respective clinical data are
required to load a study into the portal. The next sessions describe how
to create those files using `cbiopourer`

### Meta Study and Cancer type

The meta cancer study (`meta_study.txt`) contains metadata about the
cancer study. The required arguments are the one indicated in the
example below. The dcoumentation of the function reports the description
of the field as provided by the cBioportal website.

``` r
library(cbiopourer)

# the Identifier for the study
cancer_study_identifier <- "example_study_2023"

# The directory where to create the file.
dir_out <- tempdir()
  
create_meta_study(
  folder_path = dir_out,
  type_of_cancer = "ptcls",
  cancer_study_identifier = cancer_study_identifier,
  name = "Peripheral T-cell example",
  description = "Bulk RNA example"
)
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpCx4Y9J/meta_study.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpCx4Y9J/meta_study.txt]8;;' written.
```

The function generate the file in the format accepted by cBioportal.

    type_of_cancer: ptcls
    cancer_study_identifier: example_study_2023
    name: Peripheral T-cell example
    description: Bulk RNA example
    add_global_case_list: true

If the type of cancer is not one of those already defined in cBioportal,
a `meta-cancer_type.txt` file is required.

``` r
create_cancer_type(
  folder_path = dir_out,
  type_of_cancer = "ptcls", # as listed in the meta-study.txt
  name = "Peripheral T-cell Lymphoma",
  dedicated_color = "HotPink",
  parent_type_of_cancer = "Lymphoma")
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpCx4Y9J/meta_cancer_type.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpCx4Y9J/meta_cancer_type.txt]8;;' written.
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpCx4Y9J/cancer_type.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpCx4Y9J/cancer_type.txt]8;;' written.
```

## Clinical files

To be continued…

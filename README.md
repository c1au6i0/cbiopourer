
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cbiopourer

<!-- badges: start -->
<!-- badges: end -->

The purpose of cbiopourer is to simplify the process of generating files
for importing studies into cBioportal. This package streamlines the
transfer of data into cBioportal. For more information on the accepted
file formats, please refer to
<https://docs.cbioportal.org/file-formats/#expression-data>.

## Installation

You can install the development version of cbiopourer from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("c1au6i0/cbiopourer")
```

## Usage

In order to upload a study to the portal, the meta_study, meta_clinical,
and corresponding clinical data files must be generated. The following
sections explain how to use cbiopourer to create these files.

### Meta Study and Cancer Type

The meta_study.txt file contains metadata for the cancer study. The
required arguments are illustrated in the example below. The function
documentation details the other fields specified on the cBioportal
website.

``` r
library(cbiopourer)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

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
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpB5ZJXh/meta_study.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpB5ZJXh/meta_study.txt]8;;' written.
```

The function generates a file in the format accepted by cBioportal.

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
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpB5ZJXh/meta_cancer_type.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpB5ZJXh/meta_cancer_type.txt]8;;' written.
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpB5ZJXh/cancer_type.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpB5ZJXh/cancer_type.txt]8;;' written.
```

## Clinical files

According to cBioportal documentation, “clinical data is used to capture
both clinical attributes and the mapping between patient and sample
IDs:. In most cases, you will need to provide information for both the
patients and their corresponding samples, which requires the creation of
metadata and data files (for a total of 4 files).

Let’s suppose that our clinical informatian indicates the id of the
patient and the relative celline derived from the patient.

``` r
data(df_samples)
df_patients <- df_samples[, c("PATIENT_ID", "CELLLINE")]
glimpse(df_patients)
#> Rows: 28
#> Columns: 2
#> $ PATIENT_ID <chr> "A", "A", "A", "A", "A", "A", "B", "B", "B", "B", "C", "C",…
#> $ CELLLINE   <chr> "A", "A", "A", "A", "A", "A", "B", "B", "B", "B", "C", "C",…
```

The following attributes regarding the 2 columns of `df_patients` are
required to generate the appropriate files: - attribute Display Names. -
the attribute Descriptions. - the attribute Datatype (STRING, NUMBER,
BOOLEAN). - the attribute Priority.

We generate the info using.

``` r
df_patients_datatype <- tribble(
  ~var_int, ~description, ~datatype, ~attr_priority, ~attr_name,
  "Patient ID", "patient id", "STRING", 1, "PATIENT_ID",
  "Cellline", "cellline id", "STRING", 1, "CELLLINE"
)
```

Now, we can supply those 2 datafames to the `create_clinical` function
and create both the metadata and data file. Note that since we are
generating info regarding patients the `datatype` argument of is set to
“PATIENT_ATTRIBUTES”.

**The function also checks that correct attributes are provided for each
columns**.

``` r
dir_out <- tempdir()
  create_clinical(
    folder_path = dir_out,
    cancer_study_identifier = cancer_study_identifier,
    datatype = "PATIENT_ATTRIBUTES", 
    clinical_meta = df_patients_datatype,
    clinical_dat = df_patients)
#> → Integrity of data checked.
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpB5ZJXh/meta_clinical_patient.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpB5ZJXh/meta_clinical_patient.txt]8;;' has been generated.
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpB5ZJXh/data_clinical_patient.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpB5ZJXh/data_clinical_patient.txt]8;;' has been generated.
```

The clinical data will be

    #Patient<TAB>ID Cellline<TAB>
    #patient id<TAB>cellline id<TAB>
    #STRING<TAB>STRING<TAB>
    #1<TAB>1<TAB>
    #PATIENT_ID<TAB>CELLLINE<TAB>
    A<TAB>A<TAB>
    A<TAB>A<TAB>
    ...

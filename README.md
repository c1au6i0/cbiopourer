
<!--README.md is generated from README.Rmd. Please edit that file -->

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
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/Rtmpuag11w/meta_study.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/Rtmpuag11w/meta_study.txt]8;;' written.
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
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/Rtmpuag11w/meta_cancer_type.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/Rtmpuag11w/meta_cancer_type.txt]8;;' written.
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/Rtmpuag11w/cancer_type.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/Rtmpuag11w/cancer_type.txt]8;;' written.
```

## Clinical files

According to cBioportal documentation, “clinical data is used to capture
both clinical attributes and the mapping between patient and sample
IDs:. In most cases, you will need to provide information for both the
patients and their corresponding samples, which requires the creation of
metadata and data files (for a total of 4 files).

Let’s suppose that our clinical informatian indicates the id of the
patient and the relative celline derived from the patient.

### Patients

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
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/Rtmpuag11w/meta_clinical_patient.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/Rtmpuag11w/meta_clinical_patient.txt]8;;' has been generated.
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/Rtmpuag11w/data_clinical_patient.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/Rtmpuag11w/data_clinical_patient.txt]8;;' has been generated.
```

The clinical data will have a header formated as required by cBioportal.

    #Patient<TAB>ID Cellline<TAB>
    #patient id<TAB>cellline id<TAB>
    #STRING<TAB>STRING<TAB>
    #1<TAB>1<TAB>
    #PATIENT_ID<TAB>CELLLINE<TAB>
    A<TAB>A<TAB>
    A<TAB>A<TAB>
    ...

The metadata file generated is as follow:

    cancer_study_identifier: example_study_2023
    genetic_alteration_type: CLINICAL
    datatype:  PATIENT_ATTRIBUTES
    data_filename: data_clinical_patient.txt

### Samples

An example of sample info of a study is the following:

``` r
data(df_samples)

glimpse(df_samples)
#> Rows: 28
#> Columns: 7
#> $ SAMPLE_ID            <chr> "A_48h_VEH", "A_48h_VEH", "A_48h_DRUG_A", "A_48h_…
#> $ PATIENT_ID           <chr> "A", "A", "A", "A", "A", "A", "B", "B", "B", "B",…
#> $ CELLLINE             <chr> "A", "A", "A", "A", "A", "A", "B", "B", "B", "B",…
#> $ TIME_TREAT           <chr> "48h", "48h", "48h", "48h", "48h", "48h", "48h", …
#> $ TREAT                <chr> "VEH", "VEH", "DRUG_A", "DRUG_A", "DRUG_B", "DRUG…
#> $ CANCER_TYPE          <chr> "Lymphoma", "Lymphoma", "Lymphoma", "Lymphoma", "…
#> $ CANCER_TYPE_DETAILED <chr> "Peripheral T-cell Lymphoma", "Peripheral T-cell …
```

The steps to generate the files are the same described for the patient
clinical info.

We start creating a file with required attributes of each of the columns
of the `df_samples`.

``` r
df_samples_datatype <- tribble(
  ~var_int, ~description, ~datatype, ~attr_priority, ~attr_name,
  "Sample ID", "sample id", "STRING", 1, "SAMPLE_ID",
  "Patient ID", "patient id", "STRING", 1, "PATIENT_ID",
  "Cancer Type", "cancer type", "STRING", 1, "CANCER_TYPE",
  "Cancer Type Detailed", "cancer type detailed", "STRING", 1, "CANCER_TYPE_DETAILED",
  "Cellline", "cellline id", "STRING", 1, "CELLLINE",
  "Time Treat", "time of administration of treatment", "STRING", 1, "TIME_TREAT",
  "Treatment", "drug admnistered", "STRING", 1, "TREAT"
)
```

We supply the 2 dataframes to the `create_clinical` function and we set
the argument `datatype` to `SAMPLE_ATTRIBUTES`.

``` r
create_clinical(
  folder_path = dir_out,
  cancer_study_identifier = cancer_study_identifier,
  datatype = "SAMPLE_ATTRIBUTES",
  clinical_meta = df_samples_datatype,
  clinical_dat = df_samples)
#> → Integrity of data checked.
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/Rtmpuag11w/meta_clinical_sample.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/Rtmpuag11w/meta_clinical_sample.txt]8;;' has been generated.
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/Rtmpuag11w/data_clinical_sample.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/Rtmpuag11w/data_clinical_sample.txt]8;;' has been generated.
```

The clinical sample data file produced is as follow:

    #Sample<TAB>ID<TAB>Patient<TAB>ID<TAB>Cancer<TAB>Type<TAB>CancerType Detailed<TAB>Cellline<TAB>Time Treat<TAB>Treatment
    #sample id<TAB>patient id<TAB>cancer type<TAB>cancer type detailed<TAB>cellline id<TAB>time of administration of treatment<TAB>drug admnistered
    #STRING<TAB>STRING<TAB>STRING<TAB>STRING<TAB>STRING<TAB>STRING<TAB>STRING
    #1<TAB>1<TAB>1<TAB>1<TAB>1<TAB>1<TAB>1
    #SAMPLE_ID<TAB>PATIENT_ID<TAB>CANCER_TYPE<TAB>CANCER_TYPE_DETAILED<TAB>CELLLINE<TAB>TIME_TREAT<TAB>TREAT
    A_48h_VEH<TAB>A<TAB>Lymphoma<TAB>Peripheral T-cell Lymphoma<TAB>A<TAB>48h<TAB>VEH
    A_48h_VEH<TAB>A<TAB>Lymphoma<TAB>Peripheral T-cell Lymphoma<TAB>A<TAB>48h<TAB>VEH

## Expression Counts

To create meta and data files for RNAsep expression we need a matrix of
counts. See details in
<https://docs.cbioportal.org/file-formats/#expression-data>

``` r
data("counts")
head(counts)
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12] [,13] [,14]
#> [1,] 1615  349 2188  315 1896 1590 1110 1251 1859  -643 -1175   314    63   510
#> [2,]  693 1863 1586  870 1915 1859  -68 1863 1329  -156  1737  -772   398  -368
#> [3,] 2002 1657 1120  251  697   71 -912 1833 1250  1327  1265  1813   844  -934
#> [4,] 3137 1250 -480  925 1899  328 1467  143  945   573   895  1141  1827  1135
#> [5,] 1226 1239  -17  744  839  385  799   58  368   591  1317  1166  1264   975
#> [6,]  241  505  721 1751 1365 1899   72  195 1895  1979  2201   202   434   652
#>      [,15] [,16] [,17] [,18] [,19] [,20] [,21] [,22] [,23] [,24] [,25] [,26]
#> [1,]   474   867  -244  -431  -882   759  1385   -92  2019   977  1038   185
#> [2,]  -175   671  1655   829  2138  1047   966  1002   888  1002   782   267
#> [3,]  1619  1438  1033  2212  1260  1095   626  1686   294  2040   577   899
#> [4,]  1126  1136  1059   144    46   635   348  1202  1316  1224  -468   856
#> [5,]  1085   463  1695  1959   900   855  1203  1120    58  1151  1039  1262
#> [6,]  1681  2030  1140  -161   535  1654   320   651  -239  1382   999    -6
#>      [,27] [,28]
#> [1,]   660  1205
#> [2,]   778  2058
#> [3,]  1184   265
#> [4,]   813   445
#> [5,]   865   569
#> [6,]   117   978
```

Few other info are required and are supplid to the `create_expression`
function:

``` r
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
  expr_matrix = counts,
  gene_panel = NULL,
  gene_id_type = "hugo"
)
#> → The file ']8;;file:///Users/heverz/Documents/R_projects/inghirami_bioportal/code/cbiopourer/meta_expression.txtmeta_expression.txt]8;;' has been generated.
#> → The file ']8;;file:///Users/heverz/Documents/R_projects/inghirami_bioportal/code/cbiopourer/data_expression.txtdata_expression.txt]8;;' has been generated.
```

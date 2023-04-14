
<!--README.md is generated from README.Rmd. Please edit that file -->

# cbiopourer

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/c1au6i0/cbiopourer/branch/main/graph/badge.svg)](https://app.codecov.io/gh/c1au6i0/cbiopourer?branch=main)
[![](https://img.shields.io/badge/devel%20version-0.0.0.99-blue.svg)](https://github.com/https://github.com/c1au6i0/cbiopourer)
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
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/meta_study.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/meta_study.txt]8;;' written.
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
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/meta_cancer_type.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/meta_cancer_type.txt]8;;' written.
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/data_cancer_type.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/data_cancer_type.txt]8;;' written.
```

## Clinical files

According to cBioportal documentation, “clinical data is used to capture
both clinical attributes and the mapping between patient and sample
IDs”. In most cases, you will need to provide information for both the
patients and their corresponding samples, which requires the creation of
metadata and data files (for a total of 4 files).

Let’s suppose that our clinical information indicates the id of the
patient and the relative cellline derived from the patient.

### Patients

``` r
data(df_samples)
df_patients <- df_samples |> 
  dplyr::select(PATIENT_ID, CELLLINE) |> 
  dplyr::distinct(PATIENT_ID, .keep_all = TRUE)

glimpse(df_patients)
#> Rows: 6
#> Columns: 2
#> $ PATIENT_ID <chr> "A", "B", "C", "D", "E", "F"
#> $ CELLLINE   <chr> "A", "B", "C", "D", "E", "F"
```

The following attributes regarding the 2 columns of `df_patients` are
required to generate the appropriate files:

- attribute Display Names.
- the attribute Descriptions.
- the attribute Datatype (STRING, NUMBER, BOOLEAN).
- the attribute Priority.

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
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/meta_clinical_patient.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/meta_clinical_patient.txt]8;;' has been generated.
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/data_clinical_patient.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/data_clinical_patient.txt]8;;' has been generated.
```

The clinical data will have a header formated as required by cBioportal.

    #Patient<TAB>ID Cellline<TAB>
    #patient id<TAB>cellline id<TAB>
    #STRING<TAB>STRING<TAB>
    #1<TAB>1<TAB>
    #PATIENT_ID<TAB>CELLLINE<TAB>
    A<TAB>A<TAB>
    B<TAB>B<TAB>
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
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/meta_clinical_sample.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/meta_clinical_sample.txt]8;;' has been generated.
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/data_clinical_sample.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/data_clinical_sample.txt]8;;' has been generated.
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

To create meta and data files for RNAsep expression we need a dataframe
containing genes x sample counts and at least one coloumn named
`Hugo_Symbol`, `Entrez_Gene_Id`. See details in
<https://docs.cbioportal.org/file-formats/#expression-data>

``` r
data("df_expr")
head(df_expr)
#>   Hugo_Symbol Entrez_Gene_Id A_48h_VEH A_48h_VEH A_48h_DRUG_A A_48h_DRUG_A
#> 1       CAMK1           8536       771      1201         1692          191
#> 2       PANX2          56666       290       786         2283          998
#> 3       P2RX1           5023       663      1691         1525         1824
#> 4     EPB41L3          23136      2880      1454          500          542
#> 5       METRN          79006      1126      1304          780          211
#> 6        PCP2         126006      3260      1421          900         2078
#>   A_48h_DRUG_B A_48h_DRUG_B B_48h_VEH B_48h_VEH B_48h_DRUG_A B_48h_DRUG_A
#> 1         1509           58      1834      -222         1731         1538
#> 2         1499         1047      1051      1021         1429          928
#> 3          840         1656       105      1804         1558         1074
#> 4         1600         3063       878      1658         2070         2554
#> 5          557           58       188       650         2394         2679
#> 6         1059         1698      1962       711         1621          -28
#>   C_48h_VEH C_48h_VEH C_48h_DRUG_A C_48h_DRUG_A D_48h_VEH D_48h_VEH
#> 1      1223      1032         1858         1081      1293      1397
#> 2       673       331         1905         1509       342       952
#> 3       684        80         1475         1997       664      2147
#> 4       899      1152          946          498       335      2233
#> 5      1439      1747          805         1162      1640      1112
#> 6       687       672         2049         1549      1531      1395
#>   D_48h_DRUG_A D_48h_DRUG_A E_48h_VEH E_48h_VEH E_48h_DRUG_A E_48h_DRUG_A
#> 1         2327         1182      1319      1235         1153          993
#> 2         1536          880      1807      -287          519           28
#> 3          849         2264       728       804         1164         1267
#> 4         -197         1522       384      -583         1643         1658
#> 5         2738         1654       255      1494         1282         1555
#> 6         3114         1321      1263       867          688          181
#>   E_48h_DRUG_B E_48h_DRUG_B F_48h_VEH F_48h_VEH F_48h_DRUG_A F_48h_DRUG_A
#> 1         1004        -1010       226      1456          516         1267
#> 2          466          118       584      1406          858         -398
#> 3         -371          556       462       173         1107          378
#> 4          141          518       144      1040          856          366
#> 5         1815         1433       902      2515         1257          958
#> 6         2565          746      -206      2533          100          209
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
  df_expr = df_expr,
  gene_panel = NULL
)
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/meta_expression.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/meta_expression.txt]8;;' has been generated.
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/data_expression.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpvVATbu/data_expression.txt]8;;' has been generated.
```

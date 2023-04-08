
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
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/meta_study.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/meta_study.txt]8;;' written.
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
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/meta_cancer_type.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/meta_cancer_type.txt]8;;' written.
#> → File ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/cancer_type.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/cancer_type.txt]8;;' written.
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
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/meta_clinical_patient.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/meta_clinical_patient.txt]8;;' has been generated.
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/data_clinical_patient.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/data_clinical_patient.txt]8;;' has been generated.
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
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/meta_clinical_sample.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/meta_clinical_sample.txt]8;;' has been generated.
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/data_clinical_sample.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/data_clinical_sample.txt]8;;' has been generated.
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
#>         A_48h_VEH A_48h_VEH A_48h_DRUG_A A_48h_DRUG_A A_48h_DRUG_B A_48h_DRUG_B
#> CAMK1        1923      1016         1748         1104         1272         1233
#> PANX2        2042      1272          459         -413         1717          317
#> P2RX1        1167      1109          261          706         1530         1596
#> EPB41L3       501      1455          712         1475          548          615
#> METRN         -86      -729         2447         1741         1065         1406
#> PCP2          710       381         1365         1154         -141         1722
#>         B_48h_VEH B_48h_VEH B_48h_DRUG_A B_48h_DRUG_A C_48h_VEH C_48h_VEH
#> CAMK1        1546       852          139         1121      1233       570
#> PANX2         -11       291         1617          964      1108      1048
#> P2RX1        1506       631          222         1711      1215      1202
#> EPB41L3      2297       539          850          598       666        68
#> METRN          40      1634           24         1777      1775       174
#> PCP2          444      1384         1981         1360      1200      1109
#>         C_48h_DRUG_A C_48h_DRUG_A D_48h_VEH D_48h_VEH D_48h_DRUG_A D_48h_DRUG_A
#> CAMK1           1021         2447       577       210         1633          765
#> PANX2            944         1652      1511       796          391         1285
#> P2RX1           -158          968      2897      1282         1641         1182
#> EPB41L3        -1309         2197       687      1694         1516          828
#> METRN           1577          605      1448       705         1219         1213
#> PCP2            2106         3009       130      1682          573          706
#>         E_48h_VEH E_48h_VEH E_48h_DRUG_A E_48h_DRUG_A E_48h_DRUG_B E_48h_DRUG_B
#> CAMK1         634      -285         1246         1586         -748         1634
#> PANX2         492      1428          525         1150          185          355
#> P2RX1         818      1932         1308          652           99         1485
#> EPB41L3       321      1256         2009          670          649          816
#> METRN        1278      1722           -4         -286         -259          959
#> PCP2         2148       968         1687         1065         1322          200
#>         F_48h_VEH F_48h_VEH F_48h_DRUG_A F_48h_DRUG_A
#> CAMK1        1468      2085         1364         1787
#> PANX2         389      1485          501         1777
#> P2RX1         740       281         3088         1759
#> EPB41L3      1538       153         2354          799
#> METRN         -14      1826         1522         2145
#> PCP2         1522       250         1909         1644
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
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/meta_expression.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/meta_expression.txt]8;;' has been generated.
#> → The file ']8;;file:///var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/data_expression.txt/var/folders/bp/fpwcfq1563l21rz5gdcsfcsw0000gn/T/RtmpgZjUlj/data_expression.txt]8;;' has been generated.
```

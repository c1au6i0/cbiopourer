#' check meta clinical
#'
#' Verify  dataframes used for `create_meta_clinical`
#'
#' @param clinical_dat Dataframe with Clinical Data.
#' @param clinical_meta Dataframe indicating the type of data.
#' @param datatype One of `PATIENT_ATTRIBUTES` or `SAMPLE_ATTRIBUTES`.
#'
#' @return stop if requirement are not met
check_clinical <- function(clinical_dat, clinical_meta, datatype) {


  if (!setequal(names(clinical_dat), clinical_meta$attr_name)) {
    cli::cli_abort("The columns of {.field clinical_dat} are not present in {.field clinical_meta$attr_name}.")
  }

  # Data Types
  expected_datatype <- c("PATIENT_ATTRIBUTES", "SAMPLE_ATTRIBUTES")

  if (!datatype %in% expected_datatype) {
    cli::cli_abort("The argument datatype needs to be one of {.field {expected_datatype}}.")
  }

  # Clinical Meta
  if (datatype == "SAMPLE_ATTRIBUTES") {
    check_attr <- !any(c("SAMPLE_ID", "PATIENT_ID") %in% clinical_meta$attr_name)
  } else {
    check_attr <- !"PATIENT_ID" %in% clinical_meta$attr_name
  }
  if (check_attr) cli::cli_abort("`SAMPLE_ or PATIENT_ID` column missing in {.field clinical_meta}.")


  col_required <- c("var_int", "description", "datatype", "attr_priority", "attr_name")
  if (!all(names(clinical_meta) %in% col_required)) {
    missing_cols <- names(clinical_meta)[!names(clinical_meta) %in% col_required]
    cli::cli_abort("The column{?s} {.field {missing_cols}} {?is/is/are} required.")
  }

  if (!all(clinical_meta$datatype %in% c("STRING", "NUMBER", "BOOLEAN"))) {
    cli::cli_abort("Values of {.field datatype$datatype} need to be one of {.field STRING, NUMBER OF BOLLEAN}.")
  }

  cli::cli_alert("Integrity of data checked.")
}


#' check expr data
#'
#' Verify expression data
#'
#' @param df_expr Dataframe of expression.
#' @return stop if requirement are not met
check_expr <- function(df_expr) {

  if (!"data.frame" %in% class(df_expr)) cli::cli_abort("The df_expr needs to be of class {.field data.frame}.")

  genes_names <- c("Hugo_Symbol", "Entrez_Gene_Id")

  if( all(!names(df_expr) %in% genes_names)) cli::cli_abort("The df_expr needs to have at least a column named {.field {genes_names}}.")
}

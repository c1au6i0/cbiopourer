#' check meta clinical
#'
#' Verify  dataframes used for `create_meta_clinical`
#'
#' @param clinical_dat
#' @param clinical_meta
#' @param datatype One of `PATIENT_ATTRIBUTES` or `SAMPLE_ATTRIBUTES`.
#'
#' @return stop if requirement are not met
#' @export
check_meta_clinical <- function(clinical_dat, clinical_meta, datatype) {
  if (!setequal(names(clinical_dat), clinical_meta$attr_name)) {
    cli::cli_abort("The columns of clinical_dat are not present in clinical_meta$attr_name.")
  }

  if (datatype == "SAMPLE_ATTRIBUTES") {
    check_attr <- !any(c("SAMPLE_ID", "PATIENT_ID") %in% clinical_meta$attr_name)
  } else {
    check_attr <- !"PATIENT_ID" %in% clinical_meta$attr_name
  }

  if (check_attr) cli::cli_abort("`SAMPLE_ or PATIENT_ID` column missing in clinical_meta")


  if (!all(names(clinical_meta) %in% c("var_int", "description", "datatype", "attr_priority", "attr_name"))) {
    cli::cli_abort("datatype doesn't contain columns `var_int`, `description`, `datatype`. `attr_priority`, `attr_name`")
  }

  if (!all(clinical_meta$datatype %in% c("STRING", "NUMBER", "BOOLEAN"))) {
    cli::cli_abort("Values of datatype$datatype need to be one of STRING, NUMBER OF BOLLEAN.")
  }

  cli::cli_alert("Integrity of data checked.")
}

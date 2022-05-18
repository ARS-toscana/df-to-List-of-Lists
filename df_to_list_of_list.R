df_to_list_of_list <- function(x, codying_system_recode = "auto", imputed_tags = NULL) {
  
  if(!require(data.table)){install.packages("data.table")}
  suppressPackageStartupMessages(library(data.table))
  
  x <- data.table::as.data.table(df)
  
  if (!missing(imputed_tags)) {
    if (tolower(imputed_tags) %in% c("narrow", "n")) {
      imputed_tags <- "narrow"
    } else if (tolower(imputed_tags) %in% c("possible", "p")) {
      imputed_tags <- "possible"
    } else {
      stop("imputed_tags accepts only values narrow or possible")
    }
    
    message(paste(x[tags == "", .N], "tags have been recoded to", imputed_tags))
    x <- x[tags == "", tags := imputed_tags]
    
  }
  
  if ("tags" %in% colnames(x)) {
    x <- x[type != "COV", event_abbreviation := paste(event_abbreviation, tags, sep = "_")]
  }
  
  x <- x[, .(code, coding_system, event_abbreviation)]
  
  if (isFALSE(codying_system_recode)) {
    next
  } else if (tolower(codying_system_recode) == "auto") {
    x[, coding_system := data.table::fcase(
      coding_system %in% c("ICD10", "ICD10CM", "ICD10DA"), "ICD10",
      coding_system %in% c("Free_text"), "Free_text",
      coding_system %in% c("ICD9CM", "MTHICD9"), "ICD9",
      coding_system %in% c("ICPC"), "ICPC",
      coding_system %in% c("ICPC2P", "ICPC2EENG"), "ICPC2P",
      coding_system %in% c("RCD2", "RCD"), "READ",
      coding_system %in% c("MEDCODEID", "SCTSPA", "SNOMEDCT_US", "SPA_EXT", "SNM"), "SNOMED"
    )]
  } else {
    x[codying_system_recode, on = c("coding_system" = colnames(codying_system_recode)[[1]]),
      "coding_system" := c(colnames(codying_system_recode)[[2]])]
  }
  
  x <- lapply(split(x, by = "event_abbreviation", keep.by = F),
              split, by = "coding_system", keep.by = F)
  
  x <- lapply(x, sapply, unlist, use.names = F, simplify = T)
  
  return(x)
}

mySCANprivate <- function(celFilePattern, outFilePath = NA, intervalN = 50000,
                          convThreshold = 0.01, annotationPackageName = NA,
                          probeSummaryPackage = NA, probeLevelOutDirPath = NA,
                          exonArrayTarget = NA, batchFilePath = NA,
                          verbose = TRUE) {

  if (convThreshold >= 1)
    stop("The convThreshold value must be lower than 1.0.")

  fromGEO <- SCAN.UPC:::shouldDownloadFromGEO(celFilePattern)
  if (fromGEO)
    celFilePattern <- SCAN.UPC:::downloadFromGEO(celFilePattern, expectedFileSuffixPattern = "*.CEL.gz")

  fileNamePattern <- sub("\\-", "\\\\-", glob2rx(basename(celFilePattern)))
  fileNamePattern <- sub("\\+", "\\\\+", fileNamePattern)
  celFilePaths <- list.files(path = dirname(celFilePattern),
                             pattern = fileNamePattern, full.names = TRUE, ignore.case = TRUE)
  celFilePaths <- unique(celFilePaths)

  if (length(celFilePaths) == 0)
    stop("No CEL files that match the pattern ", celFilePattern, " could be located.")

  if (!is.na(outFilePath))
    SCAN.UPC:::createOutputDir(dirPath = dirname(outFilePath), verbose = verbose)

  if (!is.na(probeLevelOutDirPath))
    SCAN.UPC:::createOutputDir(dirPath = probeLevelOutDirPath, verbose = verbose)

  # --- CUSTOM LOGGING START ---
  celSummarizedList <- foreach(i = seq_along(celFilePaths), .packages = c("tibble", "readr")) %dopar% {
    celFilePath <- celFilePaths[i]

    forPrint <- tibble(
      log = paste0("Processing sample ", i, "/", length(celFilePaths),
                   " - ", basename(celFilePath),
                   " at ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))
    )

    write_tsv(forPrint, "Data/Affymetrix/Timing/timings.tsv", append = TRUE, col_names = FALSE)

    SCAN.UPC:::processCelFile(celFilePath = celFilePath,
                              annotationPackageName = annotationPackageName,
                              probeSummaryPackage = probeSummaryPackage,
                              UPC = FALSE,
                              intervalN = intervalN,
                              convThreshold = convThreshold,
                              probeLevelOutDirPath = probeLevelOutDirPath,
                              exonArrayTarget = exonArrayTarget,
                              verbose = verbose)
  }
  # --- CUSTOM LOGGING END ---

  if (fromGEO) unlink(celFilePaths)

  summarized <- NULL
  for (i in seq_along(celFilePaths)) {
    celSummarized <- celSummarizedList[[i]]
    celFilePath <- celFilePaths[i]
    if (is.null(celSummarized)) next

    if (is.null(summarized)) {
      summarized <- celSummarized
      colnames(summarized) <- basename(celFilePath)
    } else {
      previousColNames <- colnames(summarized)
      summarized <- merge(summarized, celSummarized, sort = FALSE, by = 0)
      rownames(summarized) <- summarized[, 1]
      summarized <- summarized[, -1]
      colnames(summarized) <- c(previousColNames, basename(celFilePath))
    }
  }

  if (is.null(summarized)) return(ExpressionSet())

  if (!is.na(outFilePath)) {
    write.table(round(summarized, 8), outFilePath, sep = "\t",
                quote = FALSE, row.names = TRUE, col.names = TRUE)
    message("Saved output to ", outFilePath)
  }

  expressionSet <- ExpressionSet(as.matrix(summarized))
  sampleNames(expressionSet) <- colnames(summarized)
  featureNames(expressionSet) <- rownames(summarized)
  return(expressionSet)
}

#' @title SangerRead
#'
#' @description  An S4 class extending sangerseq S4 class which corresponds to a single ABIF file in Sanger sequencing.
#'
#' @slot inputSource The input source of the raw file. It must be \code{"ABIF"} or \code{"FASTA"}. The default value is \code{"ABIF"}.
#' @slot readFeature The direction of the Sanger read. The value must be \code{"Forward Read"} or \code{"Reverse Read"}.
#' @slot readFileName The filename of the target input file. It can be \code{"ABIF"} or \code{"FASTA"} file.
#' @slot fastaReadName If \code{inputSource} is \code{"FASTA"}, then this value has to be the name of the read inside the FASTA file; if \code{inputSource} is \code{"ABIF"}, then this value is \code{NULL} by default.
#' @slot abifRawData A S4 class containing all fields in the ABIF file. It is defined in sangerseqR package.
#' @slot QualityReport A S4 class containing quality trimming related inputs and trimming results.
#' @slot ChromatogramParam A S4 class containing chromatogram inputs.
#' @slot primaryAASeqS1 A polypeptide translated from primary DNA sequence starting from the first nucleic acid.
#' @slot primaryAASeqS2 A polypeptide translated from primary DNA sequence starting from the second nucleic acid.
#' @slot primaryAASeqS3 A polypeptide translated from primary DNA sequence starting from the third nucleic acid.
#' @slot geneticCode Named character vector in the same format as \code{GENETIC_CODE} (the default), which represents the standard genetic code. This is the code with which the function will attempt to translate your DNA sequences. You can get an appropriate vector with the getGeneticCode() function. The default is the standard code.
#' @slot primarySeqRaw The raw primary sequence from sangerseq class in sangerseqR package before base calling.
#' @slot secondarySeqRaw The raw secondary sequence from sangerseq class in sangerseqR package before base calling.
#' @slot peakPosMatrixRaw The raw peak position matrix from sangerseq class in sangerseqR package before base calling.
#' @slot peakAmpMatrixRaw The raw peak amplitude matrix from sangerseq class in sangerseqR package before base calling.
#'
#' @name SangerRead-class
#' @exportClass SangerRead
#'
#' @author Kuan-Hao Chao
#' @include ClassQualityReport.R
#' @import sangerseqR
#' @examples
#' ## Input From ABIF file format
#' # Forward Read
#' inputFilesPath <- system.file("extdata/", package = "sangeranalyseR")
#' A_chloroticaFFN <- file.path(inputFilesPath,
#'                              "Allolobophora_chlorotica",
#'                              "ACHLO",
#'                              "Achl_ACHLO006-09_1_F.ab1")
#' sangerReadF <- new("SangerRead",
#'                     inputSource           = "ABIF",
#'                     readFeature           = "Forward Read",
#'                     readFileName          = A_chloroticaFFN,
#'                     geneticCode           = GENETIC_CODE,
#'                     TrimmingMethod        = "M1",
#'                     M1TrimmingCutoff      = 0.0001,
#'                     M2CutoffQualityScore  = NULL,
#'                     M2SlidingWindowSize   = NULL,
#'                     baseNumPerRow         = 100,
#'                     heightPerRow          = 200,
#'                     signalRatioCutoff     = 0.33,
#'                     showTrimmed           = TRUE)
#'
#' # Reverse Read
#' A_chloroticaRFN <- file.path(inputFilesPath,
#'                              "Allolobophora_chlorotica",
#'                              "ACHLO",
#'                              "Achl_ACHLO006-09_2_R.ab1")
#' sangerReadR <- new("SangerRead",
#'                     inputSource           = "ABIF",
#'                     readFeature           = "Reverse Read",
#'                     readFileName          = A_chloroticaRFN,
#'                     geneticCode           = GENETIC_CODE,
#'                     TrimmingMethod        = "M1",
#'                     M1TrimmingCutoff      = 0.0001,
#'                     M2CutoffQualityScore  = NULL,
#'                     M2SlidingWindowSize   = NULL,
#'                     baseNumPerRow         = 100,
#'                     heightPerRow          = 200,
#'                     signalRatioCutoff     = 0.33,
#'                     showTrimmed           = TRUE)
#'
#'
#' ## Input From FASTA file format
#' # Forward Read
#' inputFilesPath <- system.file("extdata/", package = "sangeranalyseR")
#' A_chloroticaFFNfa <- file.path(inputFilesPath,
#'                                "fasta",
#'                                "SangerRead",
#'                                "Achl_ACHLO006-09_1_F.fa")
#' readNameFfa <- "Achl_ACHLO006-09_1_F"
#' sangerReadFfa <- new("SangerRead",
#'                      inputSource        = "FASTA",
#'                      readFeature        = "Forward Read",
#'                      readFileName       = A_chloroticaFFNfa,
#'                      fastaReadName      = readNameFfa,
#'                      geneticCode        = GENETIC_CODE)
#' # Reverse Read
#' A_chloroticaRFNfa <- file.path(inputFilesPath,
#'                                "fasta",
#'                                "SangerRead",
#'                                "Achl_ACHLO006-09_2_R.fa")
#' readNameRfa <- "Achl_ACHLO006-09_2_R"
#' sangerReadRfa <- new("SangerRead",
#'                      inputSource   = "FASTA",
#'                      readFeature   = "Reverse Read",
#'                      readFileName  = A_chloroticaRFNfa,
#'                      fastaReadName = readNameRfa,
#'                      geneticCode   = GENETIC_CODE)
setClass(
    "SangerRead",
    ### ------------------------------------------------------------------------
    ### Input type of each variable of 'SangerContig'.
    ###     * Inherit from 'sangerseq' from sangerseqR.
    ### ------------------------------------------------------------------------
    contains="sangerseq",
    slots=c(inputSource         = "character",
            readFeature         = "character",
            readFileName        = "character",
            fastaReadName       = "characterORNULL",
            geneticCode         = "character",
            abifRawData         = "abifORNULL",
            QualityReport       = "QualityReportORNULL",
            ChromatogramParam   = "ChromatogramParamORNULL",
            primaryAASeqS1      = "AAString",
            primaryAASeqS2      = "AAString",
            primaryAASeqS3      = "AAString",
            primarySeqRaw       = "DNAString",
            secondarySeqRaw     = "DNAString",
            peakPosMatrixRaw    = "matrix",
            peakAmpMatrixRaw    = "matrix")
)

### ============================================================================
### Overwrite initialize for SangerRead (New constructor)
### ============================================================================
setMethod("initialize",
          "SangerRead",
          function(.Object,
                   inputSource          = "ABIF",
                   readFeature          = "",
                   readFileName         = "",
                   fastaReadName        = NULL,
                   geneticCode          = GENETIC_CODE,
                   TrimmingMethod       = "M1",
                   M1TrimmingCutoff     = 0.0001,
                   M2CutoffQualityScore = NULL,
                   M2SlidingWindowSize  = NULL,
                   baseNumPerRow        = 100,
                   heightPerRow         = 200,
                   signalRatioCutoff    = 0.33,
                   showTrimmed          = TRUE) {
    ### ------------------------------------------------------------------------
    ### Input parameter prechecking
    ### ------------------------------------------------------------------------
    errors <- character()
    errors <- checkInputSource (inputSource, errors)
    errors <- checkReadFeature (readFeature, errors)
    errors <- checkReadFileName (readFileName, inputSource, errors)
    errors <- checkGeneticCode (geneticCode, errors)
    ### ------------------------------------------------------------------------
    ### Prechecking success. Start to create 'SangerRead'
    ### ------------------------------------------------------------------------
    if (length(errors) == 0) {
        if (inputSource == "ABIF") {
            ##### --------------------------------------------------------------
            ##### Inside prechecking.
            ##### --------------------------------------------------------------
            ##### --------------------------------------------------------------
            ##### Input parameter prechecking for TrimmingMethod. [abif only]
            ##### --------------------------------------------------------------
            errors <- checkTrimParam(TrimmingMethod,
                                     M1TrimmingCutoff,
                                     M2CutoffQualityScore,
                                     M2SlidingWindowSize,
                                     errors)
            ##### --------------------------------------------------------------
            ##### Input parameter prechecking for ChromatogramParam. [abif only]
            ##### --------------------------------------------------------------
            errors <- checkBaseNumPerRow(baseNumPerRow, errors)
            errors <- checkHeightPerRow(baseNumPerRow, errors)
            errors <- checkSignalRatioCutoff(signalRatioCutoff,errors)
            errors <- checkShowTrimmed(showTrimmed, errors)
            if(length(errors) != 0) {
                log_error(paste(errors, collapse = ""))
            }
            log_info(readFeature, ": Creating abif & sangerseq ...")
            log_info("    * Creating ", readFeature , " raw abif ...")
            abifRawData = read.abif(readFileName)
            log_info("    * Creating ", readFeature , " raw sangerseq ...")
            readSangerseq <- sangerseq(abifRawData)
            primarySeqID <- readSangerseq@primarySeqID
            secondarySeqID <- readSangerseq@secondarySeqID

            ### ----------------------------------------------------------------
            ### With non-raw & raw primarySeq / secondarySeq
            ### ----------------------------------------------------------------
            if (readFeature == "Forward Read") {
                primarySeqRaw    <- readSangerseq@primarySeq
                primarySeq       <- readSangerseq@primarySeq
                secondarySeqRaw  <- readSangerseq@secondarySeq
                secondarySeq     <- readSangerseq@secondarySeq
                traceMatrix      <- readSangerseq@traceMatrix
                peakPosMatrixRaw <- readSangerseq@peakPosMatrix
                peakPosMatrix    <- readSangerseq@peakPosMatrix
                peakAmpMatrixRaw <- readSangerseq@peakAmpMatrix
                peakAmpMatrix    <- readSangerseq@peakAmpMatrix
            } else if (readFeature == "Reverse Read") {
                primarySeqRaw <- 
                    reverseComplement(readSangerseq@primarySeq)
                primarySeq <- 
                    reverseComplement(readSangerseq@primarySeq)
                secondarySeqRaw <- 
                    reverseComplement(readSangerseq@secondarySeq)
                secondarySeq <- 
                    reverseComplement(readSangerseq@secondarySeq)

                # traceMatrix      <-
                #     apply(readSangerseq@traceMatrix, 2, rev)
                # peakPosMatrixRaw <-
                #     apply(readSangerseq@peakPosMatrix, 2, rev)
                # peakPosMatrix    <-
                #     apply(readSangerseq@peakPosMatrix, 2, rev)
                # peakAmpMatrixRaw <-
                #     apply(readSangerseq@peakAmpMatrix, 2, rev)
                # peakAmpMatrix    <-
                #     apply(readSangerseq@peakAmpMatrix, 2, rev)
                
                traceMatrix      <- readSangerseq@traceMatrix
                peakPosMatrixRaw <- readSangerseq@peakPosMatrix
                peakPosMatrix    <- readSangerseq@peakPosMatrix
                peakAmpMatrixRaw <- readSangerseq@peakAmpMatrix
                peakAmpMatrix    <- readSangerseq@peakAmpMatrix
            }
            
            ### ----------------------------------------------------------------
            ### Definition of 'PCON.1' & 'PCON.2'
            ##### PCON.1: char => Per-base quality values (edited)
            ##### PCON.2: char => Per-base quality values
            ### ----------------------------------------------------------------
            ### ----------------------------------------------------------------
            ### 1. Running 'MakeBaseCall'!
            ### ----------------------------------------------------------------
            
            ## Reverse the 'traceMatrix' and 'peakPosMatrixRaw' before running
            ##   MakeBaseCallsInside function.
            MBCResult <-
                MakeBaseCallsInside (traceMatrix, peakPosMatrixRaw,
                                     abifRawData@data$PCON.2,
                                     signalRatioCutoff, readFeature)
            
            
            
            
            
            
            
            
            

            ### ================================================================
            ### 2. Update Once (Only during creation)
            ###    Basecall primary seq length will be same !
            ###    Quality Score is reversed in MakeBaseCallsInside function !!
            ### ================================================================
            qualityPhredScores <- MBCResult[["qualityPhredScores"]]
            ### ----------------------------------------------------------------
            ##### 'QualityReport' creation
            ### ----------------------------------------------------------------
            QualityReport <-
                new("QualityReport",
                    qualityPhredScores    = qualityPhredScores,
                    TrimmingMethod        = TrimmingMethod,
                    M1TrimmingCutoff      = M1TrimmingCutoff,
                    M2CutoffQualityScore  = M2CutoffQualityScore,
                    M2SlidingWindowSize   = M2SlidingWindowSize)

            ### ================================================================
            ### 3. Update everytime
            ### ================================================================
            primarySeq <- MBCResult[["primarySeq"]]
            secondarySeq <- MBCResult[["secondarySeq"]]
            peakPosMatrix <- MBCResult[["peakPosMatrix"]]
            peakAmpMatrix <- MBCResult[["peakAmpMatrix"]]
            ### ----------------------------------------------------------------
            ##### 'QualityReport' & 'ChromatogramParam' creation
            ### ----------------------------------------------------------------
            ChromatogramParam <-
                new("ChromatogramParam",
                    baseNumPerRow     = baseNumPerRow,
                    heightPerRow      = heightPerRow,
                    signalRatioCutoff = signalRatioCutoff,
                    showTrimmed       = showTrimmed)
            trimmedStartPos <- QualityReport@trimmedStartPos
            trimmedFinishPos <- QualityReport@trimmedFinishPos
        } else if (inputSource == "FASTA") {
            abifRawData <- NULL
            primarySeqID <- "From fasta file"
            secondarySeqID <- ""
            primarySeqRaw <- DNAString()
            log_info(readFeature, ": Creating SangerRead from FASTA ...")
            readFasta <- read.fasta(readFileName, as.string = TRUE)
            ### ----------------------------------------------------------------
            ### Get the Target Filename !!
            ### ----------------------------------------------------------------
            fastaNames <- names(readFasta)
            targetFastaName <- fastaNames[fastaNames == fastaReadName]
            if(isEmpty(targetFastaName)) {
                log_error(paste0("The name '", fastaReadName, "' is not in the '",
                                 basename(readFileName),"' FASTA file"))
            }
            primarySeq <- DNAString(as.character(readFasta[[targetFastaName]]))
            if (readFeature == "Reverse Read") {
                primarySeq <- reverseComplement(primarySeq)
            }
            secondarySeqRaw   <- DNAString()
            secondarySeq      <- DNAString()
            traceMatrix       <- matrix()
            peakPosMatrixRaw  <- matrix()
            peakPosMatrix     <- matrix()
            peakAmpMatrixRaw  <- matrix()
            peakAmpMatrix     <- matrix()
            QualityReport     <- NULL
            ChromatogramParam <- NULL
            trimmedStartPos <- 0
            trimmedFinishPos <- length(primarySeq)
        }
        AASeqResult    <- calculateAASeq (primarySeq, trimmedStartPos,
                                          trimmedFinishPos, geneticCode)
        primaryAASeqS1 <- AASeqResult[["primaryAASeqS1"]]
        primaryAASeqS2 <- AASeqResult[["primaryAASeqS2"]]
        primaryAASeqS3 <- AASeqResult[["primaryAASeqS3"]]
        log_success("  >> 'SangerRead' S4 instance is created !!")
        ### ====================================================================
    } else {
        log_error(paste(errors, collapse = ""))
    }
    callNextMethod(.Object,
                   inputSource         = inputSource,
                   fastaReadName       = fastaReadName,
                   readFeature         = readFeature,
                   readFileName        = readFileName,
                   geneticCode         = geneticCode,
                   primarySeqID        = primarySeqID,
                   primarySeqRaw       = primarySeqRaw,
                   primarySeq          = primarySeq,
                   secondarySeqID      = secondarySeqID,
                   secondarySeqRaw     = secondarySeqRaw,
                   secondarySeq        = secondarySeq,
                   primaryAASeqS1      = primaryAASeqS1,
                   primaryAASeqS2      = primaryAASeqS2,
                   primaryAASeqS3      = primaryAASeqS3,
                   traceMatrix         = traceMatrix,
                   peakPosMatrix       = peakPosMatrix,
                   peakPosMatrixRaw    = peakPosMatrixRaw,
                   peakAmpMatrix       = peakAmpMatrix,
                   peakAmpMatrixRaw    = peakAmpMatrixRaw,
                   abifRawData         = abifRawData,
                   QualityReport       = QualityReport,
                   ChromatogramParam   = ChromatogramParam)
})

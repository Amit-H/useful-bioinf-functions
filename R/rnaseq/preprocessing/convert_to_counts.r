#' Convert transcript-level abundance data to gene-level count data
#'
#' This function takes as input a transcript-level abundance file and a directory containing transcript-level abundance files in the same format, and returns gene-level count data. The function uses the tximport package to convert the transcript-level abundance data to gene-level count data, and writes the results to a file named "counts.tsv" in the working directory.
#'
#' @param transcript_mapping_file A character string specifying the file path to the transcript mapping file.
#' @param input_directory A character string specifying the file path to the directory containing transcript-level abundance files.
#'
#' @return A matrix of gene-level counts, with rows corresponding to genes and columns corresponding to samples.
#'
#' @export
#'
#' @examples
#' library(tximport)
#' data_dir <- system.file("extdata", package="tximportData")
#' transcript_mapping_file <- file.path(data_dir, "transcripts_to_genes.txt")
#' input_directory <- file.path(data_dir, "abundance")
#' counts <- convert_to_counts(transcript_mapping_file, input_directory)
#' head(counts)
#' # Output:
#' #           ERR188044 ERR188104 ERR188234 ERR188245 ERR188257 ERR188273 ERR188337 ERR188383 ERR188401 ERR188428
#' # ENSG00000000003      2493      2332      1817      2313      1941      1942      2257      2623      2047      1669
#' # ENSG00000000005         0         0         0         0         0         0         0         0         0         0
#' # ENSG00000000419     12860     11120     12366     10574      9176     10526     11377     11564     11120     12015
#' # ENSG00000000457      3012      3346      3202      2826      2921      3146      3388      2919      2956      2956
#' # ENSG00000000460      5814      5872      6399      5874      5954      6491      6282      6142      5942      6743
#' # ENSG00000000938      3546      3308      3485      3232      3635      3458      3273      3363      3411      3588
#'
#' @importFrom tximport tximport
#' @importFrom utils read.csv write.table
#' @export
convert_to_counts <- function(transcript_mapping_file, input_directory) {
  tx2gene <- read.csv(transcript_mapping_file, header=TRUE, stringsAsFactors=FALSE, sep="\t")
  currwd <- getwd()
  setwd(input_directory)
  files <- list.files()[grep("*abundance.tsv", list.files())]
  names(files) <- gsub("_abundance.tsv", "", files)
  txi <- tximport(files, type = "kallisto", tx2gene = tx2gene, countsFromAbundance="lengthScaledTPM")
  counts <- txi$counts
  setwd(currwd)
  row.names(counts) <- gsub("\\..*", "", row.names(counts))
  write.table(counts, "counts.tsv", sep = '\t')
  return(counts)

#' Extract information from run_info.json files and create a CSV.
#'
#' This function reads run_info.json files from specified data folders, extracts
#' desired fields, and creates a CSV file containing the extracted information.
#'
#' @param data_path Path to the parent folder containing data folders with run_info.json files.
#' @param output_csv Path to the output CSV file to be created.
#'
#' @return NULL (creates a CSV file with extracted information).
#'
#' @examples
#' data_path <- "/well/powrie/users/cqh100/work/mouse_rna_seq/kallisto/combined/kallisto.dir/DATA_FOLDERS_HERE"
#' output_csv <- "/path/to/output/result.csv"
#' extract_and_create_csv(data_path, output_csv)
#'
extract_and_create_csv <- function(data_path, output_csv) {
  # Get a list of all folders
  folder_list <- list.files(data_path, full.names = TRUE)
  
  # Initialize an empty data frame to store the extracted information
  result_df <- data.frame()
  
  # Loop through each folder
  for (folder in folder_list) {
    # Read the JSON file
    json_path <- file.path(folder, "run_info.json")
    if (file.exists(json_path)) {
      json_data <- fromJSON(json_path)
      
      # Extract desired fields
      extracted_data <- data.frame(
        folder = folder,
        n_targets = json_data$n_targets,
        n_bootstraps = json_data$n_bootstraps,
        n_processed = json_data$n_processed,
        n_pseudoaligned = json_data$n_pseudoaligned,
        n_unique = json_data$n_unique,
        p_pseudoaligned = json_data$p_pseudoaligned,
        p_unique = json_data$p_unique,
        kallisto_version = json_data$kallisto_version,
        index_version = json_data$index_version,
        start_time = json_data$start_time,
        call = json_data$call
      )
      
      # Append to the result data frame
      result_df <- rbind(result_df, extracted_data)
    }
  }
  
  # Write the result data frame to a CSV file
  write.csv(result_df, file = output_csv, row.names = FALSE)
  
  # Print a message indicating completion
  cat("CSV file created:", output_csv, "\n")
}

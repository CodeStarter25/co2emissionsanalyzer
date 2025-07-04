#' Downloading Energy Data File
#' 
#' Downloads Excel(.xlsx) file for CO2 emissions data based on energy types 
#' selected by the user. Available options include: "Coal", "Natural gas", 
#' "Petroleum" or "Total". 
#' 
#' @return No return value. Excel file is saved to disk and messages are printed to 
#' inform user of progress. 
#' @importFrom utils download.file
#' @importFrom glue glue
#' @examples
#' # download_energy_file() 
#' 
#' @export
download_energy_file <- function() {
  
  # Define your folder
  data_folder <- file.path(getwd(), "data")
  message("Setting up folder for data storage...")
  
  # Create folder if it doesn't exist
  if (!dir.exists(data_folder)) {
    dir.create(data_folder, recursive = TRUE)
    message("Created data folder: ", data_folder)
  }
  
  # Sets path for the file to be download
  message ("Preparing download path...")
  file_path <- file.path(data_folder, DEFAULT_EMISSION_FILENAME)
  
  # Sets URL for website to download the file from
  url <- "https://www.eia.gov/state/seds/sep_sum/html/xls/co2_source.xlsx"
  
  # Download the file to the specified folder and file name
  message (glue("Downloading {DEFAULT_EMISSION_FILENAME}..."))
  
  # Download failures are caught and cause the program to exit immediately
  tryCatch({
    download.file(url, file_path, mode = "wb", quiet = TRUE)
    }, error = function(e) {
      message(glue("Failed to download {DEFAULT_EMISSION_FILENAME}. Error: {e$message}"))
      stop("Exiting program...")
    })
    
  # Informs user that download complete and location
  message("Data successfully downloaded to: ", file_path)
  message("Processing data next...")
  
  # Invisible returns NULL to end function
  invisible(NULL)
}

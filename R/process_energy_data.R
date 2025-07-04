#' Emission Data Loading, Cleaning & Filtering
#' 
#' Loads, cleans and filters emissions data for one or more energy type(s)
#' and selected state. Data is cleaned by removing unwanted rows and columns, 
#' and transforming to long format for easier analysis and plotting. Includes 
#' checks for function to operate independently. Defaults set when running
#' co2emissionanalyzer().
#'  
#' @param energy_type A character vector of one or more energy types (e.g. 
#' c("Coal", "Natural gas", "Petroleum", "Total") or any variation of this 
#' format.
#' @param us_state A character string specifying the US state or whole US to 
#' filter by.
#' @param start_year A numerical value indicating the start of the 
#' filtering range. Defaults to first available value in the data if NA, NULL 
#' or empty when co2emissionanalyzer() is used first.
#' @param end_year A numerical value indicating the end of the 
#' filtering range. Defaults to first available value in the data if NA, NULL 
#' or empty when co2emissionanalyzer() is used first.
#' @return A named list of filtered data frames, keyed by energy type.
#' @importFrom glue glue
#' @importFrom dplyr filter
#' @examples
#' # process_energy_data(c("Coal", "Petroleum", "Total"), "ca", 1980, 2020)
#' 
#' @export
process_energy_data <- function(energy_type, us_state, start_year, end_year) {
  
  # Checks if any input value is valid
  if (is_blank_check(energy_type)) {
    stop("No energy type provided. \n Exiting program...")
  } else if(is_blank_check(start_year)) {
    stop("Invalid or blank input for start year. \n Exiting program...")
  } else if(is_blank_check(end_year)){
    stop("Invalid or blank input for end year. \n Exiting program...")
  }
  
  # Look-up for state and exiting program if incorrect
  if (!((us_state) %in% names(VALID_STATES))) {
    stop("State code not recognized. Valid examples: 'ca' or 'tx' \n Exiting program...")
  } else {
    us_state <- VALID_STATES[[us_state]]
  }
  
  # Define folder and file path for input data; initialize empty result lists 
  data_folder <- file.path(getwd(), "data")
  data_file <- file.path(data_folder, DEFAULT_EMISSION_FILENAME)
  data_list <- list()
  filtered_list <- list()
  
  # Program stops if folder does not exist
  if (!dir.exists(data_folder)) {
    stop(glue("Data folder not found here: {data_folder}. \n Exiting program..."))
  }
  
  # Program stops if file does not exist
  if (!file.exists(data_file)) {
    stop(glue("Data file not found here: {data_file}. \n Exiting program..."))
  }
  
  # Program stops if energy_type is not a list or empty values in list
  if (!(is.character(energy_type))) {
    stop("Invalid input for type (eg. valid input: c('Coal', 'Petroleum', ...)) \n Exiting program...")
  } else if (is_blank_check(energy_type)) {
    stop("No energy types available. \n Exiting program...")
  }
  
  # Program stops if energy_type not in energy list
  if (!all(energy_type %in% ENERGY_OPTIONS)) {
    stop(glue("Invalid energy type in list. Valid options: {ENERGY_OPTIONS}. \n Exiting program..."))
  }
  
  # Cleans the data file based on user input
  for (type in energy_type) {
  data_list[[type]] <- clean_data(type, data_folder)
  message("File processing and cleaning complete.")
  message(glue("Filtering {type} data..."))
  filtered_list[[type]] <- data_list[[type]] |>
    filter(state == us_state) |>
    wide_to_long() |>
    filter(years >= start_year & years <= end_year)
  message(glue("Filtering {type} data complete."))
  }
  
  # Check if no data after filtering, exits program
  if (identical(data_check(filtered_list[[1]]), TRUE)) {
    stop(glue("No data found for {us_state} between {start_year} and {end_year}. \n Exiting program..."))
  }
  
  # Returns list of data
  return(filtered_list)
}
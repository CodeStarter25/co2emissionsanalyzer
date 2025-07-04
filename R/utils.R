#' Utility File Containing Functions Used Throughout The Package
#' 
#' This file contains utility functions that support core package features, 
#' including data validation, transformation, messaging and extraction logic.
#' 
#' @name internal_utils
#' @keywords internal
NULL

# Setting global variables
utils::globalVariables(c("state", "years", "emissions_produced", "energy_type"))

# -----------------------------------------------
#   INTERNAL MESSAGING UTILITY
# -----------------------------------------------

#' Print messaging for user feedback
#' 
#' Simple method to message the user when input is blank or incorrect, and 
#' program defaults are being used.
#' 
#' @param input_text A character string inserted to identify which value is 
#' being defaulted.
#' @param default_val A character string or numeric value used as default.
#' @return No return value. Function prints a message.
#' @importFrom glue glue
#' @keywords internal
#' @examples
#' # invalid_messaging("start year", 1960)

invalid_messaging <- function(input_text, default_val) {
  message(glue("Invalid or empty {input_text}. Assigning program default: {default_val}\n"))
}

# -----------------------------------------------
#   DATA TRANSFORMATION UTILITY
# -----------------------------------------------

#' Clean Emissions Data file
#' 
#' Performs basic cleaning of the Excel file: 
#' - rename headers 
#' - remove unwanted rows/columns
#' - Converts all column and state names to lowercase
#'  
#' @param type A character string of energy types(e.g. "Coal", "Natural_gas", etc.)
#' @param data_folder Path to the directory containing the downloaded Excel 
#' file.
#' @return A cleaned data frame for the given energy type.
#' @importFrom glue glue
#' @importFrom readxl read_excel
#' @importFrom dplyr filter row_number select last_col
#' @examples
#' # Provide a path to the folder containing the file, not the file itself.
#' # clean_data("Coal", path/to/data/folder/with/name/Emission_data)
#' 
#' @export
clean_data <- function(type, data_folder) {
  
  # Message sent to user for clarity on what is happening
  message(glue("Cleaning data for {type}\n"))
  
  # Opens the file for the type of energy table
  temp_data_frame <- suppressMessages(
    read_excel(file.path(data_folder, DEFAULT_EMISSION_FILENAME),
               sheet = type,
               col_names = FALSE,
               .name_repair = "unique")
  )
  
  # Takes the 3rd row and applies them as column names
  # Assumes 3 rows exist. Manual check confirms it
  colnames(temp_data_frame) <- temp_data_frame[3,]
  
  # Makes all column name in the data lowercase
  colnames(temp_data_frame) <- tolower(colnames(temp_data_frame))
  
  # Makes the first column (state names) into lowercase
  temp_data_frame$state <- tolower(temp_data_frame$state)
  
  # Filters out all unnecessary rows and columns
  cleaned_df <- temp_data_frame |>
    filter(!row_number() %in% c(1,2,3))
  
  # Returns the data in a list format
  return(cleaned_df)
}

#' Simple Function To Change Frame Format
#' 
#' Converts a data frame from wide to long format, and converts year values 
#' from character to numeric.
#' 
#' @param dataframe A data frame to transform from wide to long format through 
#' pivot
#' @return A long-format data frame with numeric 'years' and a single 
#' 'emissions_produced' column.
#' @importFrom tidyr pivot_longer
#' @examples
#' # df <- data.frame(state = c("ca", "tx"),
#' #                `2010` = c(100, 200),
#' #                `2011` = c(110, 210))
#' # wide_to_long(df)
#' @export
wide_to_long <- function(dataframe) {
  dataframe <- pivot_longer(dataframe, !state, names_to = "years",
                            values_to = "emissions_produced")
  dataframe$years <- as.numeric(dataframe$years)
  return(dataframe)
}

#' Data Extraction From Processed Data
#' 
#' Extraction of information from a data frame in the list for labeling
#' 
#' @param processed_data A named list of filtered data frames, keyed by energy 
#' type (e.g. "Coal", "Natural_gas", "Petroleum", "Total"). Each data frame 
#' includes "state", years" and "emissions_produced" columns.
#' @return A list of values for labeling diagram and naming files.
#' @examples
#' # processed_data <- process_energy_data(c("Coal"), "ca", 1980, 2020)
#' # extract_data(processed_data)
#' 
#' @export
extract_data <- function(processed_data) {
  df <- processed_data[[1]]
  list(
    state = df$state[1],
    start_year = min(df$years, na.rm = TRUE),
    end_year = max(df$years, na.rm = TRUE)
  )
}

# -----------------------------------------------
#   INPUT VALIDATION UTILITIES
# -----------------------------------------------

#' Simple Function for Data Integrity Check
#' 
#' This function will check if there is any data within the filtered 
#' data based on number of rows available within a data frame.
#' 
#' @param dataframe A data frame after filtering to confirm data availability
#' @return Boolean return based on data availability in data frame. TRUE if data 
#' frame is empty, otherwise FALSE
#' @keywords internal
#' @examples
#' # filtered_list <- process_energy_data(c("Coal"), "tx", 2000, 2010)
#' # data_check(filtered_list[[1]])

data_check <- function(dataframe) {
  nrow(dataframe) == 0
}

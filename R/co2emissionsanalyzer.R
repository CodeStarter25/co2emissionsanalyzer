#' Start the full energy analysis pipeline
#' 
#' This function guides the user through downloading and analyzing of CO2 
#' emissions data by energy resource type and U.S. state. It requires no 
#' initial input, but user is interactively prompted to provide  the necessary
#' parameters for data processing and manipulation.
#' 
#' The emissions data is sourced from U.S. Energy Information Administration at
#' this link: \url{https://www.eia.gov/state/seds/sep_sum/html/xls/co2_source.xlsx}
#' 
#' @return None. Side effects include user interactions, data downloading and 
#' plotting generation.
#' @importFrom stringr str_to_sentence
#' @examples
#' # start_energy_analysis()
#' 
#' @export
start_energy_analysis <- function() {
  # nocov start
  # Welcome messages and intro to the package
  message("Welcome to the CO2 Emissions by Energy Resource Data Tool.\n")
  cat("This program was developed for my CS50R final project.\n")
  cat("You will be prompted to enter values to filter the data based on your preferences.\n")
  cat("Press Enter to skip any prompt. Default values will be used automatically.\n\n")
  cat("The energy options are as follows: Coal, Natural gas, Petroleum or Total (the sum of all previous sources).\n")
  
  # Prompt the user for number of energy types they would like to compare data with
  type_total <- suppressWarnings(
    as.numeric(readline("How many of the energy types would you like to compare (maximum is 4)? "))
  )
  
  # Safeguard that user input is within range of options
  if (is_blank_check(type_total)) { stop("Invalid entry. \n Exiting the program...")}
  if (type_total < DEFAULT_MIN || type_total > DEFAULT_MAX) stop("Allowed between 1 to 4. \n Exiting program...")
  if (type_total > DEFAULT_MIN) cat("Please enter each type one at a time. Invalid entries will be ignored and defaults used if necessary.\n")
  
  # Creates empty list to store validated energy types entered by user
  user_type_v <- character(0)
  for (i in seq(type_total)){
    type <- trimws(str_to_sentence(readline("Enter the type you would like to compare: ")))
    
    # Validation correction for some defaults
    if (type == "Gas" || type == "Natural")  { type <- DEFAULT_GAS }
    if (type_total == DEFAULT_MIN && is_blank_check(type)) { type <- DEFAULT_TYPE }
    
    # Validate user input
    if (!(type %in% ENERGY_OPTIONS)) { 
      cat("Invalid input. Ignoring...\n") 
      next
    } else {
        user_type_v <- append(user_type_v, type)
    }
  }
  
  # If user list is empty, exit the program
  if (is_blank_check(user_type_v)) {
    stop("All inputs are invalid. \n Exiting program...")
  } else {
    energy_type <- user_type_v[!duplicated(user_type_v)]
  }
  
  # Prompts for user input selection, including some support messages for the user
  cat("The States list contains all 50 US states and the District of Columbia (DC).\n")
  cat("You may enter state names in full or 2 letter  abbreviated format.\n")
  cat("Two word names (such as New York) must be entered as single word (newyork) or as abbreviated form(NY or ny).\n")
  user_state_input <- trimws(tolower(readline("Enter State (Default is 'US'): ")))
  start_year <- as.integer(trimws(readline("Enter Start Year (1960-2023): ")))
  end_year <- as.integer(trimws(readline("Enter End Year (1960-2023): ")))
  output <- trimws(tolower(readline("Enter Graphical Output Type (Table or Line): ")))
  
  # User feedback and sets defaults for values if user press Enter only or incorrect values
  if (is_blank_check(user_state_input)) {
    invalid_messaging("State", DEFAULT_USER_STATE)
    user_state_input <- DEFAULT_USER_STATE
  }
  
  if (is_blank_check(start_year) || start_year < DEFAULT_START_YEAR){
    invalid_messaging("start year", DEFAULT_START_YEAR)
    start_year <- DEFAULT_START_YEAR
  } 
  
  if (is_blank_check(end_year) || end_year > DEFAULT_END_YEAR) {
    invalid_messaging("end year", DEFAULT_END_YEAR)
    end_year <- DEFAULT_END_YEAR
  } 
  
  if (start_year > end_year) {
    stop("End year cannot be before start year. \n Exiting program...")
    }
  
  if (is_blank_check(output) || !(output %in% DEFAULT_VISUAL_OUTPUT)) {
    invalid_messaging("graphical output", DEFAULT_OUTPUT )
    output <- DEFAULT_OUTPUT 
    }
  
  
  # Look-up for state and applying default value if empty
  if (!((user_state_input) %in% names(VALID_STATES))) {
    invalid_messaging("state", DEFAULT_USER_STATE)
    us_state <- DEFAULT_USER_STATE
  } else {
    us_state <- VALID_STATES[[user_state_input]]
  }
  
  download_energy_file()
  
  processed_data <- process_energy_data(
    energy_type = energy_type,
    us_state = us_state,
    start_year = start_year,
    end_year = end_year
  )
  
  visualize_energy_data(
    processed_data,
    output = output
    )
  
}
# nocov end

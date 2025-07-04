test_that("Function will create a line diagram", {
  
  # Directories for the data folder and file
  data_folder <- file.path(getwd(), "data")
  data_file <- file.path(data_folder, DEFAULT_EMISSION_FILENAME)
  
  # Check if files and folder exist
  if (!dir.exists(data_folder)) {
    dir.create(data_folder, recursive = TRUE)
    message("Created data folder: ", data_folder)
  }
  
  # Run download function if file does not exist
  if (!file.exists(data_file)) {
    download_energy_file()
  }
  
  # Function requires previous function output as input
  # Setting variable for process_energy_data()
  energy_type <- ENERGY_OPTIONS
  us_state <- DEFAULT_USER_STATE
  start_year <- DEFAULT_START_YEAR
  end_year <- DEFAULT_END_YEAR
  
  # Setting different outputs
  output_1 <- "line"
  
  # Running process_energy_data
  processed_data <- process_energy_data(energy_type, us_state, start_year, end_year)
  
  # File path of where the file will be saved
  data_folder <- file.path(getwd(), "data")
  state <- toupper(us_state)
  timestamp <- format(Sys.time(), "%Y%m%d")
  file_name_diagram <- glue::glue("Energy Emissions Diagram {state} {timestamp}.png")
  output_file_path <- file.path(data_folder, file_name_diagram)
  
  # Testing output_1 is ggplot diagram
  visualize_energy_data(processed_data, output_1)
  
  expect_true(file.exists(output_file_path))
  
})

test_that("Function will create an Excel file", {
  
  # Directories for the data folder and file
  data_folder <- file.path(getwd(), "data")
  data_file <- file.path(data_folder, DEFAULT_EMISSION_FILENAME)
  
  # Check if files and folder exist
  if (!dir.exists(data_folder)) {
    dir.create(data_folder, recursive = TRUE)
    message("Created data folder: ", data_folder)
  }
  
  # Run download function if file does not exist
  if (!file.exists(data_file)) {
    download_energy_file()
  }
  
  # Function requires previous function output as input
  # Setting variable for process_energy_data()
  energy_type <- ENERGY_OPTIONS
  us_state <- DEFAULT_USER_STATE
  start_year <- DEFAULT_START_YEAR
  end_year <- DEFAULT_END_YEAR
  
  # Setting different outputs
  output_2 <- "table"
  
  # Running process_energy_data
  processed_data <- process_energy_data(energy_type, us_state, start_year, end_year)
  
  # File path of where the file will be saved
  data_folder <- file.path(getwd(), "data")
  state <- toupper(us_state)
  timestamp <- format(Sys.time(), "%Y%m%d")
  file_name_excel <- glue("Energy Emissions File {state} {timestamp}.xlsx")
  output_file_path <- file.path(data_folder, file_name_excel)
  
  # Testing output_2 is excel file 
  excel_file <- visualize_energy_data(processed_data, output_2)
  
  # Confirm Null return and file exists
  expect_null(excel_file)
  expect_true(file.exists(output_file_path))
  
  # Confirms row numbers & sheet names
  excel_read <- readxl::read_excel(output_file_path)
  sheet_read <- readxl::excel_sheets(output_file_path)
  expect_equal(nrow(excel_read), end_year - start_year + 1)
  expect_equal(sheet_read, energy_type)
  
})

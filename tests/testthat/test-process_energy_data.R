test_that("process_energy_data will stop is data folder/file not exists", {
  
  # Directories for the data folder and file
  data_folder <- file.path(getwd(), "data")
  data_file <- file.path(data_folder, DEFAULT_EMISSION_FILENAME)
  
  # Removing file/folder if exists
  if (file.exists(data_file)) file.remove(data_file)
  if (dir.exists(data_folder)) unlink (data_folder, recursive = TRUE)
  
  # Check that file and folder are not there
  expect_false(file.exists(data_file))
  expect_false(dir.exists(data_folder))
  
  # Run the function
  download_energy_file()
  
  # Check that folder is created and file is downloaded inside 
  expect_true(dir.exists(data_folder))
  expect_true(file.exists(data_file))
  
})

test_that("process_energy_data returns a list of certain length and named sublist", {
  # Variations of energy types for testing
  energy_type_group1 <- c("Coal", "Petroleum", "Natural gas", "Total")
  energy_type_group2 <- c("Natural gas", "Coal")
  energy_type_group3 <- c("Petroleum")
  
  # Variation of user_state inputs
  us_state_1 <- "us"
  us_state_2 <- "ca"
  us_state_3 <- "dc"

  # Variations of start_year
  start_year_1 <- 1960
  start_year_2 <- 1980
  start_year_3 <- 2000
  
  # Variations of end_year
  end_year_1 <- 2023
  end_year_2 <- 2000
  end_year_3 <- 2010
  
  # Function assignment
  group_1 <- process_energy_data(energy_type_group1, us_state_1, start_year_1, end_year_1)
  group_2 <- process_energy_data(energy_type_group2, us_state_2, start_year_2, end_year_2)
  group_3 <- process_energy_data(energy_type_group3, us_state_3, start_year_3, end_year_3)
  
  # Testing of each group 1
  expect_type(group_1, "list")
  expect_length(group_1, 4)
  expect_named(group_1, energy_type_group1)
  
  # Testing of each group 2
  expect_type(group_2, "list")
  expect_length(group_2, 2)
  expect_named(group_2, energy_type_group2)
  
  # Testing of each group 3
  expect_type(group_3, "list")
  expect_length(group_3, 1)
  expect_named(group_3, energy_type_group3)
  
})

test_that("The function will return errors when", {
  # Variations of energy types for testing
  energy_type_group1 <- c("Coal", "Petroleum", "Natural gas", "Total") # Correct
  energy_type_group2 <- c("Natural gas", "coal") # Wrong. c in "coal" is lower
  energy_type_group3 <- c("") # empty
  
  
  # Variation of user_state inputs
  us_state_1 <- "us" # Correct
  us_state_2 <- "Ca" # Wrong. State should be lowercase
  
  # Variations of start_year
  start_year_1 <- 1960 # Correct
  start_year_2 <- 1940 # Wrong. Out of data range
  start_year_3 <- 2030 # Wrong. Out of data range
  
  # Variations of end_year
  end_year_1 <- 2023 # Correct
  end_year_2 <- 1950 # Wrong. Out of data range
  end_year_3 <- 2060 # Wrong. out of data range
  
  # Mix and matching to give proper error testing
  # Error on energy_type_group2
  expect_error(process_energy_data(energy_type_group2, us_state_1, start_year_1, end_year_1))
  
  # Error on energy_type_group3
  expect_error(process_energy_data(energy_type_group3, us_state_1, start_year_1, end_year_1))
  
  # Error on user_state_2
  expect_error(process_energy_data(energy_type_group1, us_state_2, start_year_1, end_year_1))
  
  # Error on start_year_2 & end_year_2
  expect_error(process_energy_data(energy_type_group1, us_state_1, start_year_2, end_year_2))
  
  # Error on start_year_3 & end_year_3
  expect_error(process_energy_data(energy_type_group1, us_state_1, start_year_3, end_year_3))
  
})
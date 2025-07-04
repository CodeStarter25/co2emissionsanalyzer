# Testing file exists
test_that("download_energy_file creates a data folder and downloads file", {
  
  # If user is offline, download fails
  skip_if_offline()
  
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

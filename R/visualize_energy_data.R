#' Visualization of CO2 Emissions by Energy Type
#' 
#' Graphically representing CO2 emissions by the different or all energy 
#' resources based on user requirements. Users can generate a line diagram 
#' saved as an image, or an Excel file with tabular emissions data for 
#' each energy type. This function is based on the previous output from
#' process_energy_data.
#' 
#' @param processed_data A named list of filtered data frames, keyed by energy 
#' type (e.g. "Coal", "Natural_gas", "Petroleum", "Total"). Each data frame 
#' includes "state", "years" and "emissions_produced" columns.
#' @param output A string specifying the desired output type. Options 
#' are "line" (for a graphical line diagram) or "table" (for an Excel output)
#' Default is "line".
#' @return If output = "line", displays completion message and print 
#' last ggplot created. If output = "table", saves an Excel file and displays 
#' completion message to user. In both cases, **invisible NULL is returned**.
#' @importFrom dplyr bind_rows
#' @importFrom ggplot2 aes element_text geom_line ggplot ggsave labs 
#' scale_x_continuous scale_y_continuous theme theme_classic
#' @importFrom glue glue
#' @importFrom stringr str_replace_all str_to_title
#' @importFrom writexl write_xlsx
#' @examples
#' # Before running, make sure to download the data:
#' # download_energy_file()
#' 
#' # Then process the data:
#' # processed <- process_energy_data(c("Coal", "Total"), "ca", 1980, 2020)
#' 
#' # Finally visualize it:
#' # visualize_energy_data(processed, "line")
#' 
#' @export
visualize_energy_data <- function(processed_data, output) {
  
  # Checks inputs for blanks as standalone function
  if (is_blank_check(processed_data)) {
    message("Please run previous function before this one.")
    stop("Processed data not available. \nExiting program...")
  } 
  
  if (!(tolower(output) %in% DEFAULT_VISUAL_OUTPUT)) {
    stop("Output option (table or line) not available. \nExiting program...")
  }
  
  # Extraction of data from processed data list and assigning
  extracted_data <- extract_data(processed_data)
  state <- toupper(extracted_data$state)
  start_year <- extracted_data$start_year
  end_year <- extracted_data$end_year
  
  # Define data folder location; setting path for Excel file; date/time-stamp
  data_folder <- file.path(getwd(), "data")
  timestamp <- format(Sys.time(), "%Y%m%d")
  file_name_diagram <- glue("Energy Emissions Diagram {state} {timestamp}.png")
  file_name_excel <- glue("Energy Emissions File {state} {timestamp}.xlsx")
  output_file_path <- file.path(data_folder, file_name_excel)
  
  # If user requested line diagram for data
  if (output == "line") {
    
    # Messages the user for latest updates
    message("Preparing data for graphic generation...")
    
    # Adding a column to identify the data for graphical use
    for (energy_name in names(processed_data)) {
      processed_data[[energy_name]]$energy_type <- energy_name
    }
    
    # Binding all list(s) for graphical use
    combined_dfs <- bind_rows(processed_data)
    
    # Messages the user for latest updates
    message("Generating diagram...")
    
    # Set X-axis and Y-axis breaks dynamically based on range
    if ((end_year - start_year) >= 30) {
      x_break_step <- 10
      } else if ((end_year - start_year) < 30 && (end_year - start_year) >= 15 ) { 
        x_break_step <- 5
      } else { x_break_step <- 1 }
    
    max_emission <- max(combined_dfs$emissions_produced, na.rm = TRUE)
    upper_limit <- ceiling(max_emission / 100) * 100

    # Characteristics of graphical diagram
    graphical_diagram <- ggplot (
      combined_dfs, 
      aes(x = years, 
          y = emissions_produced, 
          colour = energy_type)) +
      geom_line(
        linetype = 1,
        linewidth = 0.8
      ) +
      labs(
        x = "Years",
        y = "Emissions (million metric tons of CO2)",
        title = glue("{state} CO2 Emissions by Energy Type from {start_year} to {end_year}"),
        colour = "Energy Type"
        ) +
      # Scales the x & y axis
      scale_x_continuous(
        breaks = seq(start_year, end_year, by = x_break_step)) +
      scale_y_continuous(
        limits = c(0, upper_limit),
        breaks = pretty(c(0, upper_limit))
        ) +
      # Sets the theme for the graph and rotates X-axis labels
      theme_classic() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    message(glue("Diagram complete. Saving to: {data_folder}"))
    
    print(graphical_diagram)
    
    # Saves the diagram for the user with date/time-stamp
    suppressWarnings(
      ggsave(filename = file_name_diagram, 
             plot = graphical_diagram,
             path = data_folder,
             width = PLOT_WIDTH, height = PLOT_HEIGHT, dpi = PLOT_DPI
             )
      )
    
    # Messages user of save complete and program end
    message("Diagram saved!")
    message("Analysis complete.")
    
  } else {
    
    # Messages the user for latest updates
    message("Preparing data for excel sheet...")
    
    # Formatting data frames before writing to Excel
    for (energy_name in names(processed_data)) {
      temp_df <- processed_data [[energy_name]]
      
      # Column names formatting
      colnames(temp_df) <- colnames(temp_df) |>
        str_replace_all("_", " ") |>
        str_to_title()
      
      # State column becomes Uppercase
      temp_df$State <- toupper(temp_df$State)
      
      # Returns data frame to list
      processed_data[[energy_name]] <- temp_df
    }    
    
    # Messages the user for latest updates
    message("Printing data to Excel file...")
    
    # Writes the data to excel sheet. If multiple lists, each list on a sheet
    suppressWarnings (
      write_xlsx(
        processed_data,
        path = output_file_path,
        col_names = TRUE,
        format_headers = TRUE
        )
    )
    
    # Message for user on path to find excel sheet and function completion
    message(glue("File saved here: {data_folder} \nFile name: {file_name_excel}"))
    message("Analysis complete.")
    
    }    
  
  # Invisible returns NULL to end function
  invisible(NULL)

}


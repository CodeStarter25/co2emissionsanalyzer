# CO&#8322; Emissions Analyzer

<!-- badges: start -->

[![R-CMD-check](https://github.com/CodeStarter25/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/CodeStarter25/co2emissionsanalyzer/actions/workflows/R-CMD-check.yaml) [![Codecov test coverage](https://codecov.io/gh/CodeStarter25/co2emissionsanalyzer/graph/badge.svg)](https://app.codecov.io/gh/CodeStarter25/co2emissionsanalyzer) <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT" />

<!-- badges: end -->

<p>&nbsp;</p>

---

## 🎥 Video

[Watch the demo](https://youtu.be/Fge4xfNYxCM)

<p>&nbsp;</p>

---

## 📘 Introduction

As part of my CS50R final project, I’ve developed an R package that allows users to **download, process, and visualize CO&#8322; emissions** data for U.S. states or nationally. The data includes annual emissions from **Coal**, **Natural Gas**, and **Petroleum** between **1960 and 2023**.

Data is sourced from the U.S. Energy Information Administration (EIA):  
👉 [View Excel Source](https://www.eia.gov/state/seds/sep_sum/html/xls/co2_source.xlsx)

> ⚠️ **Note:** This package works as of the current EIA Excel format. If that file changes in structure, the functions may require adjustments.

<p>&nbsp;</p>

---

## ⚙️ How It Works

This package provides a complete workflow, or you can run individual functions manually:

1. Prompts user for emission types, date range, location (state/national), and output format.
2. Downloads the data into a local folder.
3. Processes and filters it based on user inputs.
4. Outputs either:
   - A **line plot** (.png)
   - A **summary table** (.xlsx)

<p>&nbsp;</p>

---

## 📦 Installation

To install from GitHub:

```r
# If devtools is not installed
install.packages("devtools")

# Install this package
devtools::install_github("CodeStarter25/co2emissionsanalyzer")
```
<p>&nbsp;</p>

---
## 🧠 Command Breakdown

### `start_energy_analysis()`

This is the main entry point for the package. It provides guided prompts for:

- **Energy Sources**: `Coal`, `Natural Gas`, `Petroleum`, or `Total`
- **Location**: US State (2-letter code, e.g. `ca`) or `National`
- **Year Range**: Start Year (≥ 1960) and End Year (≤ 2023)
- **Output Type**: 
  - `Table` → Excel (.xlsx) file
  - `Line` → Line graph (.png)

If the user presses Enter without input, default values will be applied — except for energy sources (which are mandatory). If no energy source is selected, the program exits.

---

### `download_energy_file()`

**Purpose**: Downloads the raw Excel data from the U.S. EIA.

- Automatically checks for a `data` folder and creates it if missing.
- Downloads the CO₂ emissions Excel file into this folder.
- Saves file as: `Emissions_data.xlsx`
- **Returns**: `invisible(NULL)`

✅ This function can be used independently.

---

### `process_energy_data()`

**Required Inputs**:

```r
energy_type  # character vector, e.g., c("Coal", "Petroleum")
us_state     # 2-letter lowercase code, e.g., "ca"
start_year   # Integer, starting year
end_year     # Integer, ending year
```

**Function Workflow**:

- Validates user inputs  
- Confirms data file presence  
- Loads and cleans the Excel dataset  
- Filters based on inputs  
- Returns a list of filtered data frames: `processed_data`

> ⚠️ This function can be used standalone only if:
> - Valid inputs are given  
> - `Emissions_data.xlsx` exists in the `data/` folder


✅ Recommend: Run `download_energy_file()` first.

---

### `visualize_energy_data()`

**Required Inputs**:

```r
processed_data  # Result from process_energy_data()
output          # "line" for graph or "table" for Excel
```
**Function Workflow**:

- Validates input structure  
- Extracts and formats labeling data  
- Generates and saves either:  
  - `.xlsx` table (summary)  
  - `.png` line plot (visualization)  
- Files are saved into the `data/` folder  
- **Returns**: `invisible(NULL)`

> ⚠️ This function can be used standalone only if:  
> - Valid input (processed_data) is passed  
> - Data file exists in `data/` folder

✅ Recommended: Run the previous 2 functions:  
- `download_energy_file()`  
- `process_energy_data()`

<p>&nbsp;</p>

---

## 📊 Data Source

---

Data provided by the **U.S. Energy Information Administration (EIA)**  
🔗 [Download Excel Dataset](https://www.eia.gov/state/seds/sep_sum/html/xls/co2_source.xlsx)

<p>&nbsp;</p>

---

## 📄 License

---

MIT License

<p>&nbsp;</p>

---

## 📨 Contact

---

For questions or feedback, [open an issue](https://github.com/CodeStarter25/co2emissionsanalyzer/issues)

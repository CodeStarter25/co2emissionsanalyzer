#' Constants For Quick Use
#' 
#' These constants define default values used throughout the package for 
#' user input validation, in cases of incorrect, incomplete or blank inputs. 
#' Some are exported for user access while others are set to internal. 
#' 
#' @docType data
#' @name co2_constants
#' @keywords internal
NULL

#' Energy options allowed by user
#' @keywords internal
ENERGY_OPTIONS <- c("Coal", "Natural gas", "Petroleum", "Total") 

#' List of 50 US States & District of Columbia
#' @keywords internal
# Build valid states list with both abbreviations and full names
VALID_STATES <- c(
  # Abbreviations pointing to themselves
  ak = "ak", al = "al", ar = "ar", az = "az", ca = "ca", co = "co",
  ct = "ct", dc = "dc", de = "de", fl = "fl", ga = "ga", hi = "hi",
  ia = "ia", id = "id", il = "il", "in" = "in", ks = "ks", ky = "ky",
  la = "la", ma = "ma", md = "md", me = "me", mi = "mi", mn = "mn",
  mo = "mo", ms = "ms", mt = "mt", nc = "nc", nd = "nd", ne = "ne",
  nh = "nh", nj = "nj", nm = "nm", nv = "nv", ny = "ny", oh = "oh",
  ok = "ok", or = "or", pa = "pa", ri = "ri", sc = "sc", sd = "sd",
  tn = "tn", tx = "tx", ut = "ut", va = "va", vt = "vt", wa = "wa",
  wi = "wi", wv = "wv", wy = "wy",
  
  # Full names & smashed names -> abbreviation
  alaska = "ak", alabama = "al", arkansas = "ar", arizona = "az", 
  california = "ca", colorado = "co", connecticut = "ct", 
  "district of columbia" = "dc", districtofcolumbia = "dc", columbia = "dc", 
  district = "dc", districtcolumbia = "dc", delaware = "de", florida = "fl", 
  georgia = "ga", hawaii = "hi", iowa = "ia", idaho = "id", illinois = "il", 
  indiana = "in", kansas = "ks", kentucky = "ky", louisiana = "la", 
  massachusetts = "ma", maryland = "md", maine = "me",  michigan = "mi", 
  minnesota = "mn", missouri = "mo", mississippi = "ms", 
  montana = "mt", "north carolina" = "nc", northcarolina = "nc", 
  "north dakota" = "nd", northdakota = "nd", nebraska = "ne", 
  "new hampshire" = "nh", newhampshire = "nh", "new jersey" = "nj", 
  newjersey = "nj", "new mexico" = "nm", newmexico = "nm", nevada = "nv", 
  "new york" = "ny", newyork = "ny", ohio = "oh", oklahoma = "ok", 
  oregon = "or", pennsylvania = "pa", "rhode island" = "ri", rhodeisland = "ri",
  "south carolina" = "sc", southcarolina = "sc", "south dakota" = "sd",
  southdakota = "sd", tennessee = "tn", texas = "tx", utah = "ut", 
  virginia = "va", vermont = "vt", washington = "wa", wisconsin = "wi", 
  "west virginia" = "wv", westvirginia = "wv", wyoming = "wy",
  
  # Aliases for US become "us"
  us = "us", usa = "us", allus = "us", all_us = "us", "all usa" = "us",
  "us total" = "us", "united states" = "us", "state total" = "us", 
  "all state" = "us", state = "us", united = "us", states = "us",
  america = "us", us_total = "us", ustotal = "us", unitedstates = "us"
)

#' Default Exported Values For Data
#' 
#' These constants define default values used across the package
#' when the users enters incorrect values, incomplete, or blank inputs.
#' @name DEFAULT_EXT_VALUES
#' @rdname DEFAULT_EXT_VALUES
#' @export
DEFAULT_TYPE <- "Total"

#' @rdname DEFAULT_EXT_VALUES
#' @export
DEFAULT_USER_STATE <- "us"

#' @rdname DEFAULT_EXT_VALUES
#' @export
DEFAULT_START_YEAR <- 1960

#' @rdname DEFAULT_EXT_VALUES
#' @export
DEFAULT_END_YEAR <- 2023

#' @rdname DEFAULT_EXT_VALUES
#' @export
DEFAULT_OUTPUT <- "line"

#' Default Internal Values For Logic & Validation
#' 
#' These constants define internal safeguards across the package for user
#' input validation and logic handling.
#' @name DEFAULT_INT_VALUES
#' @rdname DEFAULT_INT_VALUES
#' @keywords internal
DEFAULT_EMISSION_FILENAME <- "Emission_Data.xlsx"

#' @rdname DEFAULT_INT_VALUES
#' @keywords internal
DEFAULT_GAS <- "Natural gas"

#' @rdname DEFAULT_INT_VALUES
#' @keywords internal
DEFAULT_MIN <- 1

#' @rdname DEFAULT_INT_VALUES
#' @keywords internal
DEFAULT_MAX <- 4

#' @rdname DEFAULT_INT_VALUES
#' @keywords internal
PLOT_WIDTH <- 8

#' @rdname DEFAULT_INT_VALUES
#' @keywords internal
PLOT_HEIGHT <- 6

#' @rdname DEFAULT_INT_VALUES
#' @keywords internal
PLOT_DPI <- 300

#' @rdname DEFAULT_INT_VALUES
#' @keywords internal
DEFAULT_VISUAL_OUTPUT <- c("line", "table")

#' Simple Function to Check Inputs are Valid
#' 
#' This function will check if there is any blank, NA or NULL values in the 
#' inputs for the function to work independently. 
#' 
#' @param input An input of any type for checking input validity
#' @return Boolean return based on validity of input. TRUE if input is any of 
#' blank, NA or NULL, otherwise FALSE.
#' @keywords internal
#' @examples
#' # is_blank_check("Coal")  # Returns FALSE
#' # is_blank_check("")  # Returns TRUE

is_blank_check <- function (input) {
  is.null(input) || length(input) == 0 || all(is.na(input)) || all(input == "")
}

# Functions for downloading and extracting data as well as reading it back into memory.

zipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
processedFile <- "household_power_consumption_processed.RData"
rawFile <- "household_power_consumption.txt"
dataPath <- "."
relevantDates <- c("1/2/2007", "2/2/2007")

# Reads and processed data containing only the relevant dates. Data will be downloaded and processed if
# necessary.
readData <- function() {
  # Check if data has already been loaded and exists in the workspace.
  # If that's the case we don't need to load it again.
  if(exists("plotData")){
    message("Using previously loaded data.")
    return(plotData)
  }
  
  # Download, unzip and extract relevant data if necessary.
  prepareData()
  
  message("Loading data into plotData...")
  processedFilePath <- file.path(dataPath, processedFile)
  load(processedFilePath)
  return(plotData)
}

# Downloads data and extracts data for the relevant dates and stores extracted data in a separate file.
# If the raw file does not exist, the zip-file will be downloaded and unzipped. The unzipped file is referred 
# to as the 'raw file'.
# The data for the two relevant dates will be read into a data frame. A new file, referred to as 
# the 'processed file' will be created as a dump if the data frame containing only the two relevant days.
# If both the complete raw file and the processed file already exist, nothing is done. If the raw file exists,
# but the processed file is missing. The existing raw file will be used to create a new processed file.
# Note that, if the raw file is missing and the processed file exists, a new raw file will be downloaded and the
# a new processed file will be created, overwriting the existing processed file.
prepareData <- function() {
  
  # Download data if necessary.
  didDownload <- downloadData()
  
  processedFilePath <- file.path(dataPath, processedFile)
  
  if (!didDownload && file.exists(processedFilePath)) {
    # Both the raw file and the processed file already exist, so nothing to do.
    message("Processed file already exists.")
    return()
  }
  
  # The raw file or the processed file did not exist, so we must (re-)create the processed file.
  message("Processing data...")
  processData(relevantDates)
}

# Downloads and unzips data if unzipped file does not already exist. Returns a value indicating
# whether file was downloaded and unzipped.
downloadData <- function() {
  
  rawFilePath <- file.path(dataPath, rawFile)
  
  if (file.exists(rawFilePath)) {
    message("Raw file already exists, reusing that file.")
    return(FALSE)
  }
  
  # Create temporary file name for storing the zip file
  temp <- tempfile()
  
  # Download the zip file
  message("Downloading...")
  download.file(zipUrl ,temp,"curl")
  
  # Unzip the zipzipUrlle
  message("Unzipping...")
  unzip(temp, rawFile)
  
  # Delete the temporary file
  message("Cleaning up...")
  unlink(temp)
  
  return(TRUE)
}

# Processes data by extracting data for specified dates, putting it in a data frame and saving data frame to disk. 
processData <- function(dateStrings) {
  
  # Read only the data for specified dates into a data frame
  plotData <- readRawFile(dateStrings)
  
  # Create a DateTime column containing both date and time as POSIXct.
  dateTimeStrings <- paste(plotData$Date, plotData$Time)
  plotData$DateTime <- as.POSIXct(dateTimeStrings, format="%d/%m/%Y %H:%M:%S")
  
  # Save the data frame
  message("Saving processed data...")
  processedFilePath <- file.path(dataPath, processedFile)
  save(plotData, file = processedFilePath)
}

# Reads only the data for specified datestrings into a data frame and returns thed data frame.
readRawFile <- function(dateStrings) {
  message("Reading relevant data from raw file...")
  
  awkFilter <- buildAwkFilter(dateStrings)
  
  plotData <- read.table(
    pipe(awkFilter),
    header = TRUE,
    stringsAsFactors = FALSE,
    sep = ";",
    na.strings = "?")
  
  return(plotData)
}

# Build an awk command for extracting only the specified dates and the header.
buildAwkFilter <- function(dateStrings) {
  orExpressions <- paste(
    lapply(dateStrings, function(dateString) {
      paste("$1 == \"", dateString, "\" ||", sep = "")
    }),
    collapse = " "
  )
  
  rawFilePath <- file.path(dataPath, rawFile)
  
  paste("awk 'BEGIN {FS=\";\"} {",
        "if (",
        orExpressions,
        "$1 == \"Date\") print $0",
        "}' ",
        rawFilePath)
}


## Renaming file example

# Get list of files
setwd("C://Users//vr292//Desktop//paired-pointCount-acoustics//data//summer-acoustic-data//")
# Get list of files
files <- list.files(pattern = "\\.WAV$")

# Function to transform filename
transform_filename <- function(filename) {
  # Remove file extension first
  base_name <- tools::file_path_sans_ext(filename)
  
  # Split the filename by underscore
  parts <- strsplit(base_name, "_")[[1]]
  
  # Extract the components:
  date <- parts[1]          # first part (date)
  time_code <- parts[4]     # fourth part (time code)
  station <- parts[3]       # third part (station ID)
  
  # Create new filename with extension
  new_name <- paste0(date, "_", time_code, "_", station, ".WAV")
  
  return(new_name)
}

# Create vector of new names
new_names <- sapply(files, transform_filename)

# Preview the changes
changes <- data.frame(
  Original = files,
  New = new_names,
  stringsAsFactors = FALSE
)
print(changes)

# Confirm with user
cat("\nDo you want to proceed with renaming? (y/n)\n")
answer <- readline()

if(tolower(answer) == "y") {
  # Rename files
  for(i in seq_along(files)) {
    file.rename(files[i], new_names[i])
  }
  cat("Files renamed successfully!\n")
} else {
  cat("Operation cancelled.\n")
}


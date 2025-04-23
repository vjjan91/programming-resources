# Install and load required packages
install.packages("tuneR")
library(tuneR)

# Set your working directory to where the audio files are located
setwd("path/to/your/audio/files")

# Get list of files
part_a_files <- list.files(pattern = ".*_PARTA\\.WAV$")
part_b_files <- list.files(pattern = ".*_PARTB\\.WAV$")

# Function to extract station ID and time code
get_matching_key <- function(filename) {
  # Extract the parts after splitting by underscore
  parts <- strsplit(filename, "_")[[1]]
  # Get station ID and time code (last two parts before PARTA/PARTB)
  station_id <- parts[length(parts)-2]
  time_code <- parts[length(parts)-1]
  return(paste(station_id, time_code, sep="_"))
}

# Function to create new filename format
create_new_filename <- function(filename) {
  parts <- strsplit(filename, "_")[[1]]
  date <- parts[1]  # YYYYMMDD
  time_code <- parts[length(parts)-1]
  station_id <- parts[length(parts)-2]
  return(paste(date, time_code, station_id, sep="_"))
}

# Find matching pairs
find_pairs <- function() {
  pairs <- list()
  
  for(a_file in part_a_files) {
    key_a <- get_matching_key(a_file)
    
    # Find matching PARTB file
    for(b_file in part_b_files) {
      key_b <- get_matching_key(b_file)
      
      if(key_a == key_b) {
        pairs[[key_a]] <- c(a_file, b_file)
        cat("Found pair for:", key_a, "\n")
        break
      }
    }
  }
  return(pairs)
}

# Find pairs
pairs <- find_pairs()
cat("\nTotal pairs found:", length(pairs), "\n")

# If pairs are found, proceed with merging
if(length(pairs) > 0) {
  # Create output directory
  dir.create("merged_files", showWarnings = FALSE)
  
  # Function to merge files
  merge_parts <- function(pair) {
    tryCatch({
      # Read both parts
      wave_a <- readWave(pair[1])
      wave_b <- readWave(pair[2])
      
      # Combine the two parts
      merged <- bind(wave_a, wave_b)
      
      # Create new filename in the required format
      new_name <- create_new_filename(pair[1])
      output_file <- file.path("merged_files", paste0(new_name, ".WAV"))
      
      # Save merged file
      writeWave(merged, output_file)
      
      cat("Successfully merged:", pair[1], "and", pair[2], "\n")
      cat("Saved as:", output_file, "\n")
      return(TRUE)
    }, error = function(e) {
      cat("Error processing", pair[1], "and", pair[2], ":", e$message, "\n")
      return(FALSE)
    })
  }
  
  # Process all pairs
  results <- sapply(pairs, merge_parts)
  
  # Print summary
  cat("\nSuccessfully merged", sum(results), "pairs of files\n")
} else {
  cat("No matching pairs found. Please check file naming pattern.\n")
}
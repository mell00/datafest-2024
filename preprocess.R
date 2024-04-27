library(caret)  # for data splitting and pre-processing

source("data.r")

# Pre-process the data

# Replace NA values with 0 in specific columns
check_eoc_process <- check_eoc_sorted %>%
  mutate(EOC = replace_na(EOC, 0),
         n_possible = replace_na(n_possible, 0),
         n_correct = replace_na(n_correct, 0),
         n_attempt = replace_na(n_attempt, 0))

# Omitting rows with NA values in specific columns
check_pulse_process <- check_pulse_sorted %>%
  pivot_wider(
    names_from = construct,      # Column that contains the names for the new columns
    values_from = response,       # Column that contains the values for the new columns
    values_fn = list(response = mean)  # or any other function as necessary
  )

#



# Convert factors, handle missing values, etc.
#data$variable <- as.factor(data$variable)  # Example for converting to factor
#data <- na.omit(data)  # Removing rows with missing data

# Splitting the dataset into training and testing sets
set.seed(42)  # for reproducibility
trainIndex <- createDataPartition(data$target_variable, p = .7, list = FALSE)
trainData <- data[trainIndex,]
testData <- data[-trainIndex,]
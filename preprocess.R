library(caret)  # for data splitting and pre-processing
library(dplyr)
library(purrr)
library(tidyr)

source("data.r")

# Pre-process the data

# Replace NA values with 0 in specific columns

check_eoc_process <- check_eoc_sorted[1:2000, ] %>%
  mutate(EOC = replace_na(EOC, 0),
         n_possible = replace_na(n_possible, 0),
         n_correct = replace_na(n_correct, 0),
         n_attempt = replace_na(n_attempt, 0))

check_eoc_process <- check_eoc_process %>%
  rename(
    chapter_number_EOC = chapter_number,
    book_EOC = book,
    ratio_correct = EOC
  )

# Omitting rows with NA values in specific columns

check_pulse_process <- check_pulse_sorted[1:2000, ] %>%
  pivot_wider(
    names_from = construct,      # Column that contains the names for the new columns
    values_from = response,       # Column that contains the values for the new columns
    values_fn = list(response = mean)  # or any other function as necessary
  )

check_pulse_process <- check_pulse_process %>%
  rename(
    chapter_number_pulse = chapter_number,
    book_pulse = book,
    release_pulse = release
  )

# media_views organized by student_id, chapter, and section
#

media_views_process <- media_views_sorted[1:2000, ] %>%
  group_by(student_id, chapter_number, section_number)

media_views_timeseries <- media_views_process %>%
  arrange(student_id, chapter_number, section_number)  # Ensure data is sorted by date or another time variable

media_views_timeseries <- media_views_timeseries %>%
  rename(
    chapter_media = chapter,
    chapter_number_media = chapter_number,
    section_number_media = section_number,
    book_media = book,
    release_media = release,
    pg_media = page,
    review_flag_media = review_flag
  )

# page_views organized

page_views_process <- page_views_sorted[1:2000,] %>%
  group_by(student_id, chapter_number, section_number)

page_views_timeseries <- page_views_process %>%
  arrange(student_id, chapter_number, section_number)

page_views_timeseries <- page_views_timeseries %>%
  rename(
    chapter_page = chapter,
    chapter_number_page = chapter_number,
    section_number_page = section_number,
    book_page = book,
    release_page = release,
    pg_page = page,
    review_flag_page = review_flag
    
  )


# Splitting the dataset into training and testing sets
set.seed(42)  # for reproducibility
trainIndex <- createDataPartition(data$target_variable, p = .7, list = FALSE)
trainData <- data[trainIndex,]
testData <- data[-trainIndex,]

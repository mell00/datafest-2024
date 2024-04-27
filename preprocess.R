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
    ratio_correct = EOC
  )

unique_ids_eoc <- unique(check_eoc_process$student_id)
filtered_ids_pulse <- check_pulse_sorted %>%
  filter(student_id %in% unique_ids_eoc)
filtered_media_views <- media_views_sorted %>%
  filter(student_id %in% unique_ids_eoc)
filtered_page_views <- page_views_sorted %>%
  filter(student_id %in% unique_ids_eoc)

# Omitting rows with NA values in specific columns

check_pulse_process <- filtered_ids_pulse %>% na.omit() %>%
  pivot_wider(
    names_from = construct,      # Column that contains the names for the new columns
    values_from = response,       # Column that contains the values for the new columns
    values_fn = list(response = mean)  # or any other function as necessary
  )

check_pulse_process <- check_pulse_process %>%
  rename(
    release_pulse = release
  )

# media_views organized by student_id, chapter, and section

media_views_process <- filtered_media_views %>%
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

page_views_process <- filtered_page_views %>%
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


#-------------------------------------

# Performing the inner join based on 'student_id'
joined_pulse_eoc <- inner_join(check_pulse_process, check_eoc_process, by = c("chapter_number", "student_id", "book", "class_id"))

# Optional: Specify additional processing or selection of columns as needed
# For example, to select specific columns you can use:
joined_pulse_eoc %>% select(student_id, chapter_number, everything())

joined_pulse_eoc %>% group_by("chapter_number") %>% summarize()

joined_pulse_eoc <- joined_pulse_eoc %>%
  select(student_id, chapter_number, everything()) %>%
  arrange(student_id, chapter_number)  # Sorting by student_id and chapter_number for clarity

# Optionally, you could also create a more structured list or grouped data frame:
joined_pulse_eoc <- joined_pulse_eoc %>%
  group_by(student_id, chapter_number) %>%
  summarise_all(list)  # Collecting all data under each student_id and chapter_number combination


#-------------------------------------


# Splitting the dataset into training and testing sets
set.seed(42)  # for reproducibility
trainIndex <- createDataPartition(data$target_variable, p = .7, list = FALSE)
trainData <- data[trainIndex,]
testData <- data[-trainIndex,]

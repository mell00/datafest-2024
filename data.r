library(tidyverse)

checkpoints_eoc <- read.csv("checkpoints_eoc.csv", header = TRUE, sep = ",")

# Sorting the data by book and chapter_number
check_eoc_sorted <- checkpoints_eoc %>%
  arrange(book, chapter_number, student_id)

# Inspecting the sorted data
glimpse(check_eoc_sorted)

checkpoints_pulse <- read.csv("checkpoints_pulse.csv", header = TRUE, sep = ",")

#Sort data
check_pulse_sorted <- checkpoints_pulse %>%
  arrange(book, release, chapter_number, student_id)

# Inspecting the sorted data
glimpse(check_pulse_sorted)

media_views <- read.csv("media_views.csv", header = TRUE, sep = ",")
media_views_sorted <- media_views %>%
  arrange(book, release, chapter_number, student_id)


# Inspecting the sorted data
glimpse(media_views_sorted)

page_views <- read.csv("page_views.csv", header = TRUE, sep = ",")
page_views_sorted <- page_views %>%
  arrange(book, release, chapter_number, student_id, engaged)

# Inspecting the sorted data
glimpse(page_views_sorted)




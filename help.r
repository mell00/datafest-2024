#FROM preprocess.r

# Performing the inner join based on 'student_id'
joined <- inner_join(check_pulse_process, check_eoc_process, by = c("chapter_number", "student_id"))

# Optional: Specify additional processing or selection of columns as needed
# For example, to select specific columns you can use:
joined_final <- select(joined, student_id, chapter_number, everything())

# View the final joined data
print(joined_final)

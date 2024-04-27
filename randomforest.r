library(randomForest)


# Training the Random Forest model
set.seed(42)  # for reproducibility
rf_model <- randomForest(target_variable ~ ., data = trainData, ntree = 100, mtry = sqrt(ncol(trainData)), importance = TRUE)

# Summary of the model
print(rf_model)

# Predicting and evaluating the model
predictions <- predict(rf_model, testData)
confusionMatrix <- confusionMatrix(predictions, testData$target_variable)
print(confusionMatrix)

# Checking variable importance
importance <- importance(rf_model)
sorted_importance <- sort(importance[, 'MeanDecreaseGini'], decreasing = TRUE)
print(sorted_importance)

# Plotting variable importance
varImpPlot(rf_model)

# Saving the model for future use
saveRDS(rf_model, "rf_model.rds")



# Importance ranking for the variables:
rf_model <- randomForest(EOC ~ ., data = data, importance = TRUE)

# Extract feature importances
importances <- importance(rf_model, type = 1)  # type = 1 for mean decrease in accuracy

# Create a data frame with feature names and their importances
feature_importances <- data.frame(
  feature = rownames(importances),
  importance = round(importances[, "MeanDecreaseAccuracy"], 3)
)

# Sort the importances in descending order and set row names as feature names
feature_importances <- feature_importances[order(-feature_importances$importance),]
rownames(feature_importances) <- feature_importances$feature
feature_importances <- feature_importances[, "importance", drop = FALSE]

# View the sorted feature importances
print(feature_importances)

# Ensure the feature names are a column in the data frame, not just row names
feature_importances$feature <- rownames(feature_importances)

# Create a ggplot bar plot
ggplot(feature_importances, aes(x = reorder(feature, importance), y = importance)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Feature Importances", x = "Features", y = "Importance") +
  theme_minimal() +
  coord_flip() # Flip the coordinates for horizontal bars




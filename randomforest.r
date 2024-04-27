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

library(dplyr)
# Merging the training and the test sets to create one data set.
temp_test <- read.table("test/X_test.txt")
temp_train <- read.table("train/X_train.txt")
X <- bind_rows(temp_test, temp_train)

temp_test <- read.table("test/y_test.txt")
temp_train <- read.table("train/y_train.txt")
y <- bind_rows(temp_test, temp_train)

temp_test <- read.table("test/subject_test.txt")
temp_train <- read.table("train/subject_train.txt")
Subject <- rbind(temp_test, temp_train)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("features.txt")
index_of_good_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X <- X[, index_of_good_features]
names(X) <- features[index_of_good_features, 2]
names(X) <- gsub("\\(|\\)", "", names(X))
names(X) <- tolower(names(X))

# Uses descriptive activity names to name the activities in the data set
activity <- read.table("activity_labels.txt")
activity[, 2] = gsub("_", "", tolower(as.character(activity[, 2])))
y[, 1] = activity[y[ , 1], 2]
names(y) <- "activity"

# Appropriately labels the data set with descriptive activity names.

names(Subject) <- "subject"
clean <- cbind(Subject, y, X)

write.table(clean, "merged_clean_and_tidy_data.txt")

# Creates a 2nd, independent tidy data set with the average
# of each variable for each activity and each subject.

uniqueSubjects <- unique(Subject)[, 1]
numSubjects <- length(unique(Subject)[, 1])
numActivities <- length(activity[, 1])
numColumns <- dim(clean)[2]
result <- clean[1:(numSubjects*numActivities), ]

row <- NULL
for (s in 1:numSubjects){
  for (a in 1:numActivities){
    result[row, 1] <- uniqueSubjects[s]
    result[row, 2] <- activity[a, 2]
    temp <- clean[clean$subject == s & clean$activity == activity[a, 2], ]
    result[row, 3:numColumns] <- colMeans(temp[, 3:numColumns])
    row <- row + 1
  }
}

write.table(result, "data_set_with_the_averages.txt")

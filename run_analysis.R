library(dplyr)

temp_test <- read.table("test/X_test.txt")
temp_train <- read.table("train/X_train.txt")
X <- bind_rows(temp_test, temp_train)
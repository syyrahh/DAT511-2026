#DAT 511 Group Project - Syeda Rahmani 
#Human Activity Recognition Using Smartphones

#Installing & Loading the Package 
install.packages("dplyr")
library(dplyr)

#Locating the dataset - UCI HAR Dataset
data_dir <- file.path ("DAT 511_Group_Project", "UCI HAR Dataset")

if (!dir.exists(data_dir)){
  stop("Dataset folder not found. Check the folder name and location.")
}

#Reading the Feature Names and Activity Labels
features <- read.table(
  file.path(data_dir, "features.txt"),
  stringsAsFactors = FALSE
  )

activity_labels <- read.table(
  file.path(data_dir, "activity_labels.txt"),
  stringsAsFactors = FALSE
)

feature_names <- features$V2

#Selecting the Only Mean and Standard Deviation Measurements 
selected <- grepl("mean\\(\\) |std\\(\\)", feature_names)

#Making Variable Names Easier to Read 
clean_names <- feature_names[selected]
clean_names <- gsub("^t", "time_", clean_names)
clean_names <- gsub("^f", "frequency_", clean_names)
clean_names <- gsub("mean\\(\\)", "mean", clean_names)
clean_names <- gsub("std\\(\\)", "std", clean_names)
clean_names <- gsub("-", "_", clean_names)
clean_names <- gsub("\\(\\)", "", clean_names)
clean_names <- gsub(",", "_", clean_names)
clean_names <- make.names(clean_names, unique = TRUE)

#Reading the "Trainaing" Data
train_x <- read.table(file.path(data_dir, "train", "X_train.txt"))
train_y <- read.table(file.path(data_dir, "train", "y_train.txt"))
train_subject <- read.table(file.path(data_dir, "train", "subject_train.txt"))

#Reading the "Test" Data
test_x <- read.table(file.path(data_dir, "test", "X_test.txt"))
test_y <- read.table(file.path(data_dir, "test", "y_test.txt"))
test_subject <- read.table(file.path(data_dir, "test", "subject_test.txt"))

#Keeping Only the Selected Measurements
train_x <- train_x[, selected]
test_x <- test_x[, selected]

#Assigning Descriptive Variable Names 
names(train_x) <- clean_names
names(test_x) <- clean_names

#Combining the Measurements with Subject and Activity IDs
train_data <- data.frame(
  subject = train_subject$V1,
  activity = train_y$V1,
  train_x
)

test_data <- data.frame(
  subject = test_subject$V1,
  activity = test_y$V1,
  test_x
)

#Merging Training and Test data
combined_data <- bind_rows(train_data, test_data)

#Replacing Activity IDs with Descriptive Names
combined_data$activity <- activity_labels$V2[
  match(combined_data$activity, activity_labels$V1)
]

#Creating a Second Tidy Dataset:

#Average each measurement for every subject and activity
tidy_data <- combined_data %>%
  group_by(subject, activity) %>%
  summarise(
    across(where(is.numeric), ~ mean(.x)),
    .groups = "drop"
  )

#Exporting the Final Tidy dataset
write.table(
  tidy_data,
  file = file.path ("DAT 511_Group_Project", "tidy_data.txt"),
  row.names = FALSE
)

#Checking the Results
print(dim(combined_data))
print(dim(tidy_data))
print(head(tidy_data))
print(sum(is.na(tidy_data)))

cat("Analysis completed successfully!\n")
cat("The tidy dataset was saved as tidy_data.txt\n")


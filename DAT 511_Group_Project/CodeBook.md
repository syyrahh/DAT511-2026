#CodeBook: Human Activity Recognition Using Smartphones

##Project Overview

This project analyzes smartphone sensor measurements collected while people performed daily physical activities. The purpose is to combine the original training and test datasets, select mean and standard deviation measurements, replace activity codes with descriptive names, and calculate average measurements for each subject and activity.

##Data Source

Human Activity Recognition Using Smartphones Dataset.

Source: UCI Machine Learning Repository

https://archive.ics.uci.edu/dataset/240/human%2Bactivity%2Brecognition%2Busing%2Bsmartphones

The study involved 30 volunteers performing six activities while wearing a Samsung Galaxy S II smartphone.

##Original Files Used

- `features.txt`: Names of the original 561 measurement variables.
- `activity_labels.txt`: Activity codes and their descriptive names.
- `train/X_train.txt`: Training measurements.
- `train/y_train.txt`: Training activity codes.
- `train/subject_train.txt`: Training subject identifiers.
- `test/X_test.txt`: Test measurements.
- `test/y_test.txt`: Test activity codes.
- `test/subject_test.txt`: Test subject identifiers.

##Final Dataset

Output file: `tidy_data.txt`

The final dataset contains 180 rows and 68 columns.

Each row represents one subject performing one activity. Each row contains the average of the selected measurements for that subject and activity.

###Variables

- `subject`: Numeric identifier of the participant, ranging from 1 to 30.
- `activity`: Descriptive name of the activity.
- Remaining 66 columns: Average values of the selected mean and standard deviation measurements.

###Activity Values

- `WALKING`: Walking on level ground.
- `WALKING_UPSTAIRS`: Walking upstairs.
- `WALKING_DOWNSTAIRS`: Walking downstairs.
- `SITTING`: Sitting.
- `STANDING`: Standing.
- `LAYING`: Lying down.

###Measurement Variable Names

Variable names are made more readable by replacing prefixes and punctuation. For example, `tBodyAcc-mean()-X` becomes `time_BodyAcc_mean_X`.

- `time`: Time-domain signal.
- `frequency`: Frequency-domain signal.
- `BodyAcc`: Body acceleration.
- `GravityAcc`: Gravity acceleration.
- `BodyGyro`: Body angular velocity measured by the gyroscope.
- `mean`: Mean measurement.
- `std`: Standard deviation measurement.
- `X`, `Y`, and `Z`: Measurement axes.

The original sensor features are processed and normalized as described in the UCI dataset documentation. Measurement scales depend on the original feature.

##Data Types and Units

- `subject`: Integer identifier; no physical unit.
- `activity`: Character value describing the activity; no physical unit.
- Measurement columns: Numeric values representing averages of the original sensor features. Their scales and units follow the original feature definitions and preprocessing.

##Data Cleaning and Processing

The `GroupWork.R` script performs the following steps:

1. Loads the `dplyr` package.
2. Reads the original feature names and activity labels.
3. Selects variables containing `mean()` or `std()`.
4. Reads the training and test measurements, activity codes, and subject identifiers.
5. Combines measurements with their corresponding subject and activity information.
6. Merges the training and test datasets.
7. Replaces numeric activity codes with descriptive activity names.
8. Cleans the selected variable names to make them easier to read.
9. Groups the data by subject and activity.
10. Calculates the average of each selected numeric measurement.
11. Exports the final tidy dataset to `tidy_data.txt`.

##Missing Data

The script checks the final dataset for missing values using `sum(is.na(tidy_data))`. The original dataset is expected to have no missing values in the selected measurements. Any unexpected missing values should be investigated rather than silently removed.

##How to Run the Analysis

1. Install R and RStudio.
2. Install `dplyr` by running `install.packages("dplyr")`.
3. Place the extracted `UCI HAR Dataset` folder alongside `GroupWork.R`.
4. Open `GroupWork_RAHMANI,SYEDA&LANI,KEGLER.R` in RStudio.
5. Run the script.
6. Confirm that `tidy_data.txt` is created.

##Output

The final output is `tidy_data.txt`, a tidy dataset containing the average of each selected measurement for each subject and activity.
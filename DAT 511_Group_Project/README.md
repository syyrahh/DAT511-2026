#DAT 511 Group Project - SYEDA RAHMANI

##Human Activity Recognition Using Smartphones

###Project Description

This project uses smartphone sensor data to study six physical activities performed by 30 volunteers. The data is cleaned and summarized using R.

###Project Files

- `GroupWork.R`: R script that reads, cleans, combines, and summarizes the original datasets.
- `tidy_data.txt`: Final tidy dataset containing average measurements for each subject and activity.
- `CodeBook.md`: Documentation describing the dataset, variables, data types, and processing steps.
- `UCI HAR Dataset/`: Original dataset files used by the R script.

###How to Run the Project

1. Install R and RStudio.
2. Install the required package by running `install.packages("dplyr")`.
3. Ensure that the extracted `UCI HAR Dataset` folder is located alongside `GroupWork.R`.
4. Open and run `GroupWork.R` in RStudio.
5. The script creates `tidy_data.txt` in the current working directory.

###Analysis Summary

The script combines the training and test datasets, extracts mean and standard deviation measurements, replaces activity codes with descriptive names, and calculates the average of each selected measurement for each subject and activity.

###Data Source

UCI Machine Learning Repository:

https://archive.ics.uci.edu/dataset/240/human%2Bactivity%2Brecognition%2Busing%2Bsmartphones
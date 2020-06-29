# GettingCleaningData
Final assignment for Getting and Cleaning Data course

The files contained in this repo are:

README.md (this file) - explanation of how files go together

codebook.Rmd - this file describes the original dataset as well as the data tables created by the code run_analysis.R and the variables in these new tables

run_analysis.R - this file takes the original UCI HAR Dataset and merges the training and test datasets. It extracts only measurements of standard deviation and mean. It changes labels of variables and activity labels to be descriptive. This table is 10298 x 82. Finally, the code creates a smaller table from this original table with the standard deviation and mean for the measurements of each subject and activity (each original column for measurements turns into two colulmns), so the final table is 180 x 161.

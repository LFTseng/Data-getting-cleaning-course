This is the course assignment for the Getting and Cleaning Data Coursera course. The R script, run\_analysis.R, does the following:

1.  Downloads the dataset if it does not already exist in the working directory
2.  Loads both the train and test datasets
3.  Loads features and activity labels files
4.  Merges train and test datasets into a new dataset, then only selects columns contain Subject, Activity, mean, and std
5.  Creates a tidy dataset that has the mean values of each variable of each subject and activity
6.  The end results are generated in the file "tidydata.txt"

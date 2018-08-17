## Load dplyr package
library(dplyr)

filename <- "dataset.zip"

## Download and unzip the dataset
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method ="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

## Load train datasets
trainResults <- read.table("UCI HAR Dataset/train/X_train.txt")
trainActiviteis <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActiviteis, trainResults)

## Load test datasets
testResults <- read.table("UCI HAR Dataset/test/X_test.txt")
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, testResults)

## Read features
features <- read.table("UCI HAR Dataset/features.txt", as.is = TRUE)

## Read activity labels
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activities) < c("activityID", "activityName")

## Merge train and test datasets in a new dataset
humanActivity <- rbind(train, test)
colnames(humanActivity) <- c("Subject", "Activity", features[, 2])

## Select columns to keep
ColstoKeep <- grepl("Subject|Activity|mean|std", colnames(humanActivity))
ActivityFinal <- humanActivity[, ColstoKeep]

## Replace activity ID to activity name
ActivityFinal$Activity <- factor(ActivityFinal$Activity, levels = activities[, 1], 
                                 labels = activities[, 2])

## Label variables with descriptive labels
ActivityFinalCols <- colnames(ActivityFinal)  ## get column names

ActivityFinalCols <- gsub("[[:punct:]]", "", ActivityFinalCols) ## remove special characters

ActivityFinalCols <- gsub("^f", "frequencyDomain", ActivityFinalCols) ## expand abbreviations
ActivityFinalCols <- gsub("^t", "TimeDomain", ActivityFinalCols)
ActivityFinalCols <- gsub("Acc", "Accelerometer", ActivityFinalCols)
ActivityFinalCols <- gsub("Gyro", "Gyroscope", ActivityFinalCols)
ActivityFinalCols <- gsub("Freq", "Frequency", ActivityFinalCols)
ActivityFinalCols <- gsub("Mag", "Magnitude", ActivityFinalCols)
ActivityFinalCols <- gsub("mean", "Mean", ActivityFinalCols)
ActivityFinalCols <- gsub("std", "StandardDeviation", ActivityFinalCols)

ActivityFinalCols <- gsub("BodyBody", "Body", ActivityFinalCols) # correct typo

colnames(ActivityFinal) <- ActivityFinalCols # use new labels

## Group by subject and activity and then summarize using mean function
ActivityFinalMean <- ActivityFinal %>%
                     group_by(Subject, Activity) %>%
                     summarise_all(mean)

## Create a new .txt file with tidy dataset
write.table(ActivityFinalMean, "tidydata.txt", row.names = FALSE, quote = FALSE)








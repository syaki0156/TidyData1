# Summary
# This project teaches us how to get "dirty" data and make a tidy, clearer information.
# This is done with accordance with the instructions of the so called customer or maybe a manager.
# To do this the student uses methods and functions that were introduced in our course.
#
# Preparations
# 1. set working directory with setwd().[Not shown.]
#   Make sure you have all data files needed for this project.
#
# 2. Load all data files
temp <- tempfile()
download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)
unzip(temp)
unlink(temp)
X_train <- read.table("UCI HAR Dataset\\train\\X_train.txt")
y_train <- read.table("UCI HAR Dataset\\train\\y_train.txt")
X_test <- read.table("UCI HAR Dataset\\test\\X_test.txt")
y_test <- read.table("UCI HAR Dataset\\test\\y_test.txt")
subject_train <- read.table("UCI HAR Dataset\\train\\subject_train.txt")
subject_test <- read.table("UCI HAR Dataset\\test\\subject_test.txt")
X_features <- read.table("UCI HAR Dataset\\features.txt")
activitylabels <- read.table("UCI HAR Dataset\\activity_labels.txt")
#
# Q1: Create relevant tables. (Merge the 4 tables.)
mData <- rbind(X_train,X_test)
y <- rbind(y_train, y_test)
names(y) <- "Activity"
a <- rbind(subject_train, subject_test)
names(a) <- "Subject"
#
# Q2 - keep only mean|std ...
# Select mean and std columns. But first...
# give columns a descriptive name:
x <- as.character(X_features[[2]])
names(mData) <- x
# Then chose the wanted ones.
c <- grepl("-std()", names(mData), fixed = TRUE)
allData <- mData[, c]
c <- grepl("-mean()", names(mData), fixed = TRUE)
allData <- cbind(allData, mData[, c])
allData <- cbind (a, y, allData)
#
# Q3: Change activity from num to name.
allData[,2] <- activitylabels[allData[,2], 2]
#
# Q4: Make variables' names legal by Removing special chars.
names(allData) <- make.names(names(allData), unique=T)
#
# Q5: Tidy data.
# First melt it ...
library(reshape2)
allDataMelt <- melt(allData, id = c("Subject","Activity"))
# then dcast it ...
allDataMeltDcast <- dcast(allDataMelt, Subject+Activity ~ variable, mean)
# Finally...
# Make a file of the resulting tidy table to be sent.
write.table(allDataMeltDcast, file="tidyData.txt", row.names=FALSE, quote = FALSE, col.names = FALSE, sep = ",")
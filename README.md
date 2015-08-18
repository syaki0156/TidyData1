Course: Getting and Cleaning Data
Course Project
Written by Y. Sakoury

Description:
Get data spread over several files. Merge it in a logical way and make it tidy, so it is ready for next steps of analysing it. What it means logical way? Well it depends on the requests. But here we got most of it already arranged nicely but not completely. I tried to see the logical connection between the files. I also tried to guess by the demands detailed in the work (site). For instance should I use the 'Inertial Signals' data? No. Because any way demand 2 asks for Mean() and Std() which here don't exist.

Decisions:
1. What will be the best way to merge the data?
1.1 First, rbind X_test to X_train and Y_test to Y_train.
1.2 Then, cbind the result.
This is a simple yet long way but it gives us a result without the side effects of using 'merge()'. 
2. First, make second column of 'Features.txt' the names of columns. Extraction will be done only on "real" measurements and not calculations. This is done, depending on the explanations in Features_Info.txt.
3. Convert numbers to more descriptive activity names.
4. The names of all parameters obtained by the experiments are very descriptive. Although they contain valuable information to the reader as to what they mean, they are not legal *Variables* names. Now, there are several ways to make them legal. I chose the easiest way of doing it, by using the function 'make.names()'. It's not beautiful but...it's legal!
5. OK, last step. We need the final tidy data. Many ways to achieve this. As usual I tried the simplest and easy way, as shown in classroom; e.g. 'melt()' and 'dcast()'. I think I got the right table (hopefully).
6. Last request is to save data without any headers of any kind, in a textual file, using 'write.table()'.
So this is the script: (run_analysis.R)
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

setwd("/Users/mm57647/Desktop/Coursera_test/3_Getting_and_Cleaning_Data/Week3")
library(plyr)

#########################################################################
##Download the data

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dest <- "3-course_project.zip"
download.file(fileUrl,dest,method="curl")
unzip("3-course_project.zip")

#########################################################################
##Load the intermediate files from the zipped folder

subject_testdata <- read.table("UCI HAR Dataset/test/subject_test.txt")
activity_testdata <- read.table("UCI HAR Dataset/test/y_test.txt")
measurements_testdata <- read.table("UCI HAR Dataset/test/x_test.txt")

subject_traindata <- read.table("UCI HAR Dataset/train/subject_train.txt")
activity_traindata <- read.table("UCI HAR Dataset/train/y_train.txt")
measurements_traindata <- read.table("UCI HAR Dataset/train/x_train.txt")

#########################################################################
##Bind the rows for the 3 datasets

subject_data <- rbind(subject_testdata, subject_traindata)
colnames(subject_data) <- "subject_ID"
activity_data <- rbind(activity_testdata, activity_traindata)
colnames(activity_data) <- "Action"
measurements_data <- rbind(measurements_testdata, measurements_traindata)

#########################################################################
##Extract Mean and STD columns from the measurements

features <- read.table("UCI HAR Dataset/features.txt")

analyzable_features <- grep("-(mean|std)\\(\\)", features[, "V2"])
measurements_data <- measurements_data[, analyzable_features]
colnames(measurements_data) <- features[analyzable_features,"V2"]

#########################################################################
##Replace Activity values with the activity names

#activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
#colnames(activity_labels) <- c("Action_Number", "Action")
#mergedData <- merge(activity_labels,activity_data,by.x="Action_Number",by.y="Action_Number")
#activity_data <- activity_data$Action
#activity_data <- mergedData[, 2]
#colnames(activity_data) <- "Action"
activity_data[,"Action"] <- factor(activity_data[,"Action"], labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))#activity_data <- activity_data$Action

#########################################################################
##Compile Full datatable and get the averages for each subject and action

all_data <- cbind(subject_data,activity_data,measurements_data)
write.table(all_data, "Course_Project_Final_Data.txt",row.name=FALSE)

averages <- ddply(all_data, .(subject_ID, Action), function(x) colMeans(x[, 3:68]))
write.table(averages, "Course_Project_Averages.txt",row.name=FALSE)
averages

## Data download and unzip 
library(reshape2)

filename <- "UCIHar.zip"

#Merge the training and the test sets to create one data set.
## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename)
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}


## Read Data
#UCI Har Dataset folder contains the following:

#test folder: contains subject_test, x_test, y_test
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

#train folder:
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

#Other text documents:
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")  

## Analysis
# 1. Merges the training and the test sets from the UCI Har Dataset folder
dataSet <- rbind(x_train,x_test)
subject <- rbind(subject_train, subject_test)
names(subject) <- 'subject'
activity <- rbind(y_train, y_test)
names(activity) <- 'activity'

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# Create a vector of only mean and std, use the vector to subset.
meanStdDev <- grep("mean()|std()", features[, 2]) 
dataSet <- dataSet[,meanStdDev]


# 4. Appropriately labels the data set with descriptive variable names(from features.txt).
# Create vector of "Clean" feature names by getting rid of "()" apply to the dataSet to rename labels.
CleanFeatureNames <- sapply(features[, 2], function(x) {gsub("[()]", "",x)})
names(dataSet) <- CleanFeatureNames[meanStdDev]



# combine subject, activity, and mean and std only data set to create final data set.
dataSet <- cbind(subject,activity, dataSet)


# 3. Uses descriptive activity names to name the activities in the data set
# group the activity column of dataSet, re-name lable of levels with activity_levels, and apply it to dataSet.
act_group <- factor(dataSet$activity)
levels(act_group) <- activity_labels[,2]
dataSet$activity <- act_group


# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# check if reshape2 package is installed
if (!"reshape2" %in% installed.packages()) {
	install.packages("reshape2")
}
library("reshape2")

# melt data to tall skinny data and cast means. Finally write the tidy data to the working directory as "tidy_data.txt"
baseData <- melt(dataSet,(id.vars=c("subject","activity")))
secondDataSet <- dcast(baseData, subject + activity ~ variable, mean)
names(secondDataSet)[-c(1:2)] <- paste("[mean of]" , names(secondDataSet)[-c(1:2)] )
write.table(secondDataSet, "tidy_data.txt", sep = ",")
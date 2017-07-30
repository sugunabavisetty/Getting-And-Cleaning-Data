#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(reshape2)

filename <- "getdata_dataset.zip"

#Merge the training and the test sets to create one data set.
## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename)
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Load activity labels and features
actLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
actLabels[,2] <- as.character(actLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

#Extracts only the measurements on the mean and standard deviation for each measurement.
# Extract mean and standard deviation data
mean_stddev <- grep(".*mean.*|.*std.*", features[,2])
mean_stddev.names <- features[mean_stddev,2]
mean_stddev.names = gsub('-mean', 'Mean', mean_stddev.names)
mean_stddev.names = gsub('-std', 'Std', mean_stddev.names)
mean_stddev.names <- gsub('[-()]', '', mean_stddev.names)


# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[mean_stddev]
trainAct <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubj <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubj, trainAct, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[mean_stddev]
testAct <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubj <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubj, testAct, test)

# merge datasets and add labels
combineData <- rbind(train, test)
colnames(combineData) <- c("subject", "activity", mean_stddev.names)

#Appropriately labels the data set with descriptive variable names.
# turn activities & subjects into factors
combineData$activity <- factor(combineData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
combineData$subject <- as.factor(combineData$subject)

#independent tidy data set with the average of each variable for each activity and each subject.
combineData.melted <- melt(combineData, id = c("subject", "activity"))
combineData.mean <- dcast(combineData.melted, subject + activity ~ variable, mean)

write.table(combineData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
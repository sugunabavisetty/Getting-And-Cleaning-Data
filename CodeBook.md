Explanation of Variables:

Test variables: Store the data in the *_test files in the UCI HAR dataset folder.
subject_test
x_test
y_test

Training Variables: Store the data in the *_train files in the UCI HAR dataset folder.
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

Activity Variables:
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")  

Merged Variable Names:
dataSet <- rbind(x_train,x_test)
subject <- rbind(subject_train, subject_test)
activity <- rbind(y_train, y_test)

Extracted Mean and StdDev values:
meanStdDev


Combined Data Set:
dataSet <- cbind(subject,activity, dataSet)

Final Data Set:
Data2

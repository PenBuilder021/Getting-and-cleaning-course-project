##------Getting and Cleaning Data Week 4 Project ---------------------

#name me: run_analysis.R

setwd("~/R/getdata_projectfiles_UCI HAR Dataset/")

#Load the datasets
train = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
train[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
train[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

test = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
test[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
test[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

# Read features and make the feature names better suited for R with some substitutions
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

#Merges the training and the test sets to create one data set.
uciData = rbind(train, test)

#Extracts only the measurements on the mean and standard deviation for each measurement.
colsNeeded <- grep(".*Mean.*|.*Std.*", features[,2])
features <- features[colsNeeded,]

#adds in Subject and Activity
colsNeeded <- c(colsNeeded, 562, 563)

#Includes only the columns needed (mean & standard deviation)
uciData <- uciData[,colsNeeded]

# Add the column names (features) to uciData
colnames(uciData) <- c(features$V2, "Activity", "Subject")
colnames(uciData) <- tolower(colnames(uciData))

#Uses descriptive activity names to name the activities in the dataset + labels w/ descriptive variable names
currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  uciData$activity <- gsub(currentActivity, currentActivityLabel, uciData$activity)
  currentActivity <- currentActivity + 1
}

uciData$activity <- as.factor(uciData$activity)
uciData$subject <- as.factor(uciData$subject)

#create tidy dataset
uciData.melted <- melt(uciData, id = c("subject", "activity"))
uciData.mean <- dcast(uciData.melted, subject + activity ~ variable, mean)
write.table(uciData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)

rm(list=ls())
library(plyr)
library(dplyr)
library(reshape2)

folder = "C:/Coursera/Course project/Getting and Cleaning Data"

setwd(folder)

# Import in activity labels and feature names
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity.labels) <- c("index","activity")
features <- read.table("./UCI HAR Dataset/features.txt")

# Import training dataset
train.set <- read.table("./UCI HAR Dataset/train/X_train.txt")
train.labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
train.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Import testing dataset
test.set <- read.table("./UCI HAR Dataset/test/X_test.txt")
test.labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
test.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Assign colnames to datasets
colnames(train.set) <- features[,2]
colnames(test.set) <- features[,2]

# Get the indice of feature columns that are mean and stdev
idx <- grep("mean\\(\\)|std\\(\\)",features[,2])

# Merge testing and training datasets
all.data <- rbind(train.set, test.set)

# Extracts only the measurements on the mean and standard deviation for each measurement
rel.data <- all.data[,idx]

all.activity <- rbind(train.labels, test.labels)
all.subject <- rbind(train.subject, test.subject)
colnames(all.activity) <- c("activity.index")
colnames(all.subject) <- c("subject")


# Bind the activity and subject into the dataset
rel.data <- cbind(all.subject, all.activity, rel.data)

# Merge activity.labels with the dataset
# Replace activity index with its corresponding labels
rel.data <- merge(rel.data, activity.labels, by.x="activity.index", by.y="index")
n <- ncol(rel.data)
rel.data <- rel.data[,c(colnames(rel.data)[n], colnames(rel.data)[1:(n-1)])]
rel.data <- select(rel.data, -(activity.index))

# Get the tidy summary data table
data.melt <- melt(rel.data, id=c("subject","activity"))
tidy.summary.table <- dcast(data.melt, subject + activity ~ variable, mean)

# Write table
write.table(tidy.summary.table, file="tidy.summary.txt", row.name=FALSE)

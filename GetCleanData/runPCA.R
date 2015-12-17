# Run for the first time to install plotting package
# library(devtools)
# install_github("ggbiplot", "vqv")

rm(list=ls())
library(ggbiplot)

folder = "C:/Projects/Data Science/SmartPhone"

setwd(folder)

#########################################################################
## Import the dataset
#########################################################################

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

#########################################################################
## Merge the dataset with activity labels based on activity.index
#########################################################################
train.set.all <- cbind(train.set, train.labels)
colnames(train.set.all)[ncol(train.set.all)] <- "activity.index"
train.set.all <- merge(train.set.all, activity.labels, by.x="activity.index", by.y="index")

#########################################################################
#Run PCA for all the data
#########################################################################
activity.pca <- prcomp(train.set.all[,2:562])
plot(activity.pca)

summary(activity.pca)

g1 <- ggbiplot(activity.pca, obs.scale = 1, var.scale = 1, var.axes=FALSE,
             ellipse = TRUE, groups = train.set.all$activity,
              circle = TRUE)
g1
######################### 
##Saving the plot to PCA1.png
png("PCA1.png", width = 800, height= 800)
g1
dev.off()

#########################################################################
#Run all moving data (walking, upstairs, downstairs)
#########################################################################
train.set.moving <- train.set.all[train.set.all$activity.index <= 3,]

activity.moving.pca <- prcomp(train.set.moving[,2:562])
plot(activity.moving.pca)

g2 <- ggbiplot(activity.moving.pca, obs.scale = 1, var.scale = 1, var.axes=FALSE,
              ellipse = TRUE, groups = train.set.moving$activity,
              circle = TRUE)

######################### 
##Saving the plot to PCA2.png
g2
png("PCA2.png", width = 800, height= 800)
g2
dev.off()

#########################################################################
#Run all static data (sitting, laying, standing)
#########################################################################
train.set.static <- train.set.all[train.set.all$activity.index > 3,]

activity.static.pca <- prcomp(train.set.static[,2:562])
plot(activity.static.pca)


g3 <- ggbiplot(activity.static.pca, obs.scale = 1, var.scale = 1, var.axes=FALSE,
              ellipse = TRUE, groups = train.set.static$activity,
              circle = TRUE)
g3
png("PCA3.png", width = 800, height= 800)
g3
dev.off()
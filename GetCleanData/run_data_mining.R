
rm(list=ls())
library(kernlab)
library(MASS)

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


train.data <- data.frame(cbind(train.labels, train.set))
test.data <- data.frame(cbind(test.labels, test.set))
colnames(train.data)[1] <- "activity.index"
# Make sure they have the same colnames.
colnames(test.data) <- colnames(train.data)

#########################################################################
##SVM
#########################################################################
penalty <- seq(1,51, by=10)

svm.evaluate <- function(c, train, train.actual, test, test.actual) {
  svm.fit <- ksvm(train, train.actual, type="C-svc", C=c)
  test.svm.fitted <- predict(svm.fit, test)
  test.svm.error <- length(which(test.svm.fitted!=test.actual))/nrow(test)
  test.svm.error
}


test.svm.error <- c()
for(i in penalty) {
  print(i)
  temp.error <- svm.evaluate(i, as.matrix(train.data[,2:562]), train.data$activity.index, as.matrix(test.data[,2:562]), test.data$activity.index)
  test.svm.error <- c(test.svm.error, temp.error)
}
test.svm.error


#########################################################################
## Multiple logistic regression
#########################################################################
glm.fit <- glm(activity.index ~ . , data = train.data, family = poisson("log"))
train.glm.fitted <- round(glm.fit$fitted.values)
train.glm.error <- sum(train.glm.fitted!=train.data$activity.index)/nrow(train.data)
train.glm.error

test.glm.fitted <- predict(glm.fit, test.data, type="response")
test.glm.fitted <- round(test.glm.fitted)
test.glm.error <- sum(test.glm.fitted!=test.data$activity.index)/nrow(test.data)
test.glm.error

#########################################################################
## Binary logistic regression
#########################################################################
train.data.subset <- subset(train.data, activity.index==1 | activity.index==2)
train.data.subset$activity.index <- train.data.subset$activity.index-1
glm.fit <- glm(activity.index ~ . , data = train.data.subset, family = binomial(logit))
train.glm.fitted <- round(glm.fit$fitted.values)
train.glm.error <- sum(train.glm.fitted!=train.data$activity.index)/nrow(train.data)
train.glm.error

test.glm.fitted <- predict(glm.fit, test.data, type="response")
test.glm.fitted <- round(test.glm.fitted)
test.glm.error <- sum(test.glm.fitted!=test.data$activity.index)/nrow(test.data)
test.glm.error

#########################################################################
##LDA
#########################################################################
# fit model
lda.fit <- lda(activity.index ~ . , data = train.data)
# summarize the fit
summary(lda.fit)
# make predictions
test.lda.fitted <- predict(lda.fit, test.data)$class
test.lda.error <- sum(test.lda.fitted!=test.data$activity.index)/nrow(test.data)
test.lda.error




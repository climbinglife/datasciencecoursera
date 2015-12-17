##############
##Run linear regression classification
train.data <- train.set.all[,1:562]
lm.fit <- lm(activity.index ~ . , data=train.data)

fitted <- lm.fit$fitted.values
fitted <- round(fitted)

train.error <- length(which(fitted!=train.data$activity.index))/nrow(train.set)
train.error

test.data <- cbind(test.labels, test.set)
colnames(test.data) <- colnames(train.data)

lm.pred <- predict(lm.fit, test.data)

pred.fitted <- round(lm.pred)
test.error <- length(which(pred.fitted!=test.data$activity.index))/nrow(test.set)



###############################
##LASSO regression
library(glmnet)
lambda.log = seq(-6, -2, 0.05)
lambda = 10 ^ lambda.log

lasso.fit <- glmnet(as.matrix(train.data[,2:562]), train.data$activity.index, lambda = lambda)
plot(lasso.fit, xvar="lambda")
fitted <- predict(lasso.fit, as.matrix(train.data[,2:562]))
fitted.round <- round(fitted)

train.lasso.error <- c()
for(i in 1:ncol(fitted)) {
  temp.error <- length(which(fitted.round[,i]!=train.data$activity.index))/nrow(train.set)
  train.lasso.error <- c(train.lasso.error, temp.error)
}

fitted.test <- predict(lasso.fit, as.matrix(test.data[,2:562]))
fitted.test.round <- round(fitted.test)

test.lasso.error <- c()
for(i in 1:ncol(fitted.test)) {
  temp.error <- length(which(fitted.test.round[,i]!=test.data$activity.index))/nrow(test.set)
  test.lasso.error <- c(test.lasso.error, temp.error)
}

plot(log10(lasso.fit$lambda), test.lasso.error)

################################################
##SVM
library(kernlab)
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


###############################################
## Multiple logistic regression
glm.fit <- glm(activity.index ~ . , data = train.data, family = poisson("log"))
train.glm.fitted <- round(glm.fit$fitted.values)
train.glm.error <- sum(train.glm.fitted!=train.data$activity.index)/nrow(train.data)
train.glm.error

test.glm.fitted <- predict(glm.fit, test.data, type="response")
test.glm.fitted <- round(test.glm.fitted)
test.glm.error <- sum(test.glm.fitted!=test.data$activity.index)/nrow(test.data)
test.glm.error


##############################################
##LDA
# load the package
library(MASS)
# fit model
lda.fit <- lda(activity.index ~ . , data = train.data)
# summarize the fit
summary(lda.fit)
# make predictions
test.lda.fitted <- predict(lda.fit, test.data)$class
test.lda.error <- sum(test.lda.fitted!=test.data$activity.index)/nrow(test.data)
test.lda.error




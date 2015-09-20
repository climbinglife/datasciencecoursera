# Getting and Cleaning Data project
This folder contains the script to preprocessing Samsung Smartphone data

The script will import the dataset collected from the accelerometers from the Samsung Galaxy S smartphone for preprocessing.
 
A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

To run the scripts, set the working directory on the upper level of the downloaded dataset
For example, if the path to the dataset is : 
C:\Coursera\Course project\Getting and Cleaning Data\UCI HAR Dataset

Place the script in folder:
C:\Coursera\Course project\Getting and Cleaning Data
and 
Set working directory also to:
C:\Coursera\Course project\Getting and Cleaning Data

Run the script

The major steps for generating the tidy summary table:

1. Import in activity labels and feature names
2. Import training dataset
3. Import testing dataset
4. Assign colnames to datasets
5. Get the indice of feature columns that are mean and stdev
6. Merge testing and training datasets
7. Extracts only the measurements on the mean and standard deviation for each measurement
8. Bind the activity and subject into the dataset
9. Merge activity.labels with the dataset
10. Replace activity index with its corresponding labels
11. Get the tidy summary data table
12. Write out the summary table


It will generate "tidy.summary.txt" with the average of each variable for each activity and each subject.

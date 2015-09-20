# Getting and Cleaning Data project

The script will import the dataset collected from the accelerometers from the Samsung Galaxy S smartphone for preprocessing.

Required package to run the script:
plyr, dplyr, reshape2

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


 


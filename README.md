tidy-data-assignment
====================

This is a repository for the Coursera tidy data assignment

The run_analysis.R script creates a tidy data set that can be used for further analysis.

The data were collected from the accelerometers of Samsung Galaxy S smartphones. The data file was downloaded from the following link:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The original source for this data set is:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

run_analysis.R first processes the features.txt file to obtain variable names which will be used when reading the data into a table. The objective is to convert the names into syntactically valid names. In order to do that, the following processing needs to take place:
- row numbers have to be removed
- open/closing parentheses need to be removed (so as to prevent confusion with R function calls)
- commas need to be removed
- ranges will be specified as a-to-b instead of a,b (this applies to bandEnergy columns)
- feature 556 ("556 angle(tBodyAccJerkMean),gravityMean)") included a premature closing parenthesis that needs to be removed
- parameters to angle() listed more descriptively

Data from the train and test sets is combined and then the data for the activities and subjects is combined into one data set. Note that activities were renamed into single-verb names.

Only measurements on the mean and standard deviation for each measurement were considered. This was accomplished by including only variables which contained "mean" or "std" in their names (case-insensitive).

The final, independent, tidy data set was created with the average of each variable for each activity and each subject by means of the aggregate function.

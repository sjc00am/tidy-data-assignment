## -------------------------------------------------------------------------
## This script generates a tidy data set that can be used for later analysis
## -------------------------------------------------------------------------

## Merge the training and the test sets to create one data set

# rename features (to be used as column names when reading X into a table)
features <- readLines("./UCI HAR Dataset/features.txt")

# remove line numbers
features <- sub("^[0-9]+ ","",features)

# remove "()"
features <- sub("\\(\\)","",features)

# convert from eg "X,1" to "X1" (or "X,Y" to "XY")
features <- sub("([X-Z]),([0-9]|[X-Z])$","\\1\\2",features)

# rename bandsEnergy ranges from eg "1,16" to "1to16"
features <- sub("([0-9]+),([0-9]+)$","\\1to\\2",features)

# remove premature closing parens in feature 556
# "556 angle(tBodyAccJerkMean),gravityMean)"
features <- sub("\\),",",",features)

# rename angle(x,y) to angle-between-x-and-y
features <- sub("^(angle)\\(([a-zA-Z]+),([a-zA-Z]+)\\)",
                "\\1-between-\\2-and-\\3",features)

# make syntactically valid names (there is repetition in bandsEnergy names)
# (this could also be specified as check.names option to read.table)
features <- make.names(features, unique=TRUE)

# read in features table
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names=features)
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names=features)

# combine into single data frame
data <- rbind(xtrain, xtest)

# read in activities
ytrain <- as.numeric(readLines("./UCI HAR Dataset/train/y_train.txt"))
ytest <- as.numeric(readLines("./UCI HAR Dataset/test/y_test.txt"))

# combine into single vector
activity <- c(ytrain, ytest)

# rename activities (into single-verb activity names)
activityLabels <- readLines("./UCI HAR Dataset/activity_labels.txt")
# remove line numbers
activityLabels <- sub("^[0-9]+ ","",activityLabels)
activityLabels <- tolower(activityLabels)
activityLabels <- sub("walking_upstairs","ascending",activityLabels)
activityLabels <- sub("walking_downstairs","descending",activityLabels)
# convert numeric values into names
activity <- activityLabels[activity]

# read in subjects
subjecttrain <- as.numeric(readLines("./UCI HAR Dataset/train/subject_train.txt"))
subjecttest <- as.numeric(readLines("./UCI HAR Dataset/test/subject_test.txt"))

# combine
subject <- c(subjecttrain, subjecttest)

# append activity and subject columns
data$activity <- activity
data$subject <- subject

## Extract only the measurements on the mean and standard deviation for each
## measurement
dataMeanStd <- data[names(data)[grep("mean|std",names(data),ignore.case=TRUE)]]

## generate independent tidy data set with the average of each variable
## for each activity and each subject
tidy <- aggregate.data.frame(kept,by=list(activity = data$activity,
                             subject=data$subject),FUN=mean)


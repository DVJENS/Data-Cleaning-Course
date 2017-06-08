# Use dplyr 
library(dplyr)

# set the working directory to the local folder
setwd("C:/Cleaning Data/Final Assignment/UCI HAR Dataset")

# Merge the training and the test data sets and create a final dataset using cbind

# make a vector of column names from the file features.txt contained in the local drive folder
featuretable <- read.table("C:/Cleaning Data/Final Assignment/UCI HAR Dataset/features.txt")
colnames <- as.vector(featuretable[,2])

# Read in training files
traindata <- read.table("C:/Cleaning Data/Final Assignment/UCI HAR Dataset/X_train.txt", col.names = colnames)
trainsubj <- read.table("C:/Cleaning Data/Final Assignment/UCI HAR Dataset/subject_train.txt", col.names = c("subject.id"))
trainingact <- read.table("C:/Cleaning Data/Final Assignment/UCI HAR Dataset/y_train.txt", col.names = c("activity.id"))

# combine the three training files together using cbine
trainall <- cbind(trainsubj, trainingact, traindata)
#str(trainall)
#trainall

# Read in the testing files
testdat <- read.table("C:/Cleaning Data/Final Assignment/UCI HAR Dataset/X_test.txt", col.names = colnames)
testsubj <- read.table("C:/Cleaning Data/Final Assignment/UCI HAR Dataset/subject_test.txt", col.names = c("subject.id"))
testact <- read.table("C:/Cleaning Data/Final Assignment/UCI HAR Dataset/y_test.txt", col.names = c("activity.id"))

# combine the three testing files
testall <- cbind(testsubj, testact, testdat)

# combine the resulting data frames from the two cbind operations into a single dataset
totmeasures <- rbind(testall, trainall)

# Extract the measurements on the mean and standard deviation for each measurement using dplyr function select and
# keeping on activity.id, subject.id and the columns that contain the mean and standard deviations.
trimmeasures <- select(totmeasures, matches("subject.id"), matches("activity.id"), matches(".mean."), matches(".std."))


# extract activity labels from the text file.
actlabels <- read.table("activity_labels.txt", col.names = c("activity.id", "activity.name"))
measureslabeled <- merge(actlabels, trimmeasures)

# from the labeled_measurements data set create a final dataset that meets the requirements of the assignment
measuressummarized <- summarize_each(group_by(measureslabeled, activity.name, subject.id), funs(mean))

# And write out the dataset
write.table(measuressummarized, file="summarized_measurements2.txt", row.names = FALSE)

#clean up the workspace
rm(trainingact,traindata,trainsubj,featuretable,testsubj, testact, testdat, totmeasures, colnames)
rm(testall, trainall, trimmeasures, actlabels)

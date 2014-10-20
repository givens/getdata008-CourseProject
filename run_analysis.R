# 1.  Merge training and test sets to create one data set
# 2.  Extracts only the measurements on the mean and standard deviation for each measurement
# 3.  Uses descriptive activity names to name the activities in the data set
# 4.  Appropriately label the data set with descriptive variable names
# 5.  Create a second independent tidy data set with the average of each variable for each activity and each subject.

# activity_labels.txt -- labels for different types of activities
# features.txt -- 561 types of features in each observation
# features_info.txt -- how different features mentioned in features.txt are derived.

# subject_train.txt -- labels for 70% of the 30 volunteers
# subject_test.txt -- labels for 30% of the 30 volunteers

# Order of completion:  Steps 1 -> 4 -> 3 -> 2 -> 5

# clear all
rm(list=ls())

# Variable names
act <- "Activity"
subj <- "Subject"

# Libraries
library(dplyr)
library(stringr)

# Set working directory
wd = "~/Dropbox/Statistics/Coursera/datascience/getdata-008/Project"
setwd(wd)

# Create data directory
if (!file.exists("data")) {
  dir.create("data")
}

# Download files
if (!file.exists("./data/data.zip")){
  fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  destFile = "./data/data.zip"
  method = "curl"
  download.file(fileUrl,destfile=destFile,method=method)
}

# list files
#list.files("./data")

# Download date - why?
#dateDownloaded <- date()

# Determine paths for relevant files
paths_train <- dir("data/train","\\.txt$",full.names=T)
paths_test <- dir("data/test","\\.txt$",full.names=T)
#paths_train_inert <- dir("data/train/Inertial Signals","\\.txt$",full.names=T)
#paths_test_inert <- dir("data/test/Inertial Signals","\\.txt$",full.names=T)

## Read flat files
# train
df_s1 <- read.table(paths_train[1]) # train subject, s1
df_X1 <- read.table(paths_train[2]) # train X, X1
df_a1 <- read.table(paths_train[3]) # train activity, a1
# test
df_s2 <- read.table(paths_test[1]) # test subject, y2
df_X2 <- read.table(paths_test[2]) # test X, X2
df_a2 <- read.table(paths_test[3]) # test activity, a2

## 1.  Merge
# Merge the X1 and X2 data sets, and y1 and y2 data sets, together
# rbind, cbind

df_X <- rbind(df_X1,df_X2)
df_a <- rbind(df_a1,df_a2)
df_s <- rbind(df_s1,df_s2)
df <- cbind(df_X,df_a,df_s)
ds <- tbl_df(df)
rm("df") # avoid confusion 
dims <- dim(ds)

## 4.  Label ALL columns with descriptive variable names
# features <- read.table("./data/features.txt")[,2] # Just second column
# features <- as.character(features)
# features <- c(features,act,subj)
# features <- str_replace_all(features,"[(),]","") # remove "(),-"
# names(ds) <- features

## 4.  Label columns with descriptive (and unique) variable names
features <- read.table("./data/features.txt")[,2] # Just second column
features <- as.character(features)
features <- c(features,act,subj)
features <- str_replace_all(features,"[(),]","") # remove "()," and possibly "-"
features <- tolower(features)
names <- names(ds)
features <- str_c(features,names)
names(ds) <- features

# # # Label certain columns for clarity
# names <- names(ds)
# names[(dims[2]-1):dims[2]] <- c(act,subj)
# #names[dims[2]] <- subj
# names(ds) <- names

## 3.  Label activities using actions
# Name descriptive activities such as 
# 1 -> "Walking", 
# 2 -> "Walking_Upstairs", etc.
# from activity labels

# Label activities by action
action <- read.table("./data/activity_labels.txt")[,2] # Just second column
action <- as.character(action)
ds %>% mutate(activityV1=action[activityV1])

tidy1 <- ds # tidy data set #1

# ## 2.  Extract
# # Extract the mean and std dev from each column in X
# # Extracting the mean and std dev from subject doesn't mean anything
# # Extracting the mean and std dev from activity doesn't mean anything
# tidy1_mean <- apply(tidy1[,1:(dims[2]-2)],2,mean) # same as colMeans
# tidy1_stddev <- sqrt(apply(tidy1[,1:(dims[2]-2)],2,var))  
# # something like colStdDev (which doesn't exist)
# # std. dev. is sqrt of variance
# # What do we do with these results?

## 5.  Create a second independent tidy data set with the average 
##     of each variable for each activity and each subject.

tidy2 <- ds %>% group_by(subjectV1,activityV1) %>% summarise_each(funs(mean))
# tidy data set #2
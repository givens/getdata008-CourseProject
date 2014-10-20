# Run Analysis
# This script completes five actions.
# 1.  Merge training and test sets to create one data set
# 2.  Extracts only the measurements on the mean and standard deviation for each measurement
# 3.  Uses descriptive activity names to name the activities in the data set
# 4.  Appropriately label the data set with descriptive variable names
# 5.  Create a second independent tidy data set with the average of each variable for each activity and each subject.
# Order of completion:  Steps 1 -> 4 -> 2 -> 5 -> 3

# RELEVANT FILES
# activity_labels.txt -- labels for different types of activities
# features.txt -- 561 types of features in each observation
# features_info.txt -- how different features mentioned in features.txt are derived.

# subject_train.txt -- labels for 70% of the 30 volunteers
# subject_test.txt -- labels for 30% of the 30 volunteers

# bpg

# Libraries
library(dplyr)
library(stringr)

# NOTE:  remove extraneous values
rm(list=ls())

# Variable names
act <- "Activity"
subj <- "Subject"

# Determine paths for relevant files
paths_train <- dir("./UCI HAR Dataset/train","\\.txt$",full.names=T)
paths_test <- dir("./UCI HAR Dataset/test","\\.txt$",full.names=T)

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
# Merge train and test sets together
# rbind, cbind
df_x <- rbind(df_X1,df_X2)
df_a <- rbind(df_a1,df_a2)
df_s <- rbind(df_s1,df_s2)

## 4.  Label columns with descriptive variable names
# X
features <- read.table("./UCI HAR Dataset/features.txt")[,2] # Just second column
features <- as.character(features)
features <- str_replace_all(features,"[(),]","") # remove "()," and possibly "-"
names(df_x) <- features
# Activity
names(df_a) <- act
# Subject
names(df_s) <- subj

## 2. Extract columns with filenames that contain "mean" and "std",
## and ignore case.
df_x_mean <- select(df_x,contains("mean",ignore.case=T))
df_x_std <- select(df_x,contains("std",ignore.case=T))
df_x <- cbind(df_x_mean,df_x_std)

# ## 3.  Label activities using actions
# df_act <- df_a %>% mutate(Activity=action[Activity])

## Create tidy data set #1 -- subject, activity, and X
tidy1 <- cbind(df_s,df_a,df_x) # actions not labeled

## 5.  Create tidy data set #2
tidy2 <- tidy1 %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))

## 3.  Label activities using actions
action <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2] # Just second column
action <- as.character(action)
tidy1 <- tidy1 %>% mutate(Activity=action[Activity])
tidy2 <- tidy2 %>% mutate(Activity=action[Activity]) 

## Write two codebooks, check for equivalency manually
codebook <- names(tidy1)
write.table(codebook,"Codebook_tidy1.md",row.names=F,col.names=F)
codebook <- names(tidy2)
write.table(codebook,"Codebook_tidy2.md",row.names=F,col.names=F)
# tidy1 and tidy2 should have same codebook, in same order.

## Write tidy2 to file
write.table(tidy2,"tidy2.txt",row.name=F)
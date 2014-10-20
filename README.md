# getdata008-CourseProject, Version 0.1
Brendhan Givens

## Materials for Getting and Cleaning Data, Course Project

### Repo Contents

This project folder contains files

- README.md

- download.R:  Downloads UCI raw data from Cloudfront.net and saves to local directory 

- run_analysis.R:  This script produces tidy data which are averages for subject and activity

- Codebook.md:  Provides code book for output produced by run_analysis.R script

### File Execution

run_analysis.R operates on movement data that is assumed to be in same directory.

To produce tidy2.txt output, do the following operations in RStudio 0.98.1049 on a Mac OS X Version 10.9.5:

    source('download.R')

The data.zip file is saved to the local directory.  A download_date.txt file is saved to local directory which indicates when the file was downloaded, per instructor video lectures.

Unzip the file using the default archive utility.  

A directory called "UCI HAR Dataset" appears in the local directory.  This directory is populated with test and train directories containing training and test set, training and test labels, features, activity labels, and subject labels.

Keep directory structure intact. 

    source('run_analysis.R')

The run analysis script performs 5 objectives mentioned in project guidelines.  It writes a table called tidy2.txt to the local directory.

View this data as follows:

    data <- read.table(file_path, header = TRUE)
    View(data)

This is mentioned in David Hood's project FAQ.

### How The RUN ANALYSIS Script Works, er, What it does

1.  Reads flat files in topmost train and test directories.
2.  Merges these data sets.
3.  Labels columns with descriptive variable names from the features file.  These variable names have some punctuation removed to aid clarity.
4.  Extracts mean and standard deviation columns.  Any column variable containing "mean" or "std" is extracted, where case is ignored.  
5.  Create tidy1 dataset.  (Seems somewhat unecessary, but is stipulated by guidelines.)
6.  Create tidy2 from tidy1.  Summarize each activity for each subject.
7.  Label activities using actions.
8.  Saves tidy2 table to tidy2.txt in local directory.

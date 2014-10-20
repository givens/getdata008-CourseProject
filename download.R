# Download files
# This file downloads the data to data.zip in current directory
# Assumes OS X Version 10.9.5

if (!file.exists("./data.zip")){
  
  # Download zip file
  fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  destFile = "./data.zip"
  method = "curl"
  download.file(fileUrl,destfile=destFile,method=method)
  
  # Download date - why?
  dateDownloaded <- date()
  write.table(dateDownloaded,"download_date.txt",row.names=F,col.names=F)
}

# After file is downloaded, file is unzipped manually using default archive utility.
# Directory is "UCI HAR Dataset"
# See README.txt



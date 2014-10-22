##get train and test data from local uncompressed files
###first setwd to make path access easier
setwd("C:\\Users\\pv532f\\Desktop\\R&D\\DataScience\\Getting and Cleaning Data\\Project2")
###get train data
train.data <- read.csv("UCI HAR Dataset//train//x_train.txt", header = TRUE, sep = "")
train.labels <- read.csv("UCI HAR Dataset//train//y_train.txt", header = TRUE)
train.subject <- read.csv("UCI HAR Dataset//train//subject_train.txt", header = TRUE)
###get test data
test.data <- read.csv("UCI HAR Dataset//test//x_test.txt", header = TRUE, sep = "")
test.labels <- read.csv("UCI HAR Dataset//test//y_test.txt", header = TRUE)
test.subject <- read.csv("UCI HAR Dataset//test//subject_test.txt", header = TRUE)
###get variable names
var.names <- read.csv("UCI HAR Dataset//features.txt", sep = "", header = FALSE)

###assign variable names to "data" tables
names(train.data) <- as.character(var.names$V2)
names(test.data) <- as.character(var.names$V2)

### join columns to each dataset for subject and labels
test.labels$X5 -> test.data$labels
test.subject$X2 -> test.data$subject
train.labels$X5 -> train.data$labels
train.subject$X1 -> train.data$subject

##1 Merge and arrange test and train by subject
merged_ds <- rbind(train.data, test.data, deparse.level = 1)

###2 Obtain the columns with mean and std information
cols_needed <- grep("mean|std", names(merged_ds), ignore.case=F, val=TRUE)
final_ds <- merged_ds[,cols_needed]
final_ds <- cbind(final_ds, merged_ds$labels,merged_ds$subject) 
colnames(final_ds)[80:81] <- c("activity_numbers", "subject")

###3 add descriptive activity names (stored in activity_labels file)

activities_list <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=F)
final_ds <- merge(final_ds, activities_list, by.x = "activity_numbers", by.y = "V1", sort=F)

###4 appropiately labels data set with variable names, reorder columns and clear act numbers.
colnames(final_ds)[82] <- c("activity_labels")
final_ds <- (final_ds[c(81, 82, 1:80)])
final_ds$activity_numbers <- NULL

###5 group and calculate averages.
library(plyr)
library(dplyr)
avgs_ds <- group_by(final_ds, activity_labels, subject)
avgs_ds <- summarise_each(avgs_ds,funs(mean), -activity_labels, -subject)
###6 Write data to a text file
write.table(x = avgs_ds, file = "SPhone_Tidy_Data.txt", append = F, row.names = FALSE)

   





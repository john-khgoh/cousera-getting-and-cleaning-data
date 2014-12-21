#The following R script processes accelerometers data collected from a Samsung Galaxy S and performs the following:
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Loads required libaries
library(dplyr)

#Note: The following should be changed according to the location of your working directory
#setwd("C:/Users/Administrator/Desktop/Coursera/Data Science/03 Getting & Cleaning Data/Assignment/Project")
#directory <- "C:/Users/Administrator/Desktop/Coursera/Data Science/03 Getting & Cleaning Data/Assignment/Project/UCI HAR Dataset"

#Reading test & train data from local directory into 6 data frames
filepath_stest <- file.path(directory,"./test/subject_test.txt")
filepath_xtest <- file.path(directory,"./test/X_test.txt")
filepath_ytest <- file.path(directory,"./test/y_test.txt")
filepath_strain <- file.path(directory,"./train/subject_train.txt")
filepath_xtrain <- file.path(directory,"./train/X_train.txt")
filepath_ytrain <- file.path(directory,"./train/y_train.txt")

#Note: I split the read from file process into two parts as I sometimes encountered error with the single step process
subject_test <- read.table(filepath_stest)
message("Reading large file is in progress. This might take awhile...")
x_test <- read.table(filepath_xtest)
y_test <- read.table(filepath_ytest)
subject_train <- read.table(filepath_strain)
message("Reading large file is in progress. This might take awhile...")
x_train <- read.table(filepath_xtrain)
y_train <- read.table(filepath_ytrain)

#Extract the column names from features.txt
filepath_features <- file.path(directory, "features.txt")
features <- read.table(filepath_features)[,2]

#Special filters to remove unwanted columns that include meanFreq and angle related means. 
#All these phrases are substituted with "Exclude" to exclude from grep process later.
#As the definition is very subjective, the following 5 lines can be commented out accordingly
features <- gsub('gravityMean', 'Exclude', features)
features <- gsub('AccMean', 'Exclude', features)
features <- gsub('JerkMean', 'Exclude', features)
features <- gsub('GyroMean', 'Exclude', features)
features <- gsub('-meanFreq', 'Exclude', features)

#Filter the column names to remove unwanted symbols and change case i.e. dash and brackets
features <- gsub('-mean', 'Mean', features)
features <- gsub('-std', 'Std', features)
features <- gsub('[-()]', '', features)

#Merge the test and training sets for each of x, y and subject respectively
x_comb <- rbind(x_test, x_train)
y_comb <- rbind(y_test, y_train)
subj_comb <- rbind(subject_test, subject_train)

#Appropriately label the data sets
names(x_comb) <- features
names(y_comb) <- "activity"
names(subj_comb) <- "subject"

#Extract only the means or standard deviations.
mean_and_std <- grep(".*Mean.*|.*Std.*", features)
x_comb <- x_comb[,mean_and_std]

#Give descriptive names to the activities instead of 1 to 6
y_comb$activity[y_comb$activity == 1] <- "WALKING"
y_comb$activity[y_comb$activity == 2] <- "WALKING_UPSTAIRS"
y_comb$activity[y_comb$activity == 3] <- "WALKING_DOWNSTAIRS"
y_comb$activity[y_comb$activity == 4] <- "SITTING"
y_comb$activity[y_comb$activity == 5] <- "STANDING"
y_comb$activity[y_comb$activity == 6] <- "LAYING"

#Merge x, y and subject
all_comb <- cbind(subj_comb, y_comb, x_comb)

#Create independent tidy data set with the average of each variable
tidy <- summarise_each(group_by(all_comb, subject, activity), funs(mean))

#Print tidy dataset to the working directory
write.table(tidy,"./tidy_data.txt", row.name=FALSE)
























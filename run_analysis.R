####Part 1####
#Call the different packages to use in the script
library(dplyr)
library(tidyr)
#We have to set the work directory into the folder with the data
#setwd("Folder with the data")
##Reading the different tables to be used in the tidy dataset
##The features
features <- read.table("./features.txt")
## For train data
labels_train <- read.table("./train/y_train.txt")
data_train <- read.table("./train/X_train.txt")
subject_train <- read.table("./train/subject_train.txt")
##For test data
labels_test <- read.table("./test/y_test.txt")
data_test <- read.table("./test/X_test.txt")
subject_test <- read.table("./test/subject_test.txt")

####Part 2####
#Extraction of the desired fields, in this case all the means and std
train_1 <- data_train[, grep("mean[()]|std", features$V2)]
test_1 <- data_test[, grep("mean[()]|std", features$V2)]
#Rename of the variables according to its names in the feature txt
names(train_1) <- grep("mean[()]|std", features$V2, value = TRUE)
names(test_1) <- grep("mean[()]|std", features$V2, value = TRUE)
#Binding of the subject, labels and the desired fields
train_table <- cbind(subject = subject_train$V1, labels = labels_train$V1, train_1)
test_table <- cbind(subject = subject_test$V1, labels = labels_test$V1, test_1)
#Binding the train and test tables
my_table <- rbind(train_table, test_table)
#Adding the activities according to the label variable
labels_tab <- read.table("./activity_labels.txt")
my_table <- merge(my_table, labels_tab, by.x="labels", by.y="V1")
my_table <- mutate(my_table, labels = my_table$V2) %>% select(-V2)

####Part 3####
#Calculate the mean for each variable for all the labels and all the subjects
by_activity <- aggregate(my_table[, 3:68], list(my_table$labels), mean)
by_subject <- aggregate(my_table[, 3:68], list(my_table$subject), mean)
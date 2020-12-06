library(dplyr)

# read all the data and select appropriate column names 

features <- read.table("features.txt", col.names = c("n", "functions"))
activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))

subject_test = read.table("test\\subject_test.txt", col.names = "subject")
x_test = read.table("test\\x_test.txt", col.names = features$functions)
y_test = read.table("test\\y_test.txt", col.names = "code")

subject_train = read.table("train\\subject_train.txt", col.names = "subject")
x_train = read.table("train\\x_train.txt", col.names = features$functions)
y_train = read.table("train\\y_train.txt", col.names = "code")


# Step 1: Merges the training and the test sets to create one data set 

x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, y, x)

# Step 2: Extracts only the measurements on the mean and standard deviation for each measurement

TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

# Step 3: Uses descriptive activity names to name the activities in the data set 

TidyData$code <- activities[TidyData$code, 2]

# Step 4: Appropriately labels the data set with descriptive variable names.

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

# Step 5: From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject

FinalData <- TidyData %>%
    group_by(subject, activity) %>%
    summarise_all(list(mean = mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)



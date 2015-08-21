#1. Merges the training and the test sets to create one data set.
#-------------------------------------------------------------------
xtrain<-read.table("UCI HAR Dataset/train/X_train.txt")
ytrain<-read.table("UCI HAR Dataset/train/Y_train.txt")
subtrain<-read.table("UCI HAR Dataset/train/subject_train.txt")

xtest<-read.table("UCI HAR Dataset/test/X_test.txt")
ytest<-read.table("UCI HAR Dataset/test/Y_test.txt")
subtest<-read.table("UCI HAR Dataset/test/subject_test.txt")
 
xdata<-rbind(xtrain,xtest)
ydata<-rbind(ytrain,ytest)
subdata<-rbind(subtrain,subtest)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.#-------------------------------------------------------------------
#-------------------------------------------------------------------
features<-read.table("UCI HAR Dataset/features.txt")
mean_and_std_features<- grep("-mean\\(\\)|-std\\(\\)", features[, 2])


# subset the desired columns
xdata <- xdata[, mean_and_std_features]

# correct the column names
names(xdata) <- features[mean_and_std_features, 2]

# 3. Use descriptive activity names to name the activities in the data set
#-------------------------------------------------------------------

activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# update values with correct activity names
ydata[, 1] <- activities[ydata[, 1], 2]

# correct column name
names(ydata) <- "activity"


# 4. Appropriately label the data set with descriptive variable names
#-------------------------------------------------------------------

# correct column name
names(subdata) <- "subject"

# bind all the data in a single data set
alldata <- cbind(xdata, ydata, subdata)


# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject
#-------------------------------------------------------------------

# 66 to 68 columns but last two (subject & subject)
averagesdata <- ddply(alldata, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averagesdata, "tidydata.txt", row.names = FALSE, quote = FALSE)

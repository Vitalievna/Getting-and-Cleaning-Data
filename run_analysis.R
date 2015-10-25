### The scipt to generate the tidy data from the given data set
## URL https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip .
## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#require(reshape2)
#temp <-tempfile()
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ", temp, mode = "wb")
#trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip '
#Content type 'application/zip' length 62556944 bytes (59.7 MB)
#downloaded 59.7 MB
#list.files<-unzip(temp)
#unlink(temp)
# now all files in the dataset downloaded and unzipped.

# Load: activity labels, only vector with values
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Load: data column names, only values=names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Extract only the measurements on the mean and standard deviation for each measurement.
# determine the indices of desired features (those containing -mean() or -std())
extract_features <- grepl("mean|std", features)

# Load and process X_test & y_test data & subject_test.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# assign names of X_text as features:
names(X_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,extract_features]

# Load activity labels and assign names of y_test and subject_test.
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Bind data(subiect_test + y_test +X_test)
test_data <- cbind(as.data.frame(subject_test), y_test, X_test)

# Load and process X_train & y_train data & subject_train.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# assign names of X_train as features.
names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_features]

# Load activity data and assign names of y_train and subject_train.
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Bind train_data(subject_train + y_train + X_train)
train_data <- cbind(as.data.frame(subject_train), y_train, X_train)
##print(str(train_data))

# Merge test and train data in one dataset data
data = rbind(test_data, train_data)
#print(head(data, n=3))

# assisn id_labels and measurable values of merged data.
id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function. Casting data frame.
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
##print(str(tidy_data))

# write tidy_data into tidy_data.txt file with row.names = FALSE to submit the file on github
write.table(tidy_data, file = "./tidy_data.txt", row.names = FALSE)
#test_check<-read.table("./tidy_data.txt")
#print(str(test_check))
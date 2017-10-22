#downloading data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/UCIML.zip")
#unzipping data
unzip(zipfile="./data/UCIML.zip",exdir="./data")

#reading training tables in to R

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#reading test tables in to R

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#reading data from the features vector

features <- read.table('./data/UCI HAR Dataset/features.txt')

#reading activity lables from the data

activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#assigning names to columns

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#merging data

training_merged <- cbind(y_train, subject_train, x_train)
test_merged <- cbind(y_test, subject_test, x_test)
full_merged <- rbind(training_merged, test_merged)

#extracting means and standard deviations

CN <- colnames(full_merged)
mean_SD <- (grepl("activityId" , CN) | 
            grepl("subjectId" , CN) | 
            grepl("mean.." , CN) | 
            grepl("std.." , CN) 
)
mean_SD_data <- full_merged[ , mean_SD == TRUE]

#tidy data set

TidyDataSet <- aggregate(. ~subjectId + activityId, mean_SD_data, mean)
TidyDataSet <- TidyDataSet[order(TidyDataSet$subjectId, TidyDataSet$activityId),]

# converting Activity IDs to names
TidyDataSet$activityId <- factor(TidyDataSet$activityId, levels = activityLabels[,1], labels = activityLabels[,2])
TidyDataSet$subjectId <- as.factor(TidyDataSet$subjectId)

write.table(TidyDataSet, "TidyDataSet.txt", row.name=FALSE)
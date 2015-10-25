library(dplyr)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (! file.exists("UCI-HAR.zip"))
    download.file(url, "UCI-HAR.zip")

if (! file.exists("UCI HAR Dataset"))
    unzip("UCI-HAR.zip")

dataset.var.names <- as.character(read.table("UCI HAR Dataset/features.txt")$V2)

dataset.test <- read.table("UCI HAR Dataset/test/X_test.txt")
features <- read.table("UCI HAR Dataset/test/y_test.txt")
subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

names(dataset.test) <- dataset.var.names

dataset.test$feature <- features$V1
dataset.test$subject <- subjects$V1


dataset.training <- read.table("UCI HAR Dataset/train/X_train.txt")
features <- read.table("UCI HAR Dataset/train/y_train.txt")
subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

names(dataset.training) <- dataset.var.names

dataset.training$feature <- features$V1
dataset.training$subject <- subjects$V1


dataset <- rbind(dataset.test, dataset.training)

activity.var.names  <- read.table("UCI HAR Dataset/activity_labels.txt")

for(i in 1:nrow(dataset)){
    dataset$feature[i] <- as.character(activity.var.names[activity.var.names$V1 == dataset$feature[i],]$V2)
}


dataset.filtered <- dataset[,grep(colnames(dataset), pattern = "mean\\(\\)|std\\(\\)|feature|subject")]

tidy <- aggregate(as.matrix(dataset.filtered[,1:(ncol(dataset.filtered)-2)]) ~ feature + subject, dataset.filtered, mean)

write.table(tidy, "tidy_data.txt", row.name=FALSE)
# libraries
library(reshape2)

# set working directory
setwd("~/Documents/Learning/Getting and cleaning data")

# read all data into memory
# read test data, subject and activity
test <- read.table("X_test.txt")
test.subject <- read.table("subject_test.txt")
test.activity <- read.table("y_test.txt")

# read training data, subjects, and labels
train <- read.table("X_train.txt")
train.subject <- read.table("subject_train.txt")
train.activity <- read.table("y_train.txt")

# features and activity labels
features <- read.table("features.txt")
activity.labels <- read.table("activity_labels.txt")
names(activity.labels) <- c("activity", "activity_name")

# find feature columns that are relevant (mean and std)
relevant.cols <- c(grep('-std()', features[,2]), grep('-mean()', features[,2]))

# reduce the test and train datasets to relevant columns
test.relevant.cols <- test[, relevant.cols]
train.relevant.cols <- train[, relevant.cols]

# combine test and training data
data <- rbind(train.relevant.cols, test.relevant.cols)
colnames(data) <- features[relevant.cols,2] 

# add activity to data
activity <- rbind(train.activity, test.activity)
colnames(activity) <- 'activity'
data <- cbind(data, activity)

# add subject to data
subject <- rbind(train.subject, test.subject)
colnames(subject) <- 'subject'
data <- cbind(data, subject)

# split data into list by activity and subject
data.split <- split(data[,1:79], data[,80:81])

# find average of each measurement
data.split.mean <- t(sapply(data.split, colMeans))

# split row names into activity and subject 
group <- strsplit(noquote(rownames(data.split.mean)), '[.]')
group.df <- data.frame(matrix(unlist(group), nrow=length(data.split.mean[,1]), byrow=T))
names(group.df) <- c('activity', 'subject')

# add descriptive names to activities
group.df <- merge(group.df, activity.labels, by="activity")

# finalize output
data.split.mean <- cbind(group.df, data.split.mean) 

# write output
write.table(data.split.mean, file="output.txt", row.name=F)

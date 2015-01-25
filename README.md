# getting_and_cleaning_data
Coursera: Getting and cleaning data


Read the following data into memory
1. test data: measurement, subject, activity
2. Training data: measurement, subject, activity
3. Features and activity labels

```{r}
test <- read.table("X_test.txt")
test.subject <- read.table("subject_test.txt")
test.activity <- read.table("y_test.txt")
train <- read.table("X_train.txt")
train.subject <- read.table("subject_train.txt")
train.activity <- read.table("y_train.txt")
features <- read.table("features.txt")
activity.labels <- read.table("activity_labels.txt")
names(activity.labels) <- c("activity", "activity_name")
```

Identify relevant columns - mean and std
Then reduce the test and training measurement data to contain only the relevant columns
Combine test and training data for processing

```{r}
relevant.cols <- c(grep('-std()', features[,2]), grep('-mean()', features[,2]))
test.relevant.cols <- test[, relevant.cols]
train.relevant.cols <- train[, relevant.cols]
data <- rbind(train.relevant.cols, test.relevant.cols)
colnames(data) <- features[relevant.cols,2] 
```

Add activity and subject to data for processing

```{r}
activity <- rbind(train.activity, test.activity)
colnames(activity) <- 'activity'
data <- cbind(data, activity)
subject <- rbind(train.subject, test.subject)
colnames(subject) <- 'subject'
data <- cbind(data, subject)
```

Split data into list by activity and subject
```{r}
data.split <- split(data[,1:79], data[,80:81])
```

Find average of each measurement
```{r}
data.split.mean <- t(sapply(data.split, colMeans))
```

Split row names into activity and subject 
```{r}
group <- strsplit(noquote(rownames(data.split.mean)), '[.]')
group.df <- data.frame(matrix(unlist(group), nrow=length(data.split.mean[,1]), byrow=T))
names(group.df) <- c('activity', 'subject')
```

Add descriptive names to activities
```{r}
group.df <- merge(group.df, activity.labels, by="activity")
```

Finalize and write output
```{r}
data.split.mean <- cbind(group.df, data.split.mean) 
write.table(data.split.mean, file="output.txt", row.name=F)
```

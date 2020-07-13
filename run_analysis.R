
library(dplyr) 
setwd("UCI HAR Dataset")
x_train   <- read.table("./train/X_train.txt")
y_train   <- read.table("./train/Y_train.txt") 

subject_train_val <- read.table("./train/subject_train.txt")
x_test   <- read.table("./test/X_test.txt")
y_test   <- read.table("./test/Y_test.txt") 
subject_test_val <- read.table("./test/subject_test.txt")
features <- read.table("./features.txt") 
get_activity_labels <- read.table("./activity_labels.txt") 

x_total_val   <- rbind(x_train, x_test)
y_total_val   <- rbind(y_train, y_test) 

subject_total_val <- rbind(subject_train_val, subject_test_val) 
features <- variable_names[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
x_total_val      <- x_total_val[,features[,1]]

colnames(x_total_val)   <- features[,2]
colnames(y_total)   <- "activity"
colnames(subject_total_val) <- "subject"

total <- cbind(subject_total_val, y_total, x_total_val)
total$activity <- factor(total$activity, levels = get_activity_labels[,1],
labels = activity_labels[,2]) 

total$subject  <- as.factor(total$subject) 
total_mean <- total %>% group_by(activity, subject) %>% summarize_all(funs(mean)) 
write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)

require(plyr)
require(data.table)

#dowload the file necessary to the rest of the code
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

#Step 0: create  the variables containing the raw datasets
uci_working_path <- "./UCI HAR Dataset"  
subjectTrain = read.table(paste(uci_working_path,'/train/subject_train.txt',sep=""),header=FALSE)
xTrain = read.table(paste(uci_working_path, '/train/x_train.txt',sep = ""),header=FALSE)
yTrain = read.table(paste(uci_working_path,'/train/y_train.txt',sep = ""),header=FALSE)

subjectTest = read.table(paste(uci_working_path,'/test/subject_test.txt',sep=""),header=FALSE)
xTest = read.table(paste(uci_working_path,'/test/x_test.txt',sep=""),header=FALSE)
yTest = read.table(paste(uci_working_path,'/test/y_test.txt',sep=""),header=FALSE)

#Step 1 (Merges the training and the test sets to create one data set)
subjectDataSet <- rbind(subjectTrain, subjectTest)
xDataSet <- rbind(xTrain, xTest)
yDataSet <- rbind(yTrain, yTest)



#Step 2 (Extract only the measurements on the mean and standard deviation for each measurement)
xDataSet_mean_std <- xDataSet[, grep("-(mean|std)\\(\\)", read.table(paste(uci_working_path,"/features.txt",sep=""))[, 2])] #check there
feature_data<-read.table(paste(uci_working_path,"/features.txt",sep=""))
names(xDataSet_mean_std) <- feature_data[grep("-(mean|std)\\(\\)", feature_data[, 2]), 2]

##############################################################################################################################
################## Integration from the other file ---> service to Step 3
activity_labels<-read.table(paste(uci_working_path,"/activity_labels.txt",sep=""),colClasses = c("character"))
xDataSet_mean_std_2 <- xDataSet[,grepl("mean|std|Subject|ActivityId", names(xDataSet))]
xDataSet_mean_std_2 <- join(xDataSet_mean_std_2, activity_labels, by = "ActivityId", match = "first")
##############################################################################################################################


#Step 3(Uses descriptive activity names to name the activities in the data set)
yDataSet[, 1] <- read.table(paste(uci_working_path,"/activity_labels.txt",sep=""))[yDataSet[, 1], 2]
names(yDataSet) <- "Activity"




#Step 4(Appropriately labels the data set with descriptive variable names)
names(subjectDataSet) <- "Subject"
summary(subjectDataSet)
singleDataSet <- cbind(xDataSet_mean_std, yDataSet, subjectDataSet)
names(singleDataSet) <- make.names(names(singleDataSet))
names(singleDataSet) <- gsub('Acc',"Acceleration",names(singleDataSet))
names(singleDataSet) <- gsub('GyroJerk',"AngularAcceleration",names(singleDataSet))
names(singleDataSet) <- gsub('Gyro',"AngularSpeed",names(singleDataSet))
names(singleDataSet) <- gsub('Mag',"Magnitude",names(singleDataSet))
names(singleDataSet) <- gsub('^t',"TimeDomain.",names(singleDataSet))
names(singleDataSet) <- gsub('^f',"FrequencyDomain.",names(singleDataSet))
names(singleDataSet) <- gsub('\\.mean',".Mean",names(singleDataSet))
names(singleDataSet) <- gsub('\\.std',".StandardDeviation",names(singleDataSet))
names(singleDataSet) <- gsub('Freq\\.',"Frequency.",names(singleDataSet))
names(singleDataSet) <- gsub('Freq$',"Frequency",names(singleDataSet))



#Step 5(From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject)
names(singleDataSet)

Data2<-aggregate(. ~Subject + Activity, singleDataSet, mean)
Data2<-Data2[order(Data2$Subject,Data2$Activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

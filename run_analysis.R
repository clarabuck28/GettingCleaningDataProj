library(dplyr)

#put training data into table
setwd("/Users/clarabuck1/Desktop/GettingCleaningData/UCI HAR Dataset")
setwd("train")
subjecttrain<- read.table("subject_train.txt")
if(!exists("xtrain")){
    xtrain <- read.table("X_train.txt")
}
if(!exists("ytrain")){
    ytrain <- read.table("y_train.txt")
}

#put test data into tables
setwd("/Users/clarabuck1/Desktop/GettingCleaningData/UCI HAR Dataset/test")
subjectest<- read.table("subject_test.txt")
if(!exists("xtest")){
    xtest <- read.table("X_test.txt")
}
if(!exists("ytest")){
    ytest <- read.table("y_test.txt")
}

#give the columns descriptive names
colnames(subjectest) <- c("subjectid")
colnames(subjecttrain) <- c("subjectid")
colnames(ytest) <- c("activity")
colnames(ytrain) <- c("activity")

#bind the data types together and bind the test and training sets together
mergeddatatest <- cbind(subjectest,type = "test",ytest,xtest)
mergeddatatrain <- cbind(subjecttrain,type = "train",ytrain,xtrain)
mergeddata <- rbind(mergeddatatest, mergeddatatrain)

#find the features which have std or mean in the name
setwd("/Users/clarabuck1/Desktop/GettingCleaningData/UCI HAR Dataset")
features <- read.table("features.txt")
meanvector <- c(grepl(x= features[,"V2"],pattern = "mean",fixed=TRUE))
stdvector <- c(grepl(x= features[,"V2"],pattern = "std",fixed=TRUE))

#subset the mergeddata to have only the std or mean columns and rename columns
meanstdvector <- meanvector | stdvector
mergeddata <-  mergeddata[,c(TRUE,TRUE,TRUE,meanstdvector)]
newnames <- c(colnames(mergeddata)[1:3],as.character(features[,"V2"])[meanstdvector])
colnames(mergeddata) <- newnames

activities <- read.table("activity_labels.txt")
for (x in length(mergeddata[,3])){
    activitynumber <- as.integer(mergeddata[x,3])
    mergeddata[x,3]<- activities[2,activitynumber]
}

#add column with activity names
mergeddata <- merge(activities, mergeddata, by.y = "activity", by.x = "V1" )


#use dplyr to rename activity column and get rid of numberic activity column
mergeddata <- as_tibble(mergeddata)
mergeddata <- rename(mergeddata, "activity" = V2)
mergeddata <- select(mergeddata, -c("V1"))

#make activity names all lowercase
mergeddata$activity <- tolower(mergeddata$activity)

#use dplyr to reorder so first column is subjectid and arrange by id
nameset <- colnames(mergeddata)[-(1:2)]
mergeddata <- select(mergeddata, c(subjectid, activity, all_of(nameset)))
mergeddata <- arrange(mergeddata, subjectid)

#creat tinydataset with the mean and std for each measurment and name them
tinydataset <- group_by(mergeddata,subjectid,activity,type)
tinydataset <- summarize_all(tinydataset, list(mean = mean, sd = sd))

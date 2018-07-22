#### download file ####
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "project",method = "curl")
#### unzip foleder####
unzip("project")

#### view files in folders ####
list.files(".")
list.files("UCI HAR Dataset")
list.files("UCI HAR Dataset/test")
#### Read activity Data ####
activities_labels <- read.table("UCI HAR Dataset/activity_labels.txt",stringsAsFactors = F)
activities_labels
str(activities_labels)
features<-read.table("UCI HAR Dataset/features.txt",stringsAsFactors = F)
str(features)
#### which features are mean and standard deviation ####
features_mean<-grep("mean()", features[,2],fixed = T) ### index of rows that are mean()
features[features_mean,] 
features_std <- grep("std()",features[,2],fixed = T)### index of rows thar are std()
features[features_std,]
length(features_mean) ## checking the lenght of rows
length(features_std)
################################################################
#### read in training data,only features meand and std ####
train <- read.table("UCI HAR Dataset/train/X_train.txt",col.names = features[,2])
str(train)
names(train)


#### filter mean and std ####
train <- train[,c(features_mean,features_std)]
head(train)
dim(train)
#### Modifing columns names ####
names(train) <- gsub(".","",names(train),fixed = T)
names(train) <- sub("mean","Mean",names(train))
names(train)<-sub("std","Std",names(train))


#### Read in activities and subject for training data ####
Subject_training <- read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "Subject")
dim(Subject_training)
head(Subject_training)
activities_training<-read.table("UCI HAR Dataset/train/y_train.txt",col.names = "activities")
dim(activities_training)
head(activities_training)
##### combine subjects,activities, and features, for training data ####
train <- cbind(activities_training,Subject_training,train)
dim(train)
names(train)
##########################################################
#### read in testing data,only features meand and std ####
test <- read.table("UCI HAR Dataset/test/X_test.txt",col.names = features[,2])
str(test)
names(test)


#### filter mean and std ####
test <- test[,c(features_mean,features_std)]
head(test)
dim(test)
#### Modifing columns names ####
names(test) <- gsub(".","",names(test),fixed = T)
names(test) <- sub("mean","Mean",names(test))
names(test)<-sub("std","Std",names(test))


#### Read in activities and subject for testing data ####
Subject_testing <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "Subject")
dim(Subject_testing)
head(Subject_testing)
activities_testing<-read.table("UCI HAR Dataset/test/y_test.txt",col.names = "activities")
dim(activities_testing)
head(activities_testing)
##### combine subjects,activities, and features, for testing data ####
test <- cbind(activities_testing,Subject_testing,test)
dim(test)
names(test)
#### Make a data tabel #####
#################################

#### combine train and test data ########

df<-rbind(train,test)
dim(df)
names(df)
######## Changing activities names ####
df$activities<-as.factor(df$activities) #### convert to factor 
levels(df$activities)<-activities_labels$V2 #### change level names
df$activities
##################################
#### creating data summary and activities###
require(dplyr)
df_tidy<-tbl_df(df)
df_tidy_summary<-df_tidy %>%
  group_by(Subject,activities) %>%
  summarise_all(funs(mean))
write.table(df_tidy_summary,file = "Tidy.txt",row.names = FALSE,quote = F)

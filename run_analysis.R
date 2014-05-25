#run_analysis.R

#Class example cleaning up data to create a tidy dataset

## Read in data
s.test = fread("test/subject_test.txt")
s.train = fread("train/subject_train.txt")
x.test = data.table(read.table("test/X_test.txt"))
x.train = data.table(read.table("train/X_train.txt"))
y.test = fread("test/y_test.txt")
y.train = fread("train/y_train.txt")
activity.labels = fread("activity_labels.txt")
features = fread("features.txt")$V2

## create useful column names
colnames(x.test) = features
colnames(y.test) = features
colnames(x.train) = features
colnames(y.train) = features

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## filter to only mean & std columns
keepIndex = features %like% "mean" | features %like% "std"

#must be a better way than iteratively!
smxtest = s.test
colNum=1
for(doKeep in keepIndex){
    if(doKeep){
        columnName = features[colNum]
        smxtest = cbind(smxtest,x.test[,colNum])
    }
    colNum = colNum+1
}
smxtest = cbind(smxtest,"Y" = y.test, "group" = "Test")
colnames(smxtest) = c("subject",
                      as.character(data.frame(features)[features %like% "mean" | features %like% "std",]),
                      "Y", "group")

smxtrain = s.train
colNum=1
for(doKeep in keepIndex){
    if(doKeep){
        columnName = features[colNum]
        smxtrain = cbind(smxtrain,x.test[,colNum])
    }
    colNum = colNum+1
}
smxtrain = cbind(smxtrain,"Y" = y.train, "group" = "Train")
colnames(smxtrain) = c("subject",
                       as.character(data.frame(features)[features %like% "mean" | features %like% "std",]),
                       "Y", "group")

## 1. Merges the training and the test sets to create one data set.

## append rows from test and train
dt = rbind(smxtest,smxtrain)

## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names. 
colnames(activity.labels) = c("Y","activity")
library(plyr)
dt2 = join(dt,activity.labels)

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
dtMelt = melt(dt2,id=c("subject","activity"),
              measure.vars=
                  as.character(
                      data.frame(features)[features %like% "mean",]))
s_a_avg = ddply(dtMelt,.(subject,activity,variable),"summarize",mean(value))
write.table(s_a_avg,file="avg by activity and subject")

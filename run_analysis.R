# This script creates a tidy data set which is a summary of the features used to
# create a classifier that can predict a subject's activity from the feature data.
# It is an implimentation of the requirements for the Getting And Cleaning Data
# course presented by John Hopkins / Coursera

# To run this script the data is assumed to be in a folder named "UCI HAR Dataset"
# under the working directory where this script is assumed to be saved to.

#The following license applies to the origional data set which can be found at:
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# License:
# ========
# Use of this dataset in publications must be acknowledged by referencing the following publication [1]
#
# [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
#
# This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.
#
# Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

library(dplyr)
library(tidyr)

# Read all of the relavent files of the dataset.

# Combine all training and test set observations to one data frame.
AllFeaturesDf <- rbind(read.table('./UCI HAR Dataset/train/X_train.txt'),
                       read.table('./UCI HAR Dataset/test/X_test.txt'))

# the variables of interest, per the requirements of the project
featuresDf <-  read.table(
    './UCI HAR Dataset/features.txt',
    stringsAsFactors=FALSE)$V2

YtrainDf <- read.table('./UCI HAR Dataset/train/Y_train.txt')
YtestDf <- read.table('./UCI HAR Dataset/test/Y_test.txt')

subjectTrainDf <- read.table('./UCI HAR Dataset/train/subject_train.txt',
                             stringsAsFactors=FALSE)
subjectTestDf <- read.table('./UCI HAR Dataset/test/subject_test.txt',
                            stringsAsFactors=FALSE)

activitiesLabelsDf <- read.table('./UCI HAR Dataset/activity_labels.txt')

########### Begin the exercise of creating a tidy dataset summary ############
featureIndexesOfInterest <- grep('mean|std',featuresDf)
featuresOfInterestDf <- select(AllFeaturesDf,featureIndexesOfInterest ))

# Name the columns with the appropriate variable names of the filtered
# variables. Do not change the names, because we need to be able to
# trace back to the original data source.
colnames(featuresOfInterestDf) <- featuresDf[featureIndexesOfInterest,2]

# Free up memory in case others who run this script
# do not have significant memory in their machine
rm(AllFeaturesDf)

# Create offset constant for test set subjects, so that we can later
# easily differentiate which group a subject comes from.
testSetIndexOffset <- max(subjectTrainDf$V1)

# Use the functions from the dplyr package to create the summaryTable
# with appropriate columns and group the data into a grouped
# object. once grouped summarize variables by activity and subject.
summaryDf <- as.data.frame(
    # Add the activity and subject variables to the feature variables.
    mutate(featuresOfInterestDf,
           activity = factor(
               c(YtrainDf[,1], YtestDf[,1]), labels=activitiesLabelsDf$V2),
           subject_id = c(subjectTrainDf$V1, subjectTestDf$V1 + testSetIndexOffset)
    ) %>%
        # Summarize the data on activity and subject as stated by requirements.
        group_by(activity, subject_id) %>%
        summarise_each(
            funs(mean),
            1:length(featureIndexesOfInterest)) %>%
        #Give the training and test subjects meaningful names.
        mutate(subject_group = factor(sapply(subject_id,
                                             function(x) {
                                                 if (x > testSetIndexOffset)
                                                     'Test'
                                                 else
                                                     'Train'
                                             })))  %>%
        # Narrow the data frame according to the principles of tidy data.
        gather(feature, n, 1:ncol(featuresOfInterestDf) + 2 ) %>%
        rename(feature_mean = n)
)

# Save the data frame with meaningful name and date as part of the name.
fileName <- paste('./summaryOfActivityClassifierFeatures_',
                  format(Sys.time(), "%m_%d_%Y_%H_%M_%S_%Z"),
                  '.txt',
                  sep='' )
# Save the summary report.
write.table(summaryDf, fileName, row.name=FALSE)



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
savedWorkingDirectory <- getwd()
setwd('~/GettingDataProject')

# Read all of the relavent files of the dataset.
XtrainDf <- read.table('./UCI HAR Dataset/train/X_train.txt')
XtestDf <- read.table('./UCI HAR Dataset/test/X_test.txt')
YtrainDf <- read.table('./UCI HAR Dataset/train/Y_train.txt')
YtestDf <- read.table('./UCI HAR Dataset/test/Y_test.txt')
subjectTrainDf <- read.table('./UCI HAR Dataset/train/subject_train.txt',
                             stringsAsFactors=FALSE)
subjectTestDf <- read.table('./UCI HAR Dataset/test/subject_test.txt',
                            stringsAsFactors=FALSE)
featuresDf <- read.table('./UCI HAR Dataset/features.txt',
                         stringsAsFactors=FALSE)
activitiesLabelsDf <- read.table('./UCI HAR Dataset/activity_labels.txt')

########### Begin the exercise of creating a tidy dataset summary ############

# Combine all training and test set observations to one data frame.
AllObservationsDf <- rbind(XtrainDf, XtestDf)
# Using the featuresDf that was loaded, select only the variables
# of interest, per the requirements of the project
variableIndexesOfInterest <- grep('mean|std', featuresDf[,2])
ObservationsOfInterestDf <- select(AllObservationsDf,variableIndexesOfInterest)

# Name the columns with the appropriate variable names of the filtered variables
colnames(ObservationsOfInterestDf) <- featuresDf[variableIndexesOfInterest,2]
variableNamesOfInterest <- strsplit(colnames(ObservationsOfInterestDf), '')

# Free up memory in case others who run this script
# do not have significant memory in their machine
rm(XtrainDf, XtestDf, AllObservationsDf)

# Create offset constant for test set subjects, so that we can later
# easily differentiate the two when we give the entries meaningful names.
testSetIndexOffset <- max(subjectTrainDf$V1)

# Use the functions from the dplyr package to create the summaryTable
# with appropriate columns and group the data into a grouped
# object. once grouped summarize variables by activity and subject.
# Finally, replace the numeric subject column with meaningful values.
summaryTable <-as.data.frame(
    mutate(ObservationsOfInterestDf,
       activity = factor(
           c(YtrainDf[,1], YtestDf[,1]), labels=activitiesLabelsDf$V2),
       subject = c(subjectTrainDf$V1, subjectTestDf$V1 + testSetIndexOffset)
           ) %>%
    group_by(activity, subject) %>%
    summarise_each(
        funs(mean),
        1:length(variableIndexesOfInterest)) %>%
    mutate(subject = factor(sapply(subject,
        function(x) {
            if (x > testSetIndexOffset)
                paste('Test Id ',  toString(x - testSetIndexOffset))
            else
                paste('Train Id',  toString(x))
        })))
    )

# Save the data frame with meaningful name and date as part of the name.
fileName <- paste('./summaryOfActivityClassifierFeatures_',
                  format(Sys.time(), "%m_%d_%Y_%H_%M_%S_%Z"),
                  '.txt',
                  sep='' )
# Save the summary report.
write.table(summaryDf, fileName, row.name=FALSE)
setwd(savedWorkingDirectory)


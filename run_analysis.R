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
subjectTrainDf <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subjectTestDf <- read.table('./UCI HAR Dataset/test/subject_test.txt')
featuresDf <- read.table('./UCI HAR Dataset/features.txt',
                         stringsAsFactors=FALSE)
activitiesLabelsDf <- read.table('./UCI HAR Dataset/activity_labels.txt')

# Combine all training and test set observations to one data frame.
AllObservationsDf <- rbind(XtrainDf, XtestDf)

# Free up memory in case others who run this script
# do not have significant memory in their machine
rm(XtrainDf, XtestDf)

# Using the featuresDf that was loaded, select only the variables
# of interest, per the requirements of the project
variableIndexesOfInterest <- grep('mean|std', featuresDf[,2])
ObservationsOfInterestDf <- select(AllObservationsDf,variableIndexesOfInterest)

# Name the columns with the appropriate variable names of the filtered variables
colnames(ObservationsOfInterestDf) <- featuresDf[variableIndexesOfInterest,2]
variableNamesOfInterest <- strsplit(colnames(ObservationsOfInterestDf), '')

# Combine the training and test set observations into a single vector, but
# add a constant to each of the test set subjects, so that we can later
# easily differentiate the two when we give the entries meaningful names.
testSetIndexOffset <- max(subjectTrainDf$V1)
subjects <- c(subjectTrainDf$V1, subjectTestDf$V1 + testSetIndexOffset)

# Now add the vector as a new column to the primary data set and name it.
ObservationsOfInterestDf <- cbind(ObservationsOfInterestDf, subjects)
names(ObservationsOfInterestDf)[dim(ObservationsOfInterestDf)[2]] <- 'subject'

# The activity variables are combined into one vector and converted to a
# factor vector, prior to grouping according to activity and subject.
activity <- factor(c(YtrainDf[,1], YtestDf[,1]), labels=activitiesLabelsDf$V2)
ObservationsOfInterestDf <- cbind(ObservationsOfInterestDf, activity)

# Use the functions from the dplyr package to group the data into a grouped
# object. The grouped by object wraps the dataframe and maintains indexes
# into the data based on the grouping variables, activity and subject.
byActivityThenSubjectDf <- group_by(ObservationsOfInterestDf, activity, subject)
summaryTable <- summarise_each(
    byActivityThenSubjectDf,
    funs(mean),
    1:length(variableIndexesOfInterest))

# Now we can coerce the summaryTable to a normal data frame and from
# there we can give the values of the subject variable meaningful names.
# per the requirements of the project.
summaryDf <- as.data.frame(summaryTable)
summaryDf [,2] <- factor(sapply(summaryDf[,2],
                         function(x) {
                             if (x > testSetIndexOffset)
                                 paste('Test Id ',  toString(x - testSetIndexOffset))
                             else
                                 paste('Train Id',  toString(x))
                             }
                        )
                    )
# Save the data frame with meaningful name and date as part of the name.
fileName <- paste('./summaryOfActivityClassifierFeatures_',
                  format(Sys.time(), "%m_%d_%Y_%H_%M_%S_%Z"),
                  '.csv',
                  sep='' )
# Save the summary report.
write.csv(summaryDf, fileName)
setwd(savedWorkingDirectory)


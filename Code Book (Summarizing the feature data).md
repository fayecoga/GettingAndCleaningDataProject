Code Book (Summarizing the feature data for an activity classifier)
------------------------------------------------------------------------
Student: Faye Gazave

Instructor: Jeff Leek, PhD

Course: Getting and Cleaning Data

November 22, 2014

The Raw Data
------------------
The [data set][]  source used for this exercise comes from the [UCI][]

The Tidy Data
------------------
The tidy data produced by the R script in this repository is a data frame consisting of 14220 observations of  5 variables.  The variables are as follows.

* activity
	
	A factor variable from the raw data file './UCI HAR Datasetactivity_labels.txt'.

	 The activity factor maps over the raw data files './UCI HAR Dataset/train/Y_train.txt' and './UCI HAR Dataset/test/Y_test.txt' to give human readable meaning to the numerical identifiers.
	 
	The activity factor is also the prediction class that a particular set of feature variables for the given machine learning classifier will be used to predict.

* subject_id
	
	The individual under observation, who's mobile device provides the source of the feature data. 

* subject_group
	
	The group for which a particular subject is a member of. A subject is either a member of the training set or a member of the test set. Most subjects belong to the training group, who's feature data were used to build the classifier and predict the outcome activity of the members of the test group.
* feature
	
	A subset of variables that are either a raw variable or a computed variable of the Samsung triaxial accelerometer, and or gyroscope. The subset of features are all of the feature variables from the raw data set that represent either a mean or  variance. The variable names of the subset are identical to that of the raw data, therefore one may go to the code book of the raw data to determine the meaning of a given feature variable.


* feature_mean 

The Code Recipe
----------------------
The code recipe is an R script located at the [student repo] staged on her github account.
The tidy summary data set has the date of the script execution embedded into the file name. 
###Software and Hardware###
platform       x86_64-apple-darwin13.1.0   
arch           x86_64                      
os             darwin13.1.0                
system         x86_64, darwin13.1.0        
status                                     
major          3                           
minor          1.1                         
year           2014                        
month          07                          
day            10                          
svn rev        66115                       
language       R                           
version.string R version 3.1.1 (2014-07-10)
nickname       Sock it to Me   

[data set]:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  


[UCI]:http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

[student repo]:https://github.com/fayecoga/GettingAndCleaningDataProject.git


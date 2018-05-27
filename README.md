The project lies on some data analysis operations to perform on a dataset that contains data collected from the accelerometers from Samsung Galaxy S smartphone (to have more details one can see the whole description at the following link: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
The ultimate goal of the project is to create a tidy dataset starting from the native dataset, that can be usable for further analysis. 
To do so, the file run_Analysis has been creadted.
The first operation included in that file is to download the aforementioned dataset at the following link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The further steps are in the following order
Step 0:  the variables aimed at storing the raw datasets are defined
Step 1:  the raw data sets are organized and combined into a single one
Step 2:  Extract only the measurements on the mean and standard deviation for each measurement
Step 3: the activities in the dataset are named after the descriptive activity names
Step 4: the dataset is labelled via the descriptive variable names
Step 5: finally a new tidy dataset is created: its objective being to store the avg. of each variable for each activity and subject,
having done so, it is saved in a file named "tidydata.txt"

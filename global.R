# One time settings
dataFilePath <- "~/RecycleBank/Data/eventsRecyclebank_diq20151130.csv"
sampleProcent <- 1
replace <- TRUE

# Get the data
dataSet <- read.csv(dataFilePath)
set.seed(4690)
sampleSize <- length(unique(dataSet$maxId))*sampleProcent
index <- sample(dataSet$maxId,size = sampleSize, replace = replace)
dataSet <- dataSet[dataSet$maxId %in% index,order(names(dataSet))]
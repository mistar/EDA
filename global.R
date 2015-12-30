get_iris_data <- function() {
  sandboxyr::setCredentials(iamrole="analyticsSandboxServerRole")
  iris_data <- sandboxyr::getS3Object(awsregion="eu-west-1",
                                      s3bucket="analytics.sandbox.data",
                                      s3object="sample_datasets/iris_dataset/iris.csv")
  return(iris_data)
}

# One time settings
#dataFilePath <- "~/RecycleBank/Data/eventsRecyclebank_diq20151130.csv"
# sampleProcent <- 1
# replace <- TRUE

# Get the data
# dataSet <- read.csv(dataFilePath)
dataSet <- get_iris_data()
# set.seed(4690)
# sampleSize <- nrow(dataSet)*sampleProcent
# index <- sample(dataSet,size = sampleSize, replace = replace)
# dataSet <- dataSet[index]

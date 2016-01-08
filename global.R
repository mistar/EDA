getS3Data <- function(s3Object="sample_datasets/iris_dataset/iris.csv") {
  sandboxyr::setCredentials(iamrole="analyticsSandboxServerRole")
  irisData <- sandboxyr::getS3Object(awsregion="eu-west-1",
                                      s3bucket="analytics.sandbox.data",
                                      s3object=s3Object)
}

listS3Objects <- function(){
  sandboxyr::setCredentials(iamrole="analyticsSandboxServerRole")
  s3List <- sandboxyr::getS3Bucket(awsregion="eu-west-1",
                                  s3bucket="analytics.sandbox.data") 
  s3List <- lapply(s3List[names(s3List)=="Contents"],function(x){x$Key})
  l <- as.list(NA)
  for (i in 1:length(s3List)){
    l <- c(l,s3List[[i]])
  }
  l <- l[grep("*.csv",l)]
}

dataSet <- data.frame(NA)
getS3Data <- function(awsregion,s3Bucket,s3Object) {
  sandboxyr::setCredentials(iamrole="analyticsSandboxServerRole")
  irisData <- sandboxyr::getS3Object(awsregion=awsregion,
                                      s3bucket=s3Bucket,
                                      s3object=s3Object)
}

listS3Objects <- function(awsregion,s3Bucket){
  sandboxyr::setCredentials(iamrole="analyticsSandboxServerRole")
  s3List <- sandboxyr::getS3Bucket(awsregion=awsregion,
                                  s3bucket=s3Bucket) 
  s3List <- lapply(s3List[names(s3List)=="Contents"],function(x){x$Key})
  l <- as.list(NA)
  for (i in 1:length(s3List)){
    l <- c(l,s3List[[i]])
  }
  l <- l[grep("*.csv",l)]
}

<<<<<<< HEAD
dataSet <- data.frame(NA)
=======
dataSet <- data.frame(NA)
>>>>>>> origin/master

get_iris_data <- function() {
  sandboxyr::setCredentials(iamrole="analyticsSandboxServerRole")
  iris_data <- sandboxyr::getS3Object(awsregion="eu-west-1",
                                     s3bucket="analytics.sandbox.data",
                                     s3object="sample_datasets/iris_dataset/iris.csv")
  return(iris_data)
}
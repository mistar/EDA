getS3Data <- function(awsregion,s3Bucket,s3Object) {
  sandboxyr::setCredentials(iamrole="analyticsSandboxServerRole")
  selection <- sandboxyr::getS3Object(awsregion=awsregion,
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

getMongoDBDatabase <- function(host){
  mongost <- rmongodb::mongo.create(host = host)
  if (rmongodb::mongo.is.connected(mongost)) {
    rmongodb::mongo.get.databases(mongost)
  }
}

getMongoDBCollection <- function(host, db){
  mongost <- rmongodb::mongo.create(host = host)
  if (rmongodb::mongo.is.connected(mongost)) {
    rmongodb::mongo.get.database.collections(mongost, db = db)
  }
}

getMongoDBData <- function(host, collection,query,limit){
  mongost <- rmongodb::mongo.create(host = host)
  if (rmongodb::mongo.is.connected(mongost)) {
    if (limit == "" & query == ""){
      cursor <- rmongodb::mongo.find(mongost,collection)
    } else if (limit == ""){
      cursor <- rmongodb::mongo.find(mongost,collection, query=query)
    } else if (query == ""){
      limit <- as.integer(limit)
      cursor <- rmongodb::mongo.find(mongost,collection, limit=limit)
    } else {
      limit <- as.integer(limit)
      cursor <- rmongodb::mongo.find(mongost,collection, query=query,limit=limit)
    }
    rmongodb::mongo.cursor.to.data.frame(cursor, nullToNA = TRUE)
  }
}

dataSet <- data.frame(NA)
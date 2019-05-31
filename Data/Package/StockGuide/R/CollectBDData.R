#' Consolidate 10K data into one table
#' @return Writes a final data table with all downloaded 10K information to the location specified in the code
#' @examples CollectBDData()



CollectBDData <- function(){

  NASDAQ <- read.csv(file = paste0("/rdata/10k", "/NASDAQCompanyList.csv"), colClasses = "character")
  load("/rdata/src/r-libraries/ALLCIK.RData")
  #read.csv(file = "C:/Users/hwalbert001/Documents/Company Stock Analysis/companylistFROMEUGENE.csv", colClasses = "character")
  NASDAQ <- merge(NASDAQ, ALLCIK, all.x = T, by = "Symbol")
  NASDAQ <- subset(NASDAQ, !is.na(NASDAQ$CIK))

  finaldata <- data.frame()

  #dfBucket <- get_bucket_df(Sys.getenv("BUCKET_NAME"), 'Business descriptions text/', max=100)
  dfBucket <- get_bucket_df(Sys.getenv("BUCKET_NAME"), 'Business descriptions text/', max=Inf)

  path <- dfBucket$Key

  counter <- 0
  s3Value <- NULL
  for (lineN in path) {
    counter = counter + 1
    bucket <- paste("s3://",Sys.getenv("BUCKET_NAME"), sep="")

    url <- paste(bucket,lineN, sep= "/")
    cat(counter)
    cat(url)
    cat('\n')

    #s3Vector <- get_object(url)
    s3File = save_object(url)

    x <- readtext(s3File)
    #s3Value <- rawToChar(s3Vector)

    finaldata <- rbind(finaldata, x)
    rm(s3File)
  }

  breakoutInfo <- t(data.frame(strsplit(finaldata$doc_id, split = "_")))
  finaldata <- cbind(finaldata, breakoutInfo)
  names(finaldata) <- c("doc_id", "text", "CIK", "Source", "YearDate", "File")
  finaldata <- merge(finaldata, NASDAQ, all.x = T, by = "CIK")
  finaldata <- finaldata[c("CIK", "YearDate", "text", "Symbol", "Name.x")]

  # finaldata$text <- gsub("/(\r\n|\n|\r)/gm", "", finaldata$text)
  finaldata$text <- gsub("[\r\n]", "", finaldata$text)
  finaldata$YEAR <- substr(finaldata$YearDate, 1, 4)
  #return(finaldata)

  write.csv(finaldata, file = "BDData.csv", row.names = F)
}

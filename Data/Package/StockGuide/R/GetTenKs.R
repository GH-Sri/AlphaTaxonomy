#' Get 10K data for specified CIKs for years 2008 - 2018
#' @param CIK_Index An index for the number of different CIKs to pull
#' @return Will output text files to location specified in the newEDGAR() function
#' @examples GetTenKs(CIK_Index = 1:100)

GetTenKs <- function(CIK_Index = 1:500){
  #Get the refreshed Company data from the NASDAQ website
  NASDAQ <- GetCompanyList(Exchange = "NASDAQ")

  load("/rdata/src/r-libraries/ALLCIK.RData")
  #read.csv(file = "C:/Users/hwalbert001/Documents/Company Stock Analysis/companylistFROMEUGENE.csv", colClasses = "character")
  NASDAQ <- merge(NASDAQ, ALLCIK, all.x = T, by = "Symbol")
  NASDAQ <- subset(NASDAQ, !is.na(NASDAQ$CIK))

  #Make a list of unique CIKs
  #note that all ciks are not unique
  CIKs <- as.numeric(unique(NASDAQ$CIK))
  CIKs <- CIKs[!is.na(CIKs)]
  cat("There are", length(CIKs), "unique CIK values \n")

  #Okay, This is where we get all the Business Descriptions
  #The getBusinDescr() function pulls the master indexes from the SEC server for each year specified...
  #This gets stored in the working directory in a folder called Business description test
  counter = 0
  # for(i in CIKs[1:500]){#THIS IS FOR TESTING
  # for(i in CIKs[1:length(CIKs)]){
  for(i in CIKs[CIK_Index]){
    counter <- counter + 1
    cat("Counter:", counter, "\n")
    cat("working on", i, "\n")
    mapply(newEDGAR, cik = i, filing.year = c(2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018))
  }
}


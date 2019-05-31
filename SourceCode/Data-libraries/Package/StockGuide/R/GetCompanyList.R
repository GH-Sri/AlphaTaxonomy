#' Get the latest company list for NASDAQ####
#'
#' @param Exchange Defaults to "NASDAQ". Other possible values are "NYSE" & "AMEX"
#'
#' @return A dataframe with the company list associated with the exchange requested
#' @export
#'
#' @examples GetCompanyList(Exchange = "NASDAQ")

#Get the latest company list for NASDAQ####
GetCompanyList <- function(Exchange = "NASDAQ"){
  if(!exists("MyWorkingDirectory")){MyWorkingDirectory <- setwd("/rdata/10k")}

  if(Exchange == "NASDAQ"){
    download.file(url = "https://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=nasdaq&render=download",
                  destfile = paste0(MyWorkingDirectory, "/NASDAQCompanyList.csv"))
    NASDAQCompList <- read.csv(file = paste0(MyWorkingDirectory, "/NASDAQCompanyList.csv"), colClasses = "character")
    return(NASDAQCompList)
  }

  if(Exchange == "NYSE"){
    download.file(url = "https://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=nyse&render=download",
                  destfile = paste0(MyWorkingDirectory, "/NYSECompanyList.csv"))
    NYSECompList <- read.csv(file = paste0(MyWorkingDirectory, "/NYSECompanyList.csv"), colClasses = "character")
    return(NYSECompList)
  }

  if(Exchange == "AMEX"){
    download.file(url = "https://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=amex&render=download",
                  destfile = paste0(MyWorkingDirectory, "/AMEXCompanyList.csv"))
    AMEXCompList <- read.csv(file = paste0(MyWorkingDirectory, "/AMEXCompanyList.csv"), colClasses = "character")
    return(AMEXCompList)
  }

}

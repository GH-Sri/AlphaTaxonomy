
#Make a list of all the files
WikiAndWebFiles <- list.files(path = "C:/Users/hwalbert001/Documents/Company Stock Analysis/Wikipedia", full.names = T)
#Import each file and stack on top of the previous file
WikiAndWebData <- data.frame()
for (i in WikiAndWebFiles) {
  df <- read.csv(file = i, colClasses = "character")
  WikiAndWebData <- rbind(WikiAndWebData, df)
}
#Write the data 
write.csv(x = WikiAndWebData, file = "C:/Users/hwalbert001/Documents/Company Stock Analysis/Wikipedia/AllWikiAndWebData.csv", row.names = F)

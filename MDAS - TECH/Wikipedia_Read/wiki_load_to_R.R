
setwd("./Wikipedia_Read")
library(rjson)

wiki_ <- rjson::fromJSON(file = "Wikipedia_Data.json")

company <- names(wiki_[[2]])

wiki_df = NULL 
for(i in company){ 
  
temp.df <- cbind.data.frame(name = i, 
                            wiki_number =  wiki_[[2]][[i]],
                            short_descript = wiki_[[3]][[i]], 
                            sections_long_descript = wiki_[[4]][[i]],
                            stringsAsFactors = FALSE)
 
wiki_df <- rbind.data.frame(wiki_df,temp.df, stringsAsFactors = FALSE)
 }


write.csv(wiki_df,file = "wiki_scrape.csv")




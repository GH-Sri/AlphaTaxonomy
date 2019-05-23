wiki_db_creator <- function(jsonfile){ 
  #' Reads the Wikipedia_Data.json 
  #' and creates the wiki_df table that will be merged 
  #' to both the companylist and website metadata tables. 
  #' 
  if(require(rjson) == FALSE){ 
    message("rjson is needed!")
    install.packages("rjson")
    library(rjson)
    }
  wiki_ <- fromJSON(file = jsonfile)
  company <- names(wiki_[[2]])
  
  wiki_df = NULL 
  for(i in company){ 
    
    temp.df <- cbind.data.frame(name = i, 
                                wiki_2 =  wiki_[[2]][[i]],
                                short_descript = wiki_[[3]][[i]], 
                                sections_long_descript = wiki_[[4]][[i]],
                                stringsAsFactors = FALSE)
    
    wiki_df <- rbind.data.frame(wiki_df,temp.df, stringsAsFactors = FALSE)
  }
  
  return(wiki_df)
}

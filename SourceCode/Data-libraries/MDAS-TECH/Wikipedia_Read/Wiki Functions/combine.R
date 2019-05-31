combine <- function(companylist, website_metadata, wiki_data){ 
  #' combines all of the datasets generated from public 
  #' sources: yahoo finance, site website, and wikipedia 
  m1 <- merge(companylist, wiki_data,by.x = "Name",by.y = "companylist_name",all.x = TRUE,
              all.y = TRUE)
  m2 <- merge(m1, website_metadata, by.x = "Symbol", by.y = "ticker",all.x = TRUE, all.y = TRUE)
  
  return(m2)
  }
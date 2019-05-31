clean_site <- function(site){ 
  #' fixes miscellaneous issues with website scrape 
  x = site 
  x = gsub("\\.com/.*","\\.com",x) # clean anything that has (literal) ".com/" and replace it with .com 
  x = gsub(".*s\\.yimg.*","",x)    # s.yimg is found at all, erase the link. That's an error. 
  x = gsub("\\.com\\. .*","\\.com",x) # replace ".com. " with ".com" and erase everything after
  # preserves .com.cn 
  x = gsub("\\.com\\ .*","\\.com",x) #replaces ".com " with ".com" and erases everything after
  x = gsub("\\.com\\.<.*","\\.com",x) # replace ".com.<" with ".com" and erase everything after
  x = gsub("\\.com\\,.*","\\.com",x) # replace ".com," with ".com" and erase everything after
  
  # .gov 
  x = gsub("\\.gov/.*","\\.gov",x) # clean anything that has (literal) ".gov/" and replace it with .gov 
  x = gsub(".*s\\.yimg.*","",x)    # s.yimg is found at all, erase the link. That's an error. 
  x = gsub("\\.gov\\. .*","\\.gov",x) # replace ".gov. " with ".gov" and erase everything after
  # preserves .gov.cn 
  x = gsub("\\.gov\\ .*","\\.gov",x) #replaces ".gov " with ".gov" and erases everything after
  x = gsub("\\.gov\\.<.*","\\.gov",x) # replace ".gov.<" with ".gov" and erase everything after
  x = gsub("\\.gov\\,.*","\\.gov",x) # replace ".gov," with ".gov" and erase everything after
  
  # .net 
  
  x = gsub("\\.net/.*","\\.net",x) # clean anything that has (literal) ".net/" and replace it with .net 
  x = gsub(".*s\\.yimg.*","",x)    # s.yimg is found at all, erase the link. That's an error. 
  x = gsub("\\.net\\. .*","\\.net",x) # replace ".net. " with ".net" and erase everything after
  # preserves .net.cn 
  x = gsub("\\.net\\ .*","\\.net",x) #replaces ".net " with ".net" and erases everything after
  x = gsub("\\.net\\.<.*","\\.net",x) # replace ".net.<" with ".net" and erase everything after
  x = gsub("\\.net\\,.*","\\.net",x) # replace ".net," with ".net" and erase everything after
  
  # .org 
  x = gsub("\\.org/.*","\\.org",x) # clean anything that has (literal) ".org/" and replace it with .org 
  x = gsub(".*s\\.yimg.*","",x)    # s.yimg is found at all, erase the link. That's an error. 
  x = gsub("\\.org\\. .*","\\.org",x) # replace ".org. " with ".org" and erase everything after
  # preserves .org.cn 
  x = gsub("\\.org\\ .*","\\.org",x) #replaces ".org " with ".org" and erases everything after
  x = gsub("\\.org\\.<.*","\\.org",x) # replace ".org.<" with ".org" and erase everything after
  x = gsub("\\.org\\,.*","\\.org",x) # replace ".org," with ".org" and erase everything after
  
  return(x)
}

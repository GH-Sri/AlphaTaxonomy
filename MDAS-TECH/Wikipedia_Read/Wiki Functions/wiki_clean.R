wiki_clean <- function(x){ 
  #'  Removes subsection and section headers 
  #'  changes the delimiter ("#|#|#") to a simple space 
  #'  remove everything within a parantheses - this solves 
  #'  the issue of foreign characters and styles in non UTF-8 formats 
  #'  removes line breaks as well   
  
x <- gsub(pattern = "#|#|#",replacement = " ",x = x, fixed = TRUE)  
x <- gsub("subsections|Section|\\([^\\)]*)"," ",x = x, ignore.case = TRUE)
x <- gsub("== References ==","",x = x, fixed = TRUE)
x <- gsub("\\\n|\\\r"," ",x)
return(x)
}

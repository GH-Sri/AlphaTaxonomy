# DATA
Starting a DATA folder to upload my Wikipedia data. We can potentially move this elsewhere later, just need a location for this upload.

TEXT DATA CUSTOM DELIMITER ( "#|#|#" ) : 
A custom delimiter was used to seperate the many values returned for the columns "sections", "categories", "links" and "backlinks" for each page.
The delimiter is "#|#|#" -- probably overkill, I apologize. 
If there is a need to sperate out the idividual sections, categories, links and back links for a single company, the string value should be split using "#|#|#".
If you are simply cleaning the non-alphnumeric of symbols, the symbol replacement should be " ", otherwise words will unintentionally concatenate.

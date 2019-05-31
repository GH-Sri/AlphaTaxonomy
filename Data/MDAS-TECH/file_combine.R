files <- c("./Results_of_Wiki_Web_Pipeline_Scripts/public_data_for_doc2vec_1.csv",
  "./Results_of_Wiki_Web_Pipeline_Scripts/public_data_for_doc2vec_2.csv",
  "./Results_of_Wiki_Web_Pipeline_Scripts/public_data_for_doc2vec_3.csv",
  "./Results_of_Wiki_Web_Pipeline_Scripts/public_data_for_doc2vec_4.csv",
  "./Results_of_Wiki_Web_Pipeline_Scripts/public_data_for_doc2vec_5.csv",
  "./Results_of_Wiki_Web_Pipeline_Scripts/public_data_for_doc2vec_6.csv",
  "./Results_of_Wiki_Web_Pipeline_Scripts/public_data_for_doc2vec_7.csv")

file_combine <- function(files){ 
  #' "public_data_for_doc2vec_1.csv"
  #' public_data_for_doc2vec_2
  #' public_data_for_doc2vec_3
  #' public_data_for_doc2vec_4
  #' public_data_for_doc2vec_5
  #' public_data_for_doc2vec_6
  #' public_data_for_doc2vec_7
  #' 
  # this function combines the csv 
  # run it from the appropriate directory. 
  
  combined = NULL
for(i in files){ 
  temp. <- read.csv(i,stringsAsFactors = FALSE)
  combined <- rbind.data.frame(combined,temp.,stringsAsFactors = FALSE)
  }  
  return(combined)
  }
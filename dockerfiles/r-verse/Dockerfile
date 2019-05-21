FROM rocker/verse:3.6.0

RUN apt-get update && apt-get install -y libpoppler-cpp-dev libapparmor-dev

# Install R packages ----------------------------------------------------------#

RUN install2.r --error -r 'http://cran.r-project.org' textTinyR jsonlite data.table tm XML

RUN install2.r --error -r 'http://cran.r-project.org' WikipediR Hmisc zoo rvest curl digest

RUN install2.r --error -r 'http://cran.r-project.org' stringi purrrlyr rJava ggplot2 trelliscopejs lubridate purrr stringr icesTAF tokenizers text2vec NLP

RUN install2.r --error -r 'http://cran.r-project.org' NLP sparklyr SparkR

RUN install2.r --error -r 'http://cran.r-project.org' edgar

RUN install2.r --error -r 'http://cran.r-project.org' readtext

RUN install2.r --error -r 'http://cran.r-project.org' aws.s3


#sudo pip install sagemaker boto3

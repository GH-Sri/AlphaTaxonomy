#' Modified version of edgar::getBusinDescr() function
#'
#' @param cik.no The Central Index Key given as a number
#' @param filing.year A numeric year or vector of numeric years
#'
#' @return The business description for the given CIKs and years
#' @examples newEDGAR(cik = 6201, filing.year = c(2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018))
#' @details This function is originally from the edgar package...it has been adjusted to deal with the error: "Error in writeLines(product.descr2, filename2) : object 'product.descr2' not found "

#This function is originally from the edgar package...it has been adjusted to deal with the error:
#"Error in writeLines(product.descr2, filename2) : object 'product.descr2' not found "
newEDGAR <- function (cik.no, filing.year)
{
  # f.type <- c("10-K", "10-K405", "10KSB", "10KSB40")
  f.type <- c("10-K")
  if (!is.numeric(filing.year)) {
    cat("Please check the input year.")
    return()
  }
  output <- getFilings(cik.no = cik.no, form.type = f.type,
                       filing.year, quarter = c(1, 2, 3, 4), downl.permit = "y")
  if (is.null(output)) {
    return()
  }
  cat("Extracting 'Item 1' section...\n")
  progress.bar <- txtProgressBar(min = 0, max = nrow(output),
                                 style = 3)
  CleanFiling2 <- function(text) {
    text <- gsub("[[:digit:]]+", "", text)
    text <- gsub("\\s{1,}", " ", text)
    text <- gsub("\"", "", text)
    return(text)
  }
  for (i in 1:nrow(output)) {
    f.type <- gsub("/", "", output$form.type[i])
    year <- output$filing.year[i]
    cik <- output$cik[i]
    date.filed <- output$date.filed[i]
    accession.number <- output$accession.number[i]
    dest.filename <- paste0("Edgar filings_full text/Form ",
                            f.type, "/", cik, "/", cik, "_", f.type, "_", date.filed,
                            "_", accession.number, ".txt")
    filing.text <- readLines(dest.filename)
    filing.text <- filing.text[(grep("<DOCUMENT>", filing.text,
                                     ignore.case = TRUE)[1]):(grep("</DOCUMENT>", filing.text,
                                                                   ignore.case = TRUE)[1])]
    if (any(grepl(pattern = "<xml>|<type>xml|<html>|10k.htm",
                  filing.text, ignore.case = T))) {
      doc <- XML::htmlParse(filing.text, asText = TRUE)
      f.text <- XML::xpathSApply(doc, "//text()[not(ancestor::script)][not(ancestor::style)][not(ancestor::noscript)][not(ancestor::form)]",
                                 XML::xmlValue)
      f.text <- iconv(f.text, "latin1", "ASCII", sub = " ")
    }
    else {
      f.text <- filing.text
    }
    f.text <- gsub("\\n|\\t|,", " ", f.text)
    f.text <- gsub("\\s{2,}|\\/", " ", f.text)
    f.text <- gsub("^\\s{1,}", "", f.text)
    f.text <- gsub("Items", "Item", f.text, ignore.case = TRUE)
    f.text <- gsub("PART I", "", f.text, ignore.case = TRUE)
    f.text <- gsub("Item III", "Item 3", f.text, ignore.case = TRUE)
    f.text <- gsub("Item II", "Item 2", f.text, ignore.case = TRUE)
    f.text <- gsub("Item I|Item l", "Item 1", f.text, ignore.case = TRUE)
    f.text <- gsub(":|\\*", "", f.text, ignore.case = TRUE)
    f.text <- gsub("-", " ", f.text)
    f.text <- gsub("ONE", "1", f.text, ignore.case = TRUE)
    f.text <- gsub("TWO", "2", f.text, ignore.case = TRUE)
    f.text <- gsub("THREE", "3", f.text, ignore.case = TRUE)
    f.text <- gsub("1\\s{0,}\\.", "1", f.text)
    f.text <- gsub("2\\s{0,}\\.", "2", f.text)
    f.text <- gsub("3\\s{0,}\\.", "3", f.text)
    empty.lnumbers <- grep("^\\s*$", f.text)
    if (length(empty.lnumbers) > 0) {
      f.text <- f.text[-empty.lnumbers]
    }
    item.lnumbers <- grep("^ITEM\\s{0,}\\d{0,}\\s{0,}$|^ITEM\\s{0,}1 and 2\\s{0,}$",
                          f.text, ignore.case = T)
    f.text[item.lnumbers + 1] <- paste0(f.text[item.lnumbers],
                                        " ", f.text[item.lnumbers + 1])
    startline <- grep("^Item\\s{0,}1\\s{0,}Business\\s{0,}\\.{0,1}\\s{0,}$|^Item\\s{0,}1\\s{0,}DESCRIPTION OF BUSINESS\\s{0,}\\.{0,1}\\s{0,}$",
                      f.text, ignore.case = T)
    endline <- grep("^Item\\s{0,}2\\s{0,}Properties\\s{0,}\\.{0,1}\\s{0,}$|Item\\s{0,}2\\s{0,}DESCRIPTION OF PROPERTY\\s{0,}\\.{0,1}\\s{0,}$|^Item\\s{0,}2\\s{0,}REAL ESTATE\\s{0,}\\.{0,1}\\s{0,}$",
                    f.text, ignore.case = T)
    if (length(startline) == 0 && length(endline) == 0) {
      startline <- grep("^Item\\s{0,}1 and 2\\s{1,}Business AND PROPERTIES\\s{0,}\\.{0,1}\\s{0,}$|^Item\\s{0,}1 and 2\\s{1,}Business and Description of Property\\s{0,}\\.{0,1}\\s{0,}$",
                        f.text, ignore.case = T)
      endline <- grep("^Item\\s{0,}3\\s{1,}LEGAL PROCEEDINGS\\s{0,}\\.{0,1}\\s{0,}$|^Item\\s{0,}3\\s{1,}LEGAL matters\\s{0,}\\.{0,1}\\s{0,}$",
                      f.text, ignore.case = T)
    }
    product.descr <- NA
    if (length(startline) != 0 && length(endline) != 0) {
      if (length(startline) == length(endline)) {
        for (l in 1:length(startline)) {
          product.descr[l] <- paste(f.text[startline[l]:endline[l]],
                                    collapse = " ")
        }
      }
      else {
        startline <- startline[length(startline)]
        endline <- endline[length(endline)]
        product.descr <- paste(f.text[startline:endline],
                               collapse = " ")
      }
      product.descr <- gsub("\\s{2,}", " ", product.descr)
      words.count <- stringr::str_count(product.descr,
                                        pattern = "\\S+")
      product.descr <- product.descr[which(words.count ==
                                             max(words.count))]
      product.descr <- gsub(" co\\.| inc\\.| ltd\\.| llc\\.| comp\\.",
                            " ", product.descr, ignore.case = T)
      product.descr2 <- unlist(strsplit(product.descr,
                                        "\\. "))
      product.descr2 <- paste0(product.descr2, ".")
    }
    new.dir <- paste0("Business descriptions text")
    dir.create(new.dir)
    filename2 <- paste0(new.dir, "/", cik, "_", f.type, "_",
                        date.filed, "_", accession.number, ".txt")

    OBJECT_NAME <- paste0(new.dir, "/", cik, "_", f.type, "_", date.filed, "_", accession.number, ".txt")
    BUCKET <- Sys.getenv("BUCKET_NAME")

    #put_object(product.descr2, object = OBJECT_NAME, bucket = BUCKET)

    if(exists("product.descr2")){writeLines(product.descr2, filename2)
      put_object(filename2, object = OBJECT_NAME, bucket = BUCKET)
      rm(filename2)
      gc()
    }

    rm(dest)
    gc()
    setTxtProgressBar(progress.bar, i)
  }
  output$date.filed <- as.Date(as.character(output$date.filed),
                               "%Y-%m-%d")
  close(progress.bar)
  output$quarter <- NULL
  output$filing.year <- NULL
  output$status <- NULL
  cat("Business descriptions are stored in 'Business descriptions text' directory.")
  return(output)
}

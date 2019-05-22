These files were created from: 
Wiki_Web_Pipeline_script_1 
...
Wiki_Web_Pipeline_script_7

Running the Wiki_Web_Pipeline in batches. 


NOTE: In all 7 of these scripts, 

wiki_df <- wiki_db_creator("Wikipedia_Read/Wikipedia_Data.json")

this line of code (ran on 5/21/19) only had NASDAQ data in the Wikipedia_Data. 

When Zach completes his Wikipedia scrape of NYSE and AMEX.

You can do 1 of the following: 

(1) [easier, longer, ~ 1hr for running all 7 scripts at once] 
Replace "Wikipedia_Read/Wikipedia_Data.json" with the new, more complete, wikipedia data from all of the exchanges, and re-run all 7 scripts. Then combine the 7 public_data_for_doc2vec_# files using the file_combine.R (MDAS - TECH parent directory) function to get a single object to then write to csv. 

(2) [harder, faster] 
Replace "Wikipedia_Read/Wikipedia_Data.json" with the new, more complete, wikipedia data from all of the exchanges. Run the file_combine.R on the current files (they are the files object inside the file_combine.R source). Then run the wiki_update.R function (from the MDAS - TECH parent directory). I created a script (wiki_update_script.R) that SHOULD do this whole pipeline, but I had limited testing time. 

 
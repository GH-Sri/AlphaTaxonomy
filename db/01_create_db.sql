-- Create the database
CREATE DATABASE mdas;

-- Connect to the new DB (rather than Public)
\c mdas

-- Create the schema and make it the default
CREATE SCHEMA mdas AUTHORIZATION mdas;
SET search_path TO mdas;

-- Create the table that holds the text of documents analyzed by ML
CREATE TABLE cleaned_data_agg_csv (
	"name" text NULL,
	"text" text NULL,
	"source" integer NULL
);
CREATE INDEX cleaned_data_agg_csv_name_idx ON mdas.cleaned_data_agg_csv USING btree (name);

-- Create the table that shows our analytical results relating companies to industries and sectors
CREATE TABLE company_sector_industry_csv (
	"name" text NULL,
	"source" int8 NULL,
	sector int8 NULL,
	industry int8 NULL
);
CREATE INDEX company_sector_industry_csv_name_idx ON mdas.company_sector_industry_csv USING btree (name);

-- Create the table that holds details about all publicly traded companies downloaded from the NASDAQ site
CREATE TABLE companylist_csv (
	symbol text NULL,
	"name" text NULL,
	lastsale text NULL,
	marketcap float8 NULL,
	"adr tso" text NULL,
	ipoyear text NULL,
	sector text NULL,
	industry text NULL,
	"summary quote" text NULL,
	exchange text NULL,
	cik int8 NULL
);
CREATE INDEX companylist_csv_name_idx ON mdas.companylist_csv USING btree (name);

-- Create the table that shows our analytical results of which companies are likely closest competitors
CREATE TABLE competitors_csv (
	"name" text NULL,
	"source" int8 NULL,
	"competitor name" text NULL,
	"competitor source" int8 NULL,
	similarity float8 NULL
);
CREATE INDEX competitors_csv_competitor_name_idx ON mdas.competitors_csv USING btree ("competitor name");
CREATE INDEX competitors_csv_name_idx ON mdas.competitors_csv USING btree (name);

-- Create the table which holds the stock price data for ticker symbols related to our companies
CREATE TABLE historicalstockpricedataallexchanges_csv (
	"date" text NULL,
	"open" float8 NULL,
	high float8 NULL,
	low float8 NULL,
	"close" float8 NULL,
	volume int8 NULL,
	adjusted float8 NULL,
	symbol text NULL
);
CREATE INDEX historicalstockpricedataallexchanges_csv_symbol_idx ON mdas.historicalstockpricedataallexchanges_csv USING btree (symbol);

-- Create the table which holds names for the industry clusters produced by our analysis
CREATE TABLE industry_name_csv (
	"number" int8 NULL,
	"name" text NULL
);

-- Create the table which shows how closely each company matches each of the industry clusters produced by our analysis
CREATE TABLE industry_weights_csv (
	"name" text NULL,
	"source" int8 NULL,
	industry int8 NULL,
	similarity float8 NULL
);

-- Create the table which shows what words are most closely related to each industry cluster produced by our analysis
CREATE TABLE industry_words_csv (
	industry int8 NULL,
	word text NULL,
	similarity float8 NULL
);

-- Create the table which holds names for the sector clusters produced by our analysis
CREATE TABLE sector_name_csv (
	"number" int8 NULL,
	"name" text NULL
);

-- Create the table which shows how closely each company matches each of the sector clusters produced by our analysis
CREATE TABLE sector_weights_csv (
	"name" text NULL,
	"source" int8 NULL,
	sector int8 NULL,
	similarity float8 NULL
);

-- Create the table which shows what words are most closely related to each sector cluster produced by our analysis
CREATE TABLE sector_words_csv (
	sector int8 NULL,
	word text NULL,
	similarity float8 NULL
);

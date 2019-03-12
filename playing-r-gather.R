###############################################################################
## survey data, wide to long, remove NA, write to csv, import
## run neo4j in docker with the db stored locally, but also allows imports to be 
## shared relatively with volume mapping
###############################################################################

options(stringsAsFactors = FALSE)

## load the libraries
library(neo4r)
library(ipeds)
library(tidyverse)
library(jsonlite)

# connect to the database
graph = neo4j_api$new(url = "http://localhost:7474",
                      user = "neo4j",
                      password = "password")
graph$ping()

## filepath for neo4j
NEO_PATH = "/Users/btibert/Library/Application Support/Neo4j Desktop/Application/neo4jDatabases/database-498f7f4b-eca6-432f-85da-6f4b68545626/installation-3.5.0/"

## instantiate the surveys
data("surveys")

## get the SFA dataset 1617
raw_survey = getIPEDSSurvey("SFA", "1617", stringsAsFactors = FALSE)
raw_survey$survey_year = "201617"

## write a json file
raw_survey_list = toJSON(raw_survey, dataframe = "rows")
write_json(raw_survey_list, paste0(NEO_PATH,"/import/","survey.json"))


## apoc cql to import the file -- written in browser


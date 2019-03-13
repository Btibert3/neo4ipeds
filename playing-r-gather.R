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


##### Docker Assumptions

## download the .jar files and put in the projects neo4j/plugins dir 
### will be mapped during the container build locally

## docker containser spinup -- better/easier to manage in terminal within RStudio
## docker-compose up
## or, docker-compose up -d
## docker-compose stop



# connect to the database
graph = neo4j_api$new(url = "http://localhost:7474",
                      user = "neo4j",
                      password = "password")
graph$ping()


## instantiate the surveys
data("surveys")

## get the SFA dataset 1617
raw_survey = getIPEDSSurvey("SFA", "1617", stringsAsFactors = FALSE)
raw_survey$survey_year = "201617"

## write a json file
raw_survey_list = toJSON(raw_survey, dataframe = "rows")
write_json(raw_survey_list, "neo4j/import/survey.json")

## write a test file
test_survey = toJSON(raw_survey[1,], dataframe = "rows")
write_json(test_survey, "neo4j/import/test-survey.json")


## apoc cql to import the file -- written in browser
CQL = "
WITH 'file:///test-survey.json' as url
CALL apoc.load.json(url) YIELD value
WITH value
LIMIT 1
RETURN value
"
tmp = call_neo4j(CQL, graph, type="graph")





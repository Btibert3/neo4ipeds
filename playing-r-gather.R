###############################################################################
## survey data, wide to long, remove NA, write to csv, import
###############################################################################

options(stringsAsFactors = FALSE)

## load the libraries
library(RNeo4j)
library(ipeds)
library(tidyverse)
library(jsonlite)

## connect to the database
# graph = neo4j_api$new(url = "http://localhost:7474", 
#                       user = "neo4j", 
#                       password = "password")
# graph$ping()
# 
# ## filepath for neo4j
# NEO_PATH = "/Users/btibert/Library/Application Support/Neo4j Desktop/Application/neo4jDatabases/database-498f7f4b-eca6-432f-85da-6f4b68545626/installation-3.5.0/"

## instantiate the surveys
data("surveys")

## get the SFA dataset 1617
raw_survey = getIPEDSSurvey("SFA", "1617", stringsAsFactors = FALSE)
raw_survey$survey_year = "201617"

# # wide to long and remove NAs and add year
# raw_long = raw_survey %>% 
#   gather(key=question, value=answer, -unitid, na.rm=TRUE) %>% 
#   mutate(survey_year = "201617")
# 
# ## write the dataset
# write_csv(raw_long, paste0(NEO_PATH, "/import/", "ipeds-import.csv"))
# 
# ## create the constraint for the school
# call_neo4j("CREATE CONSTRAINT ON (n:UNITID) ASSERT n.unitid IS UNIQUE;", graph)
# 
# ## import the csv
# cql = "
# MERGE (s:UNITID {unitid: row.unitid})
# CREATE (q:)
# "

# connect to neo4j from Rneo4j
graph = startGraph("http://localhost:7474/db/data/", username="neo4j", password="password")

# clear the grap
clear(graph, input=FALSE)

# create the constraint
addConstraint(graph, "UNITID", "unitid")

# data to a list
raw_survey_list = rjson::fromJSON(toJSON(raw_survey, dataframe = "rows"))
nrow(raw_survey)==length(raw_survey_list)

# function to create the data
add_answer = function(x) {
  school = getOrCreateNode(graph, "UNITID", unitid=x$unitid)
  x$unitid = NULL
  answer = createNode(graph, "SFA", x)
  createRel(school, "SUPPLIED", answer)
}

## for each entry, send to neo4j
lapply(raw_survey_list, function(x) add_answer(x))

########## really slow, but it works
## --- 
## BCPARKS/RGBIF SPATIAL DATA ACQUISITON TOOL ----------------------
## ---
library(devtools)
# dev_mode(on = T)

# load pkgs from github
remotes::install_github("ropensci/wicket@reverse")
devtools::install_github("ropensci/rinat")
update.packages("rinat")
library(wicket)
library(rinat)

# load all packages
Packages <- c("spocc", "sf", "tidyverse", "rgbif", "viridis", "rinat", 
              "maptools", "devtools", "wellknown","geojsonsf", "leaflet", 
              "jsonlite", "rgbif", "geojsonio", "bcdata", "rmapshaper", 
              "RColorBrewer", "RCurl", "bcmaps", "geojson", "wicket")
lapply(Packages, library, character.only = TRUE)

# Since this file contains data on all protected areas and parks in the province, 
# we can narrow it down to provincial parks using. 

# extracting only provincial parks
prov_parks <- dplyr::filter(parks, PROTECTED_LANDS_DESIGNATION == "PROVINCIAL PARK") %>%
  rename_all(tolower)

## ENVIRONMENT SETTINGS ----------------------------------------
## *Note: Fill in the variables below with your own username/pwd
## 
# user_renviron <- path.expand(file.path("~", ".Renviron"))
Sys.setenv(GBIF_USER = "*")
Sys.setenv(GBIF_PWD = "*")
Sys.setenv(GBIF_EMAIL = "*")
Sys.setenv(LIBCURL_BUILD="*")
install.packages('curl', type = "source")
library(curl)

## --
## LOADING DATA --------------------------------
## --
# pass in geojson file
# install.packages("remotes")
# remotes::install_github("bcgov/bcdata")
bcdc_search()
# Download BC parks data as sf
bcdc_query_geodata("1130248f-f1a3-4956-8b2e-38d29d3e4af7", crs = 4326)
parks <- bcdc_get_data(record = '1130248f-f1a3-4956-8b2e-38d29d3e4af7', 
                       resource = 'c1bf2c35-3775-4b80-aa06-aa14630132f1', 
                       crs = 4326)

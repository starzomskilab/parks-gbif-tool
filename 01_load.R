##
## BCPARKS/RGBIF SPATIAL DATA ACQUISITON TOOL ----------------------
## 
# load packages
remotes::install_github("ropensci/wicket@reverse")
Packages <- c("spocc", "sf", "tidyverse", "rgbif", "viridis", "rinat", 
              "maptools", "devtools", "wellknown","geojsonsf", "leaflet", 
              "jsonlite", "rgbif", "geojsonio", "bcdata", "rmapshaper", 
              "RColorBrewer", "RCurl", "bcmaps", "geojson", "wicket")
lapply(Packages, library, character.only = TRUE)
library(wicket)

## ENVIRONMENT SETTINGS ----------------------------------------
## *Note: Fill in the variables below with your own username/pwd
## 
# user_renviron <- path.expand(file.path("~", ".Renviron"))
Sys.setenv(GBIF_USER = "*")
Sys.setenv(GBIF_PWD = "*")
Sys.setenv(GBIF_EMAIL = "*")
Sys.setenv(LIBCURL_BUILD="winssl")
install.packages('curl', type = "source")
library(curl)

## LOADING DATA --------------------------------
## --
# pass in geojson file
# install.packages("remotes")
# remotes::install_github("bcgov/bcdata")

# Download BC parks data as sf
parks <- bcdc_get_data("1130248f-f1a3-4956-8b2e-38d29d3e4af7", crs = 4326)

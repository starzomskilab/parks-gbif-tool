##
## BCPARKS/RGBIF SPATIAL DATA ACQUISITON TOOL ----------------------
## 

# load packages
Packages <- c("spocc", "sf", "tidyverse", "rgbif", "viridis", "dplyr", 
              "maptools", "devtools", "wellknown","geojsonsf", "leaflet", 
              "jsonlite", "rgbif", "geojsonio", "bcdata", "rmapshaper", 
              "RColorBrewer", "RCurl", "bcmaps")
lapply(Packages, library, character.only = TRUE)

## ENVIRONMENT SETTINGS ----------------------------------------
## *Note: Fill in the variables below with your own username/pwd
## 
# user_renviron <- path.expand(file.path("~", ".Renviron"))
Sys.setenv(GBIF_USER = "jgalloway93")
#Sys.setenv(GBIF_PWD = ******)
Sys.setenv(GBIF_EMAIL = "jgalloway@uvic.ca")

## LOADING DATA --------------------------------
## --
# pass in geojson file
# install.packages("remotes")
# remotes::install_github("bcgov/bcdata")

# Download BC parks data as sf
parks <- bcdc_get_geodata("1130248f-f1a3-4956-8b2e-38d29d3e4af7", crs = 4326)
class(parks)
plot(st_geometry)

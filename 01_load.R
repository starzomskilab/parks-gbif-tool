## --
## BCPARKS/RGBIF SPATIAL DATA ACQUISITON TOOL
## --

## PACKAGES
Packages <- c("spocc", "sf", "tidyverse", "rgbif", "viridis", "dplyr", "maptools",
              "devtools", "wellknown","geojsonsf", "leaflet", "jsonlite",
              "geojsonio", "rgbif", "rmapshaper", "RColorBrewer", "RCurl", "bcmaps")
lapply(Packages, library, character.only = TRUE)

## --
## SETTING ENVIRONMENT 
## *Note: Fill in the variables below with your own username/pwd
## --
# user_renviron <- path.expand(file.path("~", ".Renviron"))
Sys.setenv(GBIF_USER = "jgalloway93")
#Sys.setenv(GBIF_PWD = ******)
Sys.setenv(GBIF_EMAIL = "jgalloway@uvic.ca")

## --
## GEO
## --
# pass in geojson file
parks <- st_read("TA_PARK_ECORES_PA_SVW.geojson") # one way
parks_json <- fromJSON(paste(readLines("TA_PARK_ECORES_PA_SVW.geojson"), collapse = ""))
class(parks)

# extracting only provincial parks
pp_parks <- parks[parks$PROTECTED_LANDS_DESIGNATION == "PROVINCIAL PARK",]
parks_geom <- st_geometry(pp_parks) # adding geometry column
# convert to text
parks_wkt <- st_as_text(parks_geom)
parks_wkt <- readRDS("parks_wkt") # read saved from disk

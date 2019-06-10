## 
## EXTRACT SKAHA BLUFFS -------------------------
##
skaha <- filter(parks_simp, protected_lands_name == "SKAHA BLUFFS PARK")
skaha <- st_geometry(skaha)# add geometry column
skaha <- st_cast(skaha, "POLYGON")
skaha <- ms_simplify(skaha, keep = 0.05)
skaha_wkt <- st_as_text(skaha)
skaha_wkt
skaha_wkt_simp <- geojson2wkt(unclass(wkt2geojson(skaha_wkt, feature = FALSE)), fmt = 5)
skaha_wkt_simp

# search for data within the parks boundary
skaha_search <- occ_search(geometry = skaha_wkt_simp, hasCoordinate = T)
skaha_search
parks_search <- occ_search(geometry = parks_wkt_full, hasCoordinate = T, 
                           limit = 200)
# download prep
# occ_download_prep("basisOfRecord = HUMAN OBSERVATION", format = "SIMPLE_CSV")
occ_download_queue(
  occ_download("geometry = POLYGON ((-119.5681 49.42843, -119.5575 49.43965, -119.54 49.42743, -119.5681 49.42843))"))
occ_download_meta(key = "0026779-190415153152247")
occ_download_import(key = "0026778-190415153152247")


## PLOTTING
library(lawn)
skaha_search$data %>% 
  select(name, decimalLatitude, decimalLongitude) %>% 
  rename(latitude = decimalLatitude, longitude = decimalLongitude) %>% 
  geojsonio::geojson_json() %>% 
  lawn::view()

# spocc - converting to shp
tweed_sp <- as(tweed, "Spatial")
class(tweed_sp)
tweed_poly <- Polygon(tweed_sp)

parks_gbif <- occ_download_prep("country = CA", 'basisOfRecord = OBSERVATION', 
                                "hasCoordinate = true", "hasGeospatialIssue = false")
summary(parks_gbif)

occ_count(georeferenced = T, country = "CA", basisOfRecord = 'OBSERVATION')

occ_search(scientificName = 'Ursus americanus', curlopts = list(verbose = TRUE))

## SOLUTION TO THE SIZE/MULTIPOLYGON PROBLEM --------------
# cast
tweed_poly <- st_cast(tweed_geom, "POLYGON") # convert multi to single poly
tweed_poly_single <- tweed_poly[which.max(st_area(tweed_poly))] # extract largest 
tweed_simple <- ms_simplify(tweed_poly_single, keep = 0.001) # simplify vertices
plot(tweed_simple) # plot the result 
# convert to latlong
tweed_simple <- st_transform(tweed_simple, 4326)
tweed_wkt <- st_as_text(tweed_simple) # convert to wkt

## SAMPLE DOWNLOAD FROM SCKOTT
occ_download('taxonKey = 7228682', 'hasCoordinate = TRUE', 'hasGeospatialIssue = FALSE', 
             'geometry = POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))')
occ_download_meta(key = "0026785-190415153152247")
occ_download_get("0026785-190415153152247", path = "tweed_full.zip", overwrite = T, curlopts = list())
occ_download_dataset_activity("0025301-181108115102211")

## leaflet
tweed_map <- leaflet(data_tweed2) %>% addTiles() %>% 
  addCircleMarkers(~longitude, ~latitude, popup = data_tweed, radius = 1, 
                   fill = T, colorFactor("Paired"))

# less decimals in wkt! very important
wkt_simp <- geojson2wkt(unclass(wkt2geojson(parks_wkt_full, feature = FALSE)), fmt = 5)
class(parks_wkt_full)
tweed_wkt_simp
## 
## TWEEDSMUIR-------------------------
##
# arrange
bysize <- pp_parks %>% arrange(desc(FEATURE_AREA_SQM))

# extracting tweedsmuir 
tweed <- pp_parks[pp_parks$ADMIN_AREA_SID == "1188",]
class(tweed)
tweed_geom <- st_geometry(tweed) # add geometry column
tweed_wkt <- st_as_text(tweed_geom)
class(tweed_geom)
plot(tweed_geom)

# spocc - converting to shp
tweed_sp <- as(tweed, "Spatial")
class(tweed_sp)
tweed_poly <- Polygon(tweed_sp)

# attempting to get data from gbif
species <- occ(geometry = tweed_poly, from = "gbif", limit = 1000)
species$gbif
parks_gbif <- occ_download_prep("country = CA", 'basisOfRecord = OBSERVATION', 
                                "hasCoordinate = true", "hasGeospatialIssue = false")
summary(parks_gbif)

occ_count(georeferenced = T, country = "CA", basisOfRecord = 'OBSERVATION')
parks_data <- occ_download("country = CA", 'basisOfRecord = OBSERVATION', 
                           "hasCoordinate = true", "hasGeospatialIssue = false")



occ_search(scientificName = 'Ursus americanus', curlopts = list(verbose = TRUE))

polysample <- "POLYGON((-128 48,-121 48,-121 53,-128 53,-128 48))"
plot(polysample)

## SOLUTION TO THE SIZE/MULTIPOLYGON PROBLEM --------------
# cast
tweed_poly <- st_cast(tweed_geom, "POLYGON") # convert multi to single poly
tweed_poly_single <- tweed_poly[which.max(st_area(tweed_poly))] # extract largest 
tweed_simple <- ms_simplify(tweed_poly_single, keep = 0.001) # simplify vertices
plot(tweed_simple) # plot the result 
# convert to latlong
tweed_simple <- st_transform(tweed_simple, 4326)
tweed_wkt <- st_as_text(tweed_simple) # convert to wkt

# search for data within the parks boundary
class(tweed_wkt)
res <- occ_search(geometry = tweed_wkt, hasCoordinate = T)
data_tweed <- occ_search(geometry = tweed_wkt, hasCoordinate = T, limit = 4000)
data_tweed2 <- occ_data(geometry = tweed_wkt, hasCoordinate = T, limit = 4000)

## PLOTTING
data_tweed$data %>% 
  select(name, decimalLatitude, decimalLongitude) %>% 
  rename(latitude = decimalLatitude, longitude = decimalLongitude) %>% 
  geojsonio::geojson_json() %>% 
  lawn::view()

## SAMPLE DOWNLOAD FROM SCKOTT
occ_download('taxonKey = 7228682', 'hasCoordinate = TRUE', 'hasGeospatialIssue = FALSE', 
             'geometry = POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))')

# working download request
tweed_full <- occ_download('geometry = POLYGON ((-126.61890 52.82582, -126.61470 52.99063, 
                           -126.79130 53.00253, -126.83990 53.10636, -126.99290 53.15149, 
                           -127.06030 53.29415, -127.25340 53.26204, -127.30520 53.33956, 
                           -127.21260 53.39549, -127.04150 53.39694, -126.96750 53.47152, 
                           -126.77870 53.53582, -126.70590 53.66283, -126.48070 53.80835, 
                           -126.35340 53.81418, -126.08430 53.75325, -126.08320 53.24568, 
                           -126.01170 53.20708, -125.77080 53.20707, -125.77370 52.85126, 
                           -125.64010 52.73904, -125.63980 52.64575, -125.72770 52.56943, 
                           -125.73020 52.42860, -125.61620 52.31243, -125.64810 52.12862, 
                           -125.58810 51.89234, -125.91530 51.89921, -125.92420 52.10753, 
                           -126.06350 52.34376, -126.44870 52.64625, -126.35080 52.70379, 
                           -126.34260 52.82858, -126.51460 52.77071, -126.61890 52.82582))', 
                           'hasCoordinate = TRUE')
tweed_full # view

occ_download_get("0025301-181108115102211", path = "tweed_full.zip", overwrite = T, curlopts = list())
occ_download_dataset_activity("0025301-181108115102211")

## leaflet
tweed_map <- leaflet(data_tweed2) %>% addTiles() %>% 
  addCircleMarkers(~longitude, ~latitude, popup = data_tweed, radius = 1, 
                   fill = T, colorFactor("Paired"))

# less decimals in wkt! very important
tweed_wkt_simp <- geojson2wkt(unclass(wkt2geojson(tweed_wkt, feature = FALSE)), fmt = 5)
tweed_wkt_simp

## 
## EXTRACT SKAHA BLUFFS -------------------------
##
skaha <- filter(parks_simp, protected_lands_name == "SKAHA BLUFFS PARK")
skaha <- st_geometry(skaha)# add geometry column
skaha <- st_cast(skaha, "POLYGON")
skaha_wkt <- st_as_text(skaha)
skaha_wkt_simp <- geojson2wkt(unclass(wkt2geojson(skaha_wkt, feature = FALSE)), fmt = 5)
skaha_wkt_simp

# search for data within the parks boundary
skaha_search <- occ_search(geometry = skaha_wkt_simp, hasCoordinate = T)
parks_search <- occ_search(geometry = parks_wkt_full, hasCoordinate = T, 
                           limit = 200)
skaha_wkt_simp
# download
skaha_dl <- occ_download("geometry = POLYGON ((-119.56810 49.42843, -119.56800 49.43797, -119.56820 49.44625, 
                         -119.55760 49.44621, -119.55730 49.46060, -119.54890 49.46054, -119.54970 49.45899, 
                         -119.55010 49.45717, -119.54990 49.45651, -119.55040 49.45577, -119.55020 49.45465, 
                         -119.55090 49.45287, -119.55200 49.45152, -119.55320 49.44921, -119.55450 49.44615, 
                         -119.55470 49.44305, -119.55540 49.44275, -119.55580 49.44161, -119.55750 49.43965, 
                         -119.55810 49.43738, -119.55860 49.43539, -119.55830 49.43446, -119.55130 49.43453, 
                         -119.55130 49.43815, -119.54580 49.43820, -119.54590 49.44185, -119.52370 49.44206, 
                         -119.52350 49.43482, -119.54020 49.43467, -119.54000 49.42743, -119.56810 49.42715, 
                         -119.56810 49.42843))", "hasCoordinate = true")
occ_download_import(key = "0026762-190415153152247")
occ_download_meta(key = "0026762-190415153152247")

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
wkt_simp <- geojson2wkt(unclass(wkt2geojson(parks_wkt_full, feature = FALSE)), fmt = 5)
class(parks_wkt_full)
tweed_wkt_simp
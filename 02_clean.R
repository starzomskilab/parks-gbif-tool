## --
## DATA PREP AND CLEANING
## --
# extracting only provincial parks
pp_parks <- parks[parks$PROTECTED_LANDS_DESIGNATION == "PROVINCIAL PARK",]
class(pp_parks)
parks_geom <- st_geometry(pp_parks) # adding geometry column

# convert to text
parks_wkt <- st_as_text(parks_geom)
#saveRDS(parks_wkt, file = "parks-wkt")
#parks_wkt <- readRDS("parks_wkt") # read saved from disk

# arrange
bysize <- pp_parks %>% arrange(desc(FEATURE_AREA_SQM))

# extracting tweedsmuir 
tweed <- pp_parks[pp_parks$ADMIN_AREA_SID == "1188",]
class(tweed)
tweed_geom <- st_geometry(tweed) # add geometry column
tweed_wkt <- st_as_text(tweed_geom)
class(tweed_geom)
plot(tweed_geom)

####################################
# OTHER FORMATS
####################################
# convert to spatial df
parks_sp <- as(pp_parks, "Spatial")
glimpse(parks_sp)
glimpse(parks)
as_tibble(parks)

# converting to geojson and wkt
# to geojson; clipped the sf earlier, so want to keep it
geo_parks <- sf_geojson(pp_parks) 
parks_wkt <- geojson2wkt(geo_parks) # wkt - won't work - no class (multipolygon?)
class(pp_parks)
summary(geo_parks)

# chloropleth
leaflet(parks_sp) %>%
  addTiles() %>%
  addPolygons(color = "#3333333", weight = 1, smoothFactor = 0.5)

# plot
ggplot(pp_parks) +
  geom_sf(aes(fill = FEATURE_AREA_SQM)) +
  theme_dark()

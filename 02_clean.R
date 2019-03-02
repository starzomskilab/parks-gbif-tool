##
## DATA PREP AND CLEANING ---------------------------
## 
# extracting only provincial parks
prov_parks <- filter(parks, PROTECTED_LANDS_DESIGNATION == "PROVINCIAL PARK")

# add geometry column
prov_parks <- st_geometry(prov_parks)

# simplify parks geometry
parks_geom <- ms_simplify(prov_parks)
plot(parks_geom)

# convert to text
parks_wkt <- st_as_text(parks_geom)
# saveRDS(parks_wkt, file = "parks-wkt")
# parks_wkt <- readRDS("parks_wkt") # read saved from disk

## OTHER FORMATS -------------------------------------------
##
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
leaflet(parks_simplified) %>%
  addTiles() %>%
  addPolygons(color = "#3333333", weight = 1, smoothFactor = 0.5)

# plot
ggplot(pp_parks) +
  geom_sf(aes(fill = FEATURE_AREA_SQM)) +
  theme_dark()

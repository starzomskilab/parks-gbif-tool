## ---
## DATA PREP AND CLEANING ---------------------------
## ---
# extracting only provincial parks
prov_parks <- filter(parks, PROTECTED_LANDS_DESIGNATION == "PROVINCIAL PARK") %>%
  rename_all(tolower)

# simplify parks geometry
parks_simp <- ms_simplify(prov_parks, keep = 0.05)
plot(parks_simp[15])

# create list of parks
park_names <- unique(prov_parks$protected_lands_name)

# create list to store wkts
park_wkts <- vector(length = length(park_names), mode = "list")
names(park_wkts) <- park_names

make_park_wkt <- function(data, name) {
  # create wkt for single park
  parkwkt <- st_as_text(data)
  parkwkt <- wkt_reverse(parkwkt)
}

park_wkts <- map(park_names, ~ {
  data <- filter(parks_simp, protected_lands_name == .x)
  data <- st_geometry(data)
  data <- st_cast(data, "POLYGON")
  # data <- st_area(which.max(data))
  make_park_wkt(data)
})

names(park_wkts) <- park_names
# saveRDS(parks_wkt, file = "parks-wkt")
# parks_wkt <- readRDS("parks_wkt") # read saved from disk

park_wkts["SKAHA BLUFFS PARK"]
skaha <- filter(parks_simp, protected_lands_name == "SKAHA BLUFFS PARK")
skaha <- st_as_text(skaha)

beaton <- park_wkts["BEATTON RIVER PARK"]

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

## ---
## queue up download
queries <- list()
for (i in seq_along(park_wkts)) {
  queries[[i]] <- occ_download_prep(
    "type = equals",
    "hasCoordinate = true",
    "hasGeospatialIssue = false",
    paste0("geometry = ", park_wkts[i])
  )
}

# launch download cue
out <- occ_download_queue(.list = queries, status_ping = 10)
out

# extract from parks wkt
discisland <- park_wkts[[1]]
class(discisland)
library(wellknown)
discisland <- polygon(discisland)

# download for discovery island
occ_download("geometry = discisland", "hasCoordinate = true")

# full wkt download
full_download <- occ_download_queue(
  occ_download("geometry = parks_wkt_full", "hasGeometry = true")
)
full_download
occ_download("geometry = parks_wkt_full", "hasGeometry = true")

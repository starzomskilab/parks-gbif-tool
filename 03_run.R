## ---
## queue up download
queries <- list()
for (i in seq_along(park_wkts)) {
  queries[[i]] <- occ_download_prep(
    "hasCoordinate = true",
    "hasGeospatialIssue = false",
    "geometry = parks_wkts",
    paste0("geometry = ", park_wkts[i])
  )
}

out <- occ_download_queue(geometry = parks_wkt)
occ_download_get()

## ---
##  ----------------------------------------------------------
## ---

# Queue up download
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

# full wkt download
full_download <- occ_download_queue(
  occ_download("geometry = parks_wkt_full", "hasGeometry = true")
)
full_download
occ_download("geometry = parks_wkt_full", "hasGeometry = true")

beaton <- occ_download("geometry = POLYGON((-120.349 56.1015,-120.376 56.1015,-120.375 56.1089,-120.378 56.1089,-120.378 56.1072,-120.379 56.1035,-120.395 56.1035,-120.395 56.1017,-120.401 56.1017,-120.401 56.0986,-120.391 56.0981,-120.377 56.0964,-120.365 56.0961,-120.36 56.0965,-120.349 56.0984,-120.349 56.1015))", "hasGeometry = true")
beaton_search <- occ_search(geometry = "POLYGON((-120.349 56.1015,-120.376 56.1015,-120.375 56.1089,-120.378 56.1089,-120.378 56.1072,-120.379 56.1035,-120.395 56.1035,-120.395 56.1017,-120.401 56.1017,-120.401 56.0986,-120.391 56.0981,-120.377 56.0964,-120.365 56.0961,-120.36 56.0965,-120.349 56.0984,-120.349 56.1015))", hasGeospatialIssue = F)

## ---
## queue up download
queries <- list()
for (i in seq_along(park_wkts)) {
  queries[[i]] <- occ_download_prep(
    "hasCoordinate = true",
    "hasGeospatialIssue = false",
    paste0("geometry = ", park_wkts[i])
  )
}

queries[1]
# launch download cue
out <- occ_download_queue(.list = queries)
out

# extract from parks wkt
discisland <- park_wkts[[1]]
discisland <- toString(discisland)
class(discisland)
library(wellknown)
discisland <- polygon(discisland)

# download for discovery island
occ_download("geometry = discisland", "hasCoordinate = true")

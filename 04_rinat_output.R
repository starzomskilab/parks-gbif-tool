## ---
## Using rinat ----------------------------------------------------------------
## ---
## Retrieve info about a project
strathcona_search <- get_inat_obs_project("strathcona-provincial-park", 
                                   type = "info", raw = F)

## Now retrieve all the observations for that project
strathcona_data <- get_inat_obs_project(strathcona_search$id, type = "observations", 
                                   raw = T)
strathcona_data <- apply(strathcona_data,2,as.character)

# Write csv
write.csv(strathcona_data, file = "strathcona.csv", row.names = F)

# Trying to do the same as above for umbrella projects 
allparks <- get_inat_obs_project("bc-parks", type = "info", raw = T)
# allparks <- get_inat_obs_project(allparks$id)

## Find user
starzom <- get_inat_obs_user("bstarzomski", maxresults = 15)
glimpse(starzom)
starzom

# Add bounding box for BC (ymin xmin ymax xmax)
bbox <- c(48.41931, -130.1369, 55.33395, -122.6331 )
# Add a query 
query <- get_inat_obs(query = "fox", bounds = bbox, maxresults = 100)

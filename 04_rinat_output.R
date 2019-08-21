##
## Using rinat
## Retrieve info about a project
strathcona <- get_inat_obs_project("strathcona-provincial-park", type = "info", 
                                  raw = F)

## Now retrieve all the observations for that project
strathcona <- get_inat_obs_project(strathcona$id, 
                                 type = "observations", raw = F)

## Find user
starzom <- get_inat_obs_user("bstarzomski", maxresults = 15)
glimpse(starzom)
starzom

# Add bounding box for BC (ymin xmin ymax xmax)
bbox <- c(48.41931, -130.1369, 55.33395, -122.6331 )
# Add a query 
query <- get_inat_obs(query = "fox", bounds = bbox, maxresults = 100)

require(sp)
require(rgdal)
require(maps)

# This script takes crash data from NYC and creates a file which lists various administrative boundries
# in which the crash occured
#script is based on tutorial here: https://www.nceas.ucsb.edu/scicomp/usecases/point-in-polygon

#function to drop na values from selected columns
dropNA <- function(data, desiredCols) {
  completeVec <- complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}

setwd("C:\\Users\\Paul\\Desktop\\crashes")

# read in crash data, and turn it into a SpatialPointsDataFrame
crashes <- read.csv("NYPD_Motor_Vehicle_Collisions.csv")
crashes <- dropNA(crashes, c("LONGITUDE", "LATITUDE"))
coordinates(crashes) <- c("LONGITUDE", "LATITUDE")

# read in census tract polygons
tracts <- readOGR(".", "nyc")
council <- readOGR(".", "council")

# tell R that crash coordinates are in the same lat/lon reference system
# as the census tract data
proj4string(crashes) <- proj4string(tracts)
proj4string(crashes) <- proj4string(council)

# combine is.na() with over() to do the containment test; note that we
# need to "demote" crashes to a SpatialPolygons object first
inside.tracts <- !is.na(over(crashes, as(tracts, "SpatialPolygons")))
inside.council <- !is.na(over(crashes, as(council, "SpatialPolygons"))) 


# what fraction of sightings were inside a census tract?
mean(inside.tracts)
mean(inside.council)

# use 'over' again, this time with parks as a SpatialPolygonsDataFrame
# object, to determine which tract (if any) contains each crash, and
# store the tract name as an attribute of the crash data
crashes$tract <- over(crashes, tracts)$boro_ct_20


# write the augmented crash dataset to CSV
write.csv(crashes, "crashes-by-tract.csv", row.names=FALSE)

# ...or create a shapefile from the points
writeOGR(crashes, ".", "crashes-by-tract", driver="ESRI Shapefile")
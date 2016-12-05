setwd("C://Users//Paul//Desktop//geocoded")

require(sp)
require(rgdal)


# This script takes crash data from NYC and creates a file which lists various administrative boundries
# in which the crash occured
#script is based on tutorial here: https://www.nceas.ucsb.edu/scicomp/usecases/point-in-polygon

#function to drop na values from selected columns
dropNA <- function(data, desiredCols) {
  completeVec <- complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}

# read in injury data, and turn it into a SpatialPointsDataFrame. Limit Analysis to 2013 for comparison 
death <- read.csv("C:\\Users\\Paul\\Desktop\\crashes\\death_2013.csv")
death <- dropNA(death, c("LONGITUDE", "LATITUDE"))
coordinates(death) <- c("LONGITUDE", "LATITUDE")

# read in census tract polygons
police <- readOGR(dsn=path.expand("C:\\Users\\Paul\\Desktop\\crashes\\summary_police_precincts"), layer="summary_police_precincts")

# tell R that crash coordinates are in the same lat/lon reference system
# as the census tract data
proj4string(death) <- proj4string(police)

# combine is.na() with over() to do the containment test; note that we
# need to "demote" crashes to a SpatialPolygons object first
inside.police <- !is.na(over(death, as(police, "SpatialPolygons")))


# what fraction of sightings were inside a census tract?
mean(inside.police)

# use 'over' again, this time with parks as a SpatialPolygonsDataFrame
# object, to determine which tract (if any) contains each crash, and
# store the tract name as an attribute of the crash data
death$Precinct <- over(death, police)$Precinct

#sum point counts to admin unit
death_count <- data.frame(table(death$Precinct))
colnames(death_count) <- c("Precinct", "Count")

# write the augmented crash dataset to CSV
write.csv(death, "death-by-precinct.csv", row.names=FALSE)

#write aggregated version to CSV
write.csv(death_count, "death-aggregated-precinct.csv", row.names=FALSE)

# ...or create a shapefile from the points
writeOGR(death, ".", "death-by-precinct", driver="ESRI Shapefile")
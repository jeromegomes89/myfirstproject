rm(list = ls())

.libPaths("D:/R/library")
.libPaths()
install.packages("geosphere")
library(geosphere)

distGeo(c(88.411728,22.558001),c(88.424536,22.578219))
distHaversine(c(88.411728,22.558001),c(88.424536,22.578219))
distCosine(c(88.411728,22.558001),c(88.424536,22.578219))
distVincentySphere(c(88.411728,22.558001),c(88.424536,22.578219))
distVincentyEllipsoid(c(88.411728,22.558001),c(88.424536,22.578219))
distMeeus(c(88.411728,22.558001),c(88.424536,22.578219))



#### distGeo & distVincentyEllipsoid are same
#### distHaversine & distCosine & distVincentySphere are same
#### distCosine is close to google distance

# Impoting JC Lat Lon
JC <- read.csv(file.choose(),header = TRUE)
JC$Address_Google <- NULL
xy <- cbind(JC$lon,JC$lat)
distm(xy) # gives distance matrix
xy[1,]

ParkStreetJC <- c(88.37133,22.54352)
min(distCosine(yz,ParkStreetJC))
max(distCosine(yz,ParkStreetJC))

# Impoting eNB Lat Lon
eNB <- read.csv(file.choose(),header = TRUE)
eNB$City <- NULL
yz <- cbind(eNB$Lon,eNB$Lat)

df1<- data.frame(eNB$Sap.ID,distCosine(yz,xy[1,]))
names(df1) <- c("eNBID","Distance")
min(df1$Distance)
Final <- data.frame(JC[1,],df1[which.min(df1$Distance),])

df2<- data.frame(eNB$Sap.ID,distCosine(yz,xy[2,]))
names(df2) <- c("eNBID","Distance")
min(df2$Distance)

Final <- rbind(Final,data.frame(JC[2,],df2[which.min(df1$Distance),]))

rm(Final2)

Final1 <- c()
for (r in 1:nrow(xy)) {
  print()
}


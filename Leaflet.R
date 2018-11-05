rm(list = ls())

install.packages("leaflet")
install.packages("ggmap")
library(leaflet)
library(ggmap)

# Create a leaflet map with default map tile using addTiles()
leaflet() %>%
  addTiles() #The leaflet packages comes with 100+ provider tiles

# The names of these tiles are stored in a list named providers
providers
names(providers)
names(providers)[1:5]
names(providers)[str_detect(names(providers), "OpenStreetMap")] #string r pacakage

# Replace addTiles() with addProviderTiles() to change your basemap
m <- leaflet() %>% setView(lng = -71.0589, lat = 42.3601, zoom = 12)
leaflet() %>% 
  addProviderTiles(provider = "CartoDB")

leaflet() %>% 
  addProviderTiles("Esri")

leaflet() %>% 
  addProviderTiles("CartoDB.PositronNoLabels")

m %>% addProviderTiles(providers$Stamen.Toner)

m %>% addProviderTiles(providers$CartoDB.Positron)

m %>% addProviderTiles(providers$Esri.NatGeoWorldMap)

# Combining Tile Layers
m %>% addProviderTiles(providers$MtbMap) %>%
  addProviderTiles(providers$Stamen.TonerLines,
                   options = providerTileOptions(opacity = 0.35)) %>%
  addProviderTiles(providers$Stamen.TonerLabels)



# Get the coordinates of a particular place
geocode("350 5th Ave, New York, NY 10118") #Returns the latitude and longitude of an address or a place name
geocode("350 5th Ave, New York, NY 10118", 
        output = c("latlon", "latlona", "more", "all"),
        source = c("google", "dsk"))

# Setting the Default Map View
setView() #allows you to set the view based on the center of your point
leaflet() %>% 
  addTiles() %>% 
  setView(lng = -73.98575, 
          lat = 40.74856, 
          zoom = 13)

fitBounds() #allows to set the view based on a rectangle
leaflet() %>% 
  addTiles() %>% 
  fitBounds(
    lng1 = -73.910, lat1 = 40.773, 
    lng2 = -74.060, lat2 = 40.723)

# Restricting the View of map
leafletOptions
leaflet(options = 
          leafletOptions(dragging = FALSE, #disables dragging of the map
                         minZoom = 14, # limits the zoom in/out level
                         maxZoom = 18))  %>% 
  addProviderTiles("Esri")  %>% 
  setView(lng = -73.98575, lat = 40.74856, zoom = 18)

leaflet()  %>% 
  addTiles()  %>% 
  setView(lng = -73.98575, lat = 40.74856, zoom = 18) %>% 
  setMaxBounds(lng1 = -73.98575, 
               lat1 = 40.74856, 
               lng2 = -73.98575, 
               lat2 = 40.74856) # restricting users to go beyond these cordinates


# Markers
## Icon Markers



JCs <- read.csv(choose.files(), header = TRUE)

m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=JCs$lon, lat=JCs$lat, popup=JCs$Jio_Center)
m  # Print the map

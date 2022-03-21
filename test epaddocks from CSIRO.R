# read epaddocks sample data from csiro
# https://agdatashop.csiro.au/epaddock-australian-paddock-boundaries

library(tidyverse)
library(sf)
library(ggmap)

## read and plot layer

epaddocks <- st_read("eppadocks_sample.shp")

ggplot(epaddocks)+
  geom_sf()

## to add googlemaps underlay

# Assuming you have API key for goole maps set up. Ask Mark for his for low volume or testing.
# Sys.setenv("MAPS_KEY" = "your google maps api key goes here") # once per computer
# register_google(Sys.getenv("MAPS_KEY"), write = TRUE) # once per computer I think

#get boundingbox and convert to WGS format with format "get_map" requires

bbox_native <- st_as_sfc(st_bbox(epaddocks))

bbox_wgs84_sf <- st_transform(bbox_native, 4326)

bbox_wgs84 <- st_bbox(bbox_wgs84_sf)

names(bbox_wgs84) <- c("left", "bottom", "right", "top")

#get map - you may need to experiment with zoom - whole numbers only, look at url on googlemaps website for guidance
paddock_map <- get_map(location = bbox_wgs84, zoom = 11, maptype = "hybrid")

epaddocks_wgs84_sf <- st_transform(epaddocks, 4326)

ggplot(epaddocks_wgs84_sf)+
  geom_sf()

ggmap(paddock_map)

p <- ggmap(paddock_map)+
  geom_sf(data = epaddocks_wgs84_sf, inherit.aes = FALSE, color=alpha("red",0.2), fill=NA)+
  xlab("Longitude")+
  ylab("Latitude")
p

ggsave("paddock_map.png", p, height = 7, width = 7)

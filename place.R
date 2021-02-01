library(tidyverse)
library(tidytext)
library(tidygeocoder)
library(ggmap)
library(maps)
library(mapdata)
library(ggrepel)

places <- filter(lincsOCR, TYPE == "PLACE")
placesCount <- group_by(places, QUOTE_TRANSCRIPTION) %>% count(QUOTE_TRANSCRIPTION, sort = TRUE)


placesCount<- placesCount %>% mutate(country = "United Kingdom") %>% mutate(county = "Lincolnshire") %>% rename(city = QUOTE_TRANSCRIPTION)

inquestGeo <- placesCount %>% geocode(city = city, county = county, country = country, method = 'osm')

write.csv(inquestGeo, file = "inquestGeo.csv")


full_results = TRUE, 
custom_query= list(extratags = 1)
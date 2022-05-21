library(tidyverse)
library(sf)
sf_use_s2(F)
library(palmer)

cds <- st_read("cd_hex.geojson")
states <- st_read("state_hex.geojson")
labs <- st_read("state_hex_label.geojson")

ggplot() + geom_sf(data=cds, color="white", lwd=.1, fill=mcols$orange200) +
  geom_sf(data=states, fill=NA, color=mcols$orange600) +
  geom_sf_text(data=labs, aes(label=state), size=1.5, family="Arial Narrow") +
  theme_void()

ggsave("img/map1.png")

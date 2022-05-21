library(tidyverse)
library(sf)
sf_use_s2(F)
library(palmer)

sfc = st_sfc(st_polygon(list(rbind(c(0,0), c(3.5,0), c(5,3.5), c(0,0)))))
x <- st_make_grid(sfc, cellsize = .1, square = FALSE) %>% st_as_sf() %>%
  rename(geometry=x) %>%
  mutate(x=round(st_coordinates(st_centroid(geometry))[,1], 2),
         y=-round(st_coordinates(st_centroid(geometry))[,2], 2)) %>%
  arrange(y, x) %>%
  mutate(id=row_number())
#qmap(x) + geom_sf_text(aes(label=id), size=1)

states <- readxl::read_xlsx("data/hex_map_cds.xlsx") %>%
  select(id, state) %>% filter(!is.na(state), !str_detect(state, "x")) %>%
  left_join(x) %>% st_as_sf()

state.bounds <- states %>% group_by(state) %>% summarize(geometry=st_union(geometry))

labs <- readxl::read_xlsx("data/hex_map_cds.xlsx") %>%
  select(id, state) %>% filter(!is.na(state), str_detect(state, "x")) %>%
  mutate(state=str_replace(state, "x", "") %>% str_to_upper()) %>% left_join(x) %>%
           st_as_sf()

ggplot() + geom_sf(data=states, color="gray80", lwd=.1, fill="gray90") +
  geom_sf(data=state.bounds, fill=NA, color="gray50") +
  #geom_sf(data=x, fill=NA, color="gray80", lwd=.1) +
  geom_sf_text(data=labs, aes(label=state), size=1.5) +
  theme_void()

cd_hex <- states %>% arrange(id) %>%
  group_by(state) %>% mutate(cd=row_number()) %>%
  ungroup() %>% select(state, cd, geometry)

state_hex <- state.bounds %>% select(state, geometry) %>%
  arrange(state) %>%
  ungroup()

cd_hex_label <- labs %>% select(state, geometry) %>% st_centroid() %>%
  arrange(state) %>% ungroup()

st_write(cd_hex, "cd_hex.geojson", delete_dsn = T)
st_write(state_hex, "state_hex.geojson", delete_dsn = T)
st_write(cd_hex_label, "state_hex_label.geojson", delete_dsn = T)


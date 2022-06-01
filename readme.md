# Hex Map for 2020 Congressional Apportionment

These files can be used to create hex maps where each congressional district is one hexagon, grouped by state.

- `cd_hex.geojson`: Contains 435 hexagons, one for each district.
- `state_hex.geojson`: Union of `cd_hex` by state, for state outlines or state maps.
- `state_hex_label.geojson`: Labels adjacent to each state polygon.

```
ggplot() + geom_sf(data=cds, lwd=.1) +
  geom_sf(data=states, fill=NA) +
  geom_sf_text(data=labs, aes(label=state), size=1.5) +
  theme_void()
```

![Example map.](img/map1.png)

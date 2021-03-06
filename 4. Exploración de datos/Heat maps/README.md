# Heat map

![Mapa](https://user-images.githubusercontent.com/71915068/107167178-c745c900-697d-11eb-81a2-ac09cd465e3d.PNG)


Se cargan las librerias 
```R
origen <- cdmx.rutas[,c("pickup_longitude","pickup_latitude")]
head(origen)# Librerias utilizadas
library(sf)                                 # Leer información geográfica
library(leaflet)                            # Hacer mapas interactivos
library(tidyverse)        
library(knitr)

#opts_chunk$set(fig.width=10, fig.height=8)
```
Cargamos la información de la base de datos y tambien cargamos la infotmación geoestadistica de la CDMX 
```R
## Leemos informacion 

# Mapa de municipios de la CDMX
mapa_municipios <- st_read("https://github.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/raw/master/Zona%20Metropolitana/EdosZM.geojson", quiet = T) %>% 
  filter(CVE_ENT == "09")

# Mapa de la entidad de la Ciudad de México
mapa_cdmx <- st_read("https://github.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/raw/master/Zona%20Metropolitana/EstadosZMVM.geojson", quiet = T)[3,]

# Cargamos la base de datos
cdmx.rutas <- read.csv("cdmx_transporte_clean3.csv")

```

Se alamcenan las lat/lng de la base de datos cada viaje 
```R

# Origen
origen <- cdmx.rutas[,c("pickup_longitude","pickup_latitude")]
head(origen)


### Destino
destino <- cdmx.rutas[,c("dropoff_longitude","dropoff_latitude")]
head(destino)

municipios <- data.frame(mapa_municipios$NOM_MUN)
lngt <- c(-99.17056, -99.16120, -99.27363,-99.08454,-99.06428,-99.03964,-99.26533,-99.02382,-99.21019,-99.00328,
        -99.21259,-99.11449,-99.18097,-99.16453,-99.17956,-99.09987	)
lati <- c(19.47045, 19.33647,19.32747,19.46471,19.38963,19.37620, 19.30002,19.19283,19.38190,19.23393,19.29782,
        19.26594,19.37043, 19.41097,19.43869,19.41256	)


municipios$lngt <- lngt
municipios$lati <- lati

```

Visualización de los viajes en la CMDX
```R
(map <- leaflet(mapaFactor, options = leafletOptions(zoomControl = FALSE, minZoom = 10)) %>%
    addProviderTiles("CartoDB.Positron") %>% 
    setMaxBounds(lng1 = -99.507504, lat1 = 18.980224, lng2 = -98.722426, lat2 = 19.60) %>%
    addPolygons(data = mapa_municipios, 
                color = "#444444",
                weight = 2, 
                opacity = 0.4,
                fill = F,
                label = ~as.character(NOM_MUN)) %>%
    addPolygons(data = mapa_cdmx, 
                color = "#444444",
                weight = 4, 
                opacity = 1,
                fill = F
    )) %>% addCircleMarkers(lng=origen[1:5500,1], lat=origen[1:5500,2], radius = .2, opacity = 0.05) %>%
  addCircleMarkers(lng=destino[1:5500,1], lat=destino[1:5500,2], radius = .2, color = "#ff325b", opacity = 0.02) %>%
  addPopups(lng=municipios$lngt, lat=municipios$lati, municipios$mapa_municipios.NOM_MUN,options = popupOptions(
  closeButton = FALSE),options(popupOptions(maxHeight = 3)))
```
Mapa CDMX
![Mapa](https://user-images.githubusercontent.com/71915068/107170028-eb58d880-6984-11eb-858e-b66d3a9c36c4.PNG)

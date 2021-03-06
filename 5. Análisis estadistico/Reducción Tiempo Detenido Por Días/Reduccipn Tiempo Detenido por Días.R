# Proyecto de R BEDU --- Equipo 12
# Prueba Estad�stica de la reducci�n del promedio de tiempo detenido en fin de semana

# Librer�as utilizadas
library(dplyr)
library(xts)
library(ggplot2)

# Preparaci�n de los datos
data <- read.csv("../../1. Bases de datos/Viajes/cdmx_transporte_clean3.csv")
data <- mutate(data, date = as.Date(pickup_date, "%d/%m/%Y"))
data <- filter(data, wait_sec <= 3600)
data <- select(data,date,wait_sec)
names(data)

# Se agrega una columna especificando que d�a es
data <- mutate(data, day = format(date,"%A"))
unique(data$day)

# funci�n para agrupar "day" en Entre semana (ES) y Fin de semana (FS)
fs <- c("s�bado","domingo")
fun <- function(x,namestc,name1,name2)
{
  y = c()
  for (i in 1:length(x))
  {
    if (x[i] %in% namestc)
    {
      y[i] <- name1
    }
    else
    {
      y[i] <- name2
    }
  }
  y
}

data <- mutate(data, day_week = fun(day,fs,"Fin de Semana","Entre Semana"))
fsData <- filter(data, day_week == "Fin de Semana")$wait_sec
esData <- filter(data, day_week == "Entre Semana")$wait_sec

(nFS <- length(fsData))
(nES <- length(esData))

(mFS <- mean(fsData))
(mES <- mean(esData))

(vFS <- var(fsData))
(vES <- var(esData))

# H_0: mES-mFS = 0
# H_1: mES-mFS > 0 (El promedio en ES es mayor que en FS)


(Z = (mES-mFS)/sqrt((vES/nES)+(vFS/nFS)))
(Z.05 = qnorm(p=0.05, lower.tail = FALSE))
(Z>=Z.05)
# Se rechaza H_0

# Se obtendr� el porcentaje de reducci�n
dif = mES-mFS
por <- dif/mES
por
# La refucci�n fue de un 8%



graf <- data %>% group_by(day_week) %>% summarise(time = mean(wait_sec))
graf
ggplot(data=graf, aes(x=day_week, y=time, fill = day_week))+
  geom_bar(stat = 'identity')+
  labs (title = "Tiempo detenido promedio",
        x = "",
        y = "Tiempo en segundos")+
  theme_minimal()

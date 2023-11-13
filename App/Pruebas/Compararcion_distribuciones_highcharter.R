

# Carga las librerías necesarias
library(dplyr)

# Generar el primer set de datos
set.seed(123) # Para reproducibilidad
df1 <- data.frame(
  id = 1:500,
  Monto1 = rnorm(500, mean = 1200, sd = 200)
)

# Generar el segundo set de datos
df2 <- data.frame(
  id = 1:1000,
  Monto2 = rnorm(1000, mean = 1000, sd = 200)
)

# Histograma
hist_df1 <- hist(df1$Monto1, plot = FALSE)
hist_df2 <- hist(df2$Monto2, plot = FALSE)

# Densidad
dens_df1 <- density(df1$Monto1)
dens_df2 <- density(df2$Monto2)

#################
#   Histograma
#################

# Cargar highcharter
library(highcharter)

# Preparación de datos para el histograma
hist_data1 <- data.frame(x = hist_df1$mids, y = hist_df1$counts)
hist_data2 <- data.frame(x = hist_df2$mids, y = hist_df2$counts)

# Histograma
hc_hist <- highchart() %>%
  hc_add_series(name = 'Set 1', data = list_parse(hist_data1), type = 'column') %>%
  hc_add_series(name = 'Set 2', data = list_parse(hist_data2), type = 'column') %>%
  hc_title(text = "Comparación de Histogramas")

# Mostrar el histograma
hc_hist


#################
# Densidad
#################

dens_data1 <- data.frame(x = dens_df1$x, y = dens_df1$y)
dens_data2 <- data.frame(x = dens_df2$x, y = dens_df2$y)

# Gráfico de Densidad
hc_dens <- highchart() %>%
  hc_add_series(name = 'Original', data = list_parse(dens_data1), type = 'line') %>%
  hc_add_series(name = 'Muestra', data = list_parse(dens_data2), type = 'line') %>%
  hc_title(text = "Comparación de Densidades")

# Mostrar el gráfico de densidad
hc_dens

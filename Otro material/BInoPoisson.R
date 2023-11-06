###############·################################
#  Datos simuulados de binomial + poisson
##############################################

# Carga las librerías necesarias
library(ggplot2)

###############
#  Binomial   #
###############


# Genera datos binomiales
n_binom <- 10000  # Número de observaciones
size <- 100       # Número de ensayos
prob <- 0.5      # Probabilidad de éxito
datos_binom <- rbinom(n_binom, size, prob)

# Grafica la distribución binomial en ggplot

ggplot(data.frame(Valor = datos_binom), aes(x = Valor)) +
  geom_histogram(binwidth = 1, fill = 'gray', color = 'black') +
  labs(title = "Distribución Binomial", x = "Número de éxitos", y = "Frecuencia")

# En densidad

ggplot(data.frame(Valor = datos_binom), aes(x = Valor)) +
  geom_density(fill = 'gray', color = 'black', alpha = 0.7) +  # alpha para transparencia
  labs(title = "Densidad de la Distribución Binomial", x = "Número de éxitos", y = "Densidad")



###############
#   Poisson   #
###############

# Parámetros para la distribución de Poisson
n_pois <- 10000  # Número de observaciones
lambda <- 40     # Tasa promedio de éxito

# Generar datos de Poisson
datos_pois <- rpois(n_pois, lambda)

# Añadir valores extremos manualmente
set.seed(123) # Para reproducibilidad
outliers <- c(sample(80:100, size = 10, replace = TRUE)) # Genera algunos valores extremos

# Combinar los datos de Poisson con los valores extremos
datos_pois_extremos <- c(datos_pois, outliers)


# Histograma

ggplot(data.frame(Valor = datos_pois_extremos), aes(x = Valor)) +
  geom_histogram(bins = 120, fill = 'gray', color = 'black') +
  labs(title = "Distribución de Poisson con valores extremos",
       x = "Número de eventos",
       y = "Frecuencia")

# Densidad

ggplot(data.frame(Valor = datos_pois_extremos), aes(x = Valor)) +
  geom_density(fill = 'gray', color = 'black', alpha = 0.7) +
  labs(title = "Densidad de la Distribución de Poisson con valores extremos",
       x = "Número de eventos",
       y = "Densidad")


##############################################
#    Con highcharter 
##############################################

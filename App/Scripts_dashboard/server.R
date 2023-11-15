############################
#   Contenido del server   # 
############################


###################################################################################
# El server se estructura como sigue                                              #
#                                                                                 #
# 1. Importación de los datos                                                     #
# 2. Análisis descriptivos de las variables de interés                            #
# 3. Cálculo del tamaño de muestra según la selección hecha en el body            #
# 4. Visualización de la selección de los elementos                               #
# 5. Descarga de las unidades de la muestra                                       #
# 6. Evaluación de la muestra según datos observados y auditados                  #
#                                                                                 #
###################################################################################

server <- function(input, output, session) {
  
  #################################################################################
  #################################################################################
  #                           Análisis descriptivo                                #
  #################################################################################
  #################################################################################
  
  ################################################
  #          Importar Datos: data                #
  ################################################
  
  
  # Leer los datos basados en el tipo de archivo
  
  data1 <- reactive({
    inFile <- input$file1
    
    if (is.null(inFile)) return(NULL)
    
    ext <- tools::file_ext(inFile$name)
    
    if (ext == "xlsx") {
      openxlsx::read.xlsx(inFile$datapath)
    } else if (ext == "csv") {  # Corregido aquí
      read.csv(inFile$datapath, stringsAsFactors = FALSE)
    } else if (ext == "txt") {  # Y aquí
      read.table(inFile$datapath, stringsAsFactors = FALSE, header = TRUE)
    } else {
      stop("Archivo no soportado.")
    }
  })
  
  # Selección de la variable
  
  output$variable_select_1 <- renderUI({
    if (is.null(data1())) {
      return(NULL)
    } else {
      selectInput("variable1", "Elija una variable:", names(data1()))
    }
  })
  

  # Genera datos binomiales
  n_binom <- 10000  # Número de observaciones
  size <- 100       # Número de ensayos
  prob <- 0.5       # Probabilidad de éxito
  datos_binom <- rbinom(n_binom, size, prob)
  
  # Genera datos de Poisson
  n_pois <- 10000  # Número de observaciones
  lambda <- 40     # Tasa promedio de éxito
  set.seed(123)    # Para reproducibilidad
  outliers <- c(sample(80:100, size = 10, replace = TRUE)) # Genera algunos valores extremos
  datos_pois_extremos <- c(rpois(n_pois, lambda), outliers)
  

    observeEvent(input$start_analysis, {
        # Tabla de estadísticas descriptivas
      
      
      
        output$stats <- renderReactable({
            req(data1())
          
          
          Datos <- as.data.frame(data1()[[input$variable1]])  %>% 
            dplyr::rename(
              Monto = `data1()[[input$variable1]]`
              
            )
          
          
          Stats <- Datos %>%
            
            summarise(  ValoresNegativos = sum(Monto < 0, na.rm = TRUE),
                        ValoresFaltantes = sum(is.na(Monto)),
                        Minimo = min(Monto, na.rm = TRUE),
                        Maximo = max(Monto, na.rm = TRUE),
                        Promedio = mean(Monto, na.rm = TRUE),
                        Mediana = median(Monto, na.rm = TRUE),
                        Moda = as.numeric(names(sort(table(Monto), decreasing = TRUE)[1])),
                        DesviacionEstandar = sd(Monto, na.rm = TRUE),
                        Percentil10 = quantile(Monto, 0.1, na.rm = TRUE),
                        Percentil25 = quantile(Monto, 0.25, na.rm = TRUE),
                        Percentil50 = quantile(Monto, 0.50, na.rm = TRUE),
                        Percentil75 = quantile(Monto, 0.75, na.rm = TRUE),
                        Percentil90 = quantile(Monto, 0.90, na.rm = TRUE)
                        
                        
                        
            ) %>% pivot_longer(
              cols = everything(),
              names_to = "Medida",
              values_to = "Valor"
            )  %>%
            mutate(Valor = round(Valor, 1))
          
          
          
          reactable(Stats, defaultPageSize = 15)
        })

        
        
        # Histograma de una variable
        output$histogram1 <- renderHighchart({
          
            req(data1(), input$variable1)
          
          
          req(input$variable1)
          
          datos <- as.data.frame(data1()[[input$variable1]])  %>% 
            dplyr::rename(
              Monto = `data1()[[input$variable1]]`
              
            )
          
          x = datos$Monto
          
          hist <-  hchart(density(x), type = "area", color = "skyblue", name = "Monto")  %>%
            
            hc_tooltip(crosshairs = T,valueDecimals = 1, shared = TRUE, borderWidth = 5) %>%
            hc_chart(
              zoomType = "xy"
            )
          
          hist 
        })

        
        
        # Gráfico binomial
        output$binomialPlot <- renderPlot({
          
          ggplot(data.frame(Valor = datos_binom), aes(x = Valor)) +
            geom_histogram(binwidth = 1, fill = 'skyblue', color = 'black') +
            labs(title = "Distribución Binomial", x = "", y = "Frecuencia")
          
        })
        
        

        # Gráfico de Poisson
        output$poissonPlot <- renderPlot({
          
          ggplot(data.frame(Valor = datos_pois_extremos), aes(x = Valor)) +
            geom_histogram(bins = 120, fill = 'skyblue', color = 'black') +
            labs(title = "Distribución de Poisson con valores extremos",
                 x = "", y = "Frecuencia")
          
        })
    })

    # ... (cualquier otro código que necesites)



  
  #################################################################################
  #################################################################################
  #                                  Muestreo                                     #
  #################################################################################
  #################################################################################
  
  
  ##############################
  #          Importar Datos    #
  ##############################
  
  # Data la volvemos un objeto reactivo 
  #  data ---> data()
  
  data2 <- reactive({
    inFile <- input$file2
    if (is.null(inFile)) {
      return(NULL)
    }
    read.csv(inFile$datapath)
  })
  
  
  # Histograma de una variable #
  
  output$variable_select <- renderUI({
    if (is.null(data2())) {
      return(NULL)
    } else {
      selectInput("variable2", "Elija una variable:", names(data2()))
    }
  })
  
  # Datos para la tabla de sugerencias de tamaño de muestra
  sugerencias_tamaño <- data.frame(
    `Tamaño de Muestra` = c("Pequeño (<=40)", "Mediano (50-100)", "Grande (100-400)"),
    `Margen de Tolerancia (Tolerable)` = c("0.2 - 0.3", "0.03 - 0.05", "0.01 - 0.03"),
    `Error Esperado` = c("0.05 - 0.10", "0.02 - 0.05", "0.01 - 0.02"),
    `Nivel de Confianza` = c("0.90 - 0.95", "0.95 - 0.99", "> 0.99")
  )
  
  # Genera la tabla reactiva
  output$SugerenciasTamaño <- renderReactable({
    reactable(sugerencias_tamaño, bordered = TRUE, highlight = TRUE)
    
    
  })
  
  
  # output$histogram2 <- renderPlot({
  #  if (is.null(input$variable)) {
  #    return(NULL)
  #  }
  #  ggplot(data(), aes_string(input$variable)) + geom_histogram(binwidth = 10) + labs(title = paste("Distribución de", input$variable), x = input$variable, y = "Frecuencia")
  # })
  
  
  #################################
  #    Cálculo tamaño muestra     #
  #################################
  
  # Objeto reactivo para el tamaño de muestra
  sample_size <- reactiveVal()  # Inicializa como un valor reactivo
  
  observeEvent(input$update, {  # Cuando 'update' se presiona, se ejecuta el código dentro de observeEvent
    stage1 <- planning(materiality = input$freq1, 
                       expected = input$freq2,
                       likelihood = input$distri, 
                       conf.level = input$freq3
    )
    
    sample_size(data.frame(`Muestra` = stage1$n))  # Asigna el valor al reactivo
  })
  
  # Renderizar la tabla de tamaño de muestra
  output$SampleSize <- renderReactable({
    req(sample_size())  # Asegúrate de que el valor reactivo no sea NULL
    reactable(sample_size())  # Renderiza el valor reactivo en una tabla
  })
  
  
  
  #################################
  #    Visualización de la tabla  #
  #################################
  
  # Objeto reactivo para la selección de las unidades
  Muestra <- reactive({
    req(input$update)  # Asegúrate de que el botón de actualizar se ha pulsado
    req(sample_size())  # Asegúrate de que el valor reactivo no sea NULL
    
    n_muestra <- sample_size()$Muestra
    datos <- data2()
    
    # Asegúrate de que hay datos para procesar
    if (is.null(datos) || is.null(n_muestra)) {
      return(NULL)
    }
    
    # Calcula las probabilidades de selección
    total_valor <- sum(datos[[input$variable2]], na.rm = TRUE)
    if (total_valor == 0) return(NULL)  # Evita división por cero
    
    prob_seleccion <- datos[[input$variable2]] / total_valor
    
    # Selecciona las unidades de la muestra según sus probabilidades
    set.seed(123)  # Establece una semilla para reproducibilidad
    muestra_ids <- sample(
      x = seq_len(nrow(datos)), 
      size = n_muestra, 
      replace = FALSE, 
      prob = prob_seleccion
    )
    
    # Devuelve las filas seleccionadas para la muestra
    datos[muestra_ids, ]
  })
  
  
  output$sample  <- renderReactable({
    
    req(Muestra())  # Asegúrate de que el objeto reactivo no sea NULL
    reactable(Muestra())  # Renderiza el objeto reactivo en una tabla
  })

  
  #################################################
  #    Comparación de datos originales y muestra  #
  #################################################
  
  output$comp_dist <- renderHighchart({
    # Asegúrate de que tanto los datos originales como la muestra estén disponibles
    req(data2(), Muestra(), input$variable2)
    
    # Calcular la densidad para los datos originales
    dens_orig <- density(data2()[[input$variable2]], na.rm = TRUE)
    dens_orig_df <- data.frame(x = dens_orig$x, y = dens_orig$y)
    
    # Calcular la densidad para la muestra
    dens_muestra <- density(Muestra()[[input$variable2]], na.rm = TRUE)
    dens_muestra_df <- data.frame(x = dens_muestra$x, y = dens_muestra$y)
    
    # Crear el gráfico de densidad comparativa
    highchart() %>%
      hc_add_series(name = "Datos Originales", data = list_parse(dens_orig_df), type = "area", color = "skyblue") %>%
      hc_add_series(name = "Muestra", data = list_parse(dens_muestra_df), type = "area", color = "green") %>%
      hc_tooltip(crosshairs = TRUE, valueDecimals = 1, shared = TRUE, borderWidth = 5) %>%
      hc_chart(zoomType = "xy") %>%
      hc_title(text = "Comparación de Densidades")
  })

  #################################
  #         Descargar muestra     #
  #################################
  
  observeEvent(input$show1, {
    
    showModal(modalDialog(
      title = "Descargar los datos ", br(),
      br(),
      downloadButton("download2.1",".csv file"),
      br(),
      br(),
      downloadButton("download2.2",".txt file"),
      br(),
      br(),
      downloadButton("download2.3",".xlsx file"),
      
      footer = modalButton("Close"),
      easyClose = TRUE)
    )
    
  })
  
  output$download2.1 <- downloadHandler(
    
    
    filename = function() {
      paste("Muestra-", Sys.Date(), ".csv", sep="")
    },
    
    content = function(file) {
      write.csv(Muestra(), file)
    }
  )
  
  output$download2.2 <- downloadHandler(
    
    filename = function() {
      paste("Muestra-", Sys.Date(), ".txt", sep="")
    },
    content = function(file) {
      write.table(Muestra(), file)
    }
  )
  
  output$download2.3 <- downloadHandler(
    filename = function() {
      paste("Muestra-", Sys.Date(), ".xlsx", sep="")
    },
    content = function(file) {
      # Suponiendo que Muestra() es una función que retorna el dataframe que quieres descargar
      write.xlsx(Muestra(), file)
    }
  )
  
  
  #################################################################################
  #################################################################################
  #                                  Evaluación                                   #
  #################################################################################
  #################################################################################
  
  ###### Datos a reactive 
  
  data3 <- reactive({
    inFile <- input$file3
    if (is.null(inFile)) {
      return(NULL)
    }
    read.csv(inFile$datapath)
  })
  
  
  ###### Variables
  
  output$var1 <- renderUI({
    selectInput("select_var1", "Seleccione Variable 1: Observado", names(data3()))
  })
  
  output$var2 <- renderUI({
    selectInput("select_var2", "Seleccione Variable 2: Auditado", names(data3()))
  })
  
  ##### Crear data frame reactive ---> DatosEval 
  
  DatosEval <- reactive({
    req(data3(), input$select_var1, input$select_var2)  # Asegúrate de que los datos y las entradas estén disponibles
    
    data3() %>%
      dplyr::rename(
        Observado = input$select_var1,
        Auditado = input$select_var2
      )
  })
  
  
  ###### Aplicar el boton activar 
  
  

  observeEvent(input$analizar, {
  
    
    
    # Dataframe de los datos 
    
    output$Tabla2 <- renderReactable({
      
      reactable(DatosEval())
      
    })
    
    # Scatter plot  de  datos de evaluación
    
    output$ScatterPlot <- renderHighchart({
      hc <- DatosEval() %>% 
        hchart('scatter', hcaes(x = Observado, y = Auditado)) %>% 
        hc_add_series(data = list_parse(data.frame(x = c(0, max(DatosEval()$Observado)), 
                                                   y = c(0, max(DatosEval()$Observado)))), 
                      type = 'line', name = 'y = x') %>% 
        
        hc_chart(zoomType = "xy")
      hc 
    })
    
    # Evaluación únicamente de las diferencias
    
    
    output$Tabla3 <- renderReactable({
      
      Diferencias <- DatosEval() %>%
        mutate(Diferencia = abs(Observado - Auditado)) %>%
        filter(Diferencia != 0) %>% 
        arrange(desc(Diferencia))
      
      reactable(Diferencias)
    })
    
    # Evaluación únicamente de las diferencias
    
    output$Riesgo <- renderReactable({
      
      Riesgo <- DatosEval() %>%
        mutate(Diferencia = abs(Observado - Auditado)) %>%
        filter(Diferencia != 0) %>% 
        arrange(desc(Diferencia))
      
      reactable(Riesgo)
    })
    
    # Creación de la función de indicadores de riesgo
    
    IndicadoresRiesgo <- function(datos) {
      suma_obs <- round(sum(datos$Observado, na.rm = TRUE), 1)
      suma_aud <- round(sum(datos$Auditado, na.rm = TRUE), 1)
      n_obs <- nrow(datos)
      n_aud <- nrow(datos)
      promedio_obs <- round(mean(datos$Observado, na.rm = TRUE), 1)
      promedio_aud <- round(mean(datos$Auditado, na.rm = TRUE), 1)
      conteo_dif <- sum(datos$Observado != datos$Auditado, na.rm = TRUE)
      sobrevaloraciones <- sum(datos$Observado > datos$Auditado, na.rm = TRUE)
      infravaloraciones <- sum(datos$Observado < datos$Auditado, na.rm = TRUE)
      suma_sobrevaloraciones <- round(sum(datos$Observado[datos$Observado > datos$Auditado] - datos$Auditado[datos$Observado > datos$Auditado], na.rm = TRUE), 1)
      suma_infravaloraciones <- round(sum(datos$Auditado[datos$Observado < datos$Auditado] - datos$Observado[datos$Observado < datos$Auditado], na.rm = TRUE), 1)
      dif_total <- round(sum(abs(datos$Observado - datos$Auditado), na.rm = TRUE), 1)
      porcentaje_dif <- round((dif_total / suma_aud) * 100, 1)
      
      data.frame(
        Indicador = c("Suma total Observados", "Suma total Auditados", "n Observados", "n Auditados", 
                      "Monto promedio Observado", "Monto promedio Auditado", "Conteo Observados vs Auditado",
                      "Cantidad de sobrevaloraciones", "Cantidad de infravaloraciones",
                      "Diferencia total Observados y Auditados", "Suma de sobrevaloraciones", 
                      "Suma de infravaloraciones", "Porcentaje de diferencia"),
        Valor = c(suma_obs, suma_aud, n_obs, n_aud, promedio_obs, promedio_aud, conteo_dif, 
                  sobrevaloraciones, infravaloraciones, dif_total, suma_sobrevaloraciones, 
                  suma_infravaloraciones, porcentaje_dif)
      )
    }
    
    # Tabla de los indicadores de riesgo  
    
    output$Riesgo <- renderReactable({
      req(DatosEval())  # Asegúrate de que DatosEval esté disponible
      tabla_riesgo <- IndicadoresRiesgo(DatosEval())
      reactable(tabla_riesgo)
    })
    
    calculaIndicadoresAudit <- function(datos) {
      precision_total <- 1 - sum(abs(datos$Observado - datos$Auditado)) / sum(datos$Observado)
      error_bruto_probable <- max(abs(datos$Observado - datos$Auditado))
      error_neto_probable <- sum(datos$Observado - datos$Auditado)
      limite_error_bruto <- mean(abs(datos$Observado - datos$Auditado)) + qnorm(0.95) * sd(abs(datos$Observado - datos$Auditado))
      limite_error_neto <- mean(datos$Observado - datos$Auditado) + qnorm(0.95) * sd(datos$Observado - datos$Auditado)
      
      data.frame(
        Indicador = c("Precisión Total", "Error Bruto Más Probable", "Error Neto Más Probable", 
                      "Límites de Error Superior Bruto", "Límite de Error Superior Neto"),
        Valor = round(c(precision_total, error_bruto_probable, error_neto_probable, limite_error_bruto, limite_error_neto), 1)
      )
    }
    
    output$Audit <- renderReactable({
      req(DatosEval())  # Asegúrate de que DatosEval esté disponible
      tabla_audit <- calculaIndicadoresAudit(DatosEval())
      reactable(tabla_audit)
    })
    
    output$ScatterPlot_limit <- renderHighchart({
      req(DatosEval())  # Asegúrate de que los datos están disponibles
      
      # Calcular los límites de confianza
      std_dev <- sd(DatosEval()$Observado - DatosEval()$Auditado, na.rm = TRUE)
      limite_inferior <- -1.96 * std_dev
      limite_superior <- 1.96 * std_dev
      
      # Crear el gráfico de dispersión base
      hc <- DatosEval() %>% 
        hchart('scatter', hcaes(x = Observado, y = Auditado)) %>% 
        hc_add_series(data = list_parse(data.frame(x = c(0, max(DatosEval()$Observado)), 
                                                   y = c(0, max(DatosEval()$Observado)))), 
                      type = 'line', name = 'y = x')  %>%
        hc_add_series(data = list_parse(data.frame(x = c(0, max(DatosEval()$Observado)), 
                                                   y = c(limite_inferior, limite_inferior + max(DatosEval()$Observado)))), 
                      type = 'line', name = 'Límite Inferior' , color = "blue") %>%
        hc_add_series(data = list_parse(data.frame(x = c(0, max(DatosEval()$Observado)), 
                                                   y = c(limite_superior, limite_superior + max(DatosEval()$Observado)))), 
                      type = 'line', name = 'Límite Superior', color = "blue") %>% 
        
        hc_chart(zoomType = "xy")
      
      hc
    })
    
    calculaIndicadoresEvaluacion <- function(datos) {
      # Monto en diferencia total Observados y Auditados
      monto_diferencia_total <- sum(abs(datos$Observado - datos$Auditado))
      
      # Porcentaje de diferencia
      porcentaje_diferencia <- (monto_diferencia_total / sum(datos$Auditado)) * 100
      
      # Conteo Observados vs Auditado
      conteo_diferencias <- sum(datos$Observado != datos$Auditado)
      
      # Casos que son superiores o inferiores a los límites de confianza
      std_dev <- sd(datos$Observado - datos$Auditado)
      limite_inferior <- -1.96 * std_dev
      limite_superior <- 1.96 * std_dev
      casos_fuera_limites <- sum(datos$Observado - datos$Auditado < limite_inferior | 
                                   datos$Observado - datos$Auditado > limite_superior)
      
      data.frame(
        Indicador = c("Monto Diferencia Total", "Porcentaje de Diferencia", 
                      "Conteo Diferencias", "Casos Fuera de Límites"),
        Valor = round(c(monto_diferencia_total, porcentaje_diferencia, 
                        conteo_diferencias, casos_fuera_limites), 2)
      )
    }
    
    
 ###########Tabla final de evaluación   ###########
    
      # Supongamos que DatosEval es tu dataframe reactivo
    
    # Función para calcular los umbrales de decisión
    calculaUmbralDecision <- function(datos) {
      fraccion_monto_auditado <- 0.01 * sum(datos$Auditado)
      porcentaje_diferencia_umbral <- 1
      conteos_diferencias_umbral <- 10
      casos_fuera_limites_umbral <- 5
      
      c(fraccion_monto_auditado, porcentaje_diferencia_umbral, 
        conteos_diferencias_umbral, casos_fuera_limites_umbral)
    }
    
    # Función para calcular los indicadores de decisión y decisiones
    calculaIndicadoresDecision <- function(datos) {
      umbrales <- calculaUmbralDecision(datos)
      
      monto_diferencia_total <- round(sum(abs(datos$Observado - datos$Auditado)),1)
      porcentaje_diferencia <- round((monto_diferencia_total / sum(datos$Auditado)) * 100,1)
      conteo_diferencias <- sum(datos$Observado != datos$Auditado)
      
      std_dev <- sd(datos$Observado - datos$Auditado, na.rm = TRUE)
      limite_inferior <- -1.96 * std_dev
      limite_superior <- 1.96 * std_dev
      casos_fuera_limites <- sum(datos$Observado - datos$Auditado < limite_inferior | 
                                   datos$Observado - datos$Auditado > limite_superior)
      
      valores <- c(monto_diferencia_total, porcentaje_diferencia, 
                   conteo_diferencias, casos_fuera_limites)
      
      decisiones <- ifelse(valores < umbrales, "Aceptable", "No es aceptable")
      
      data.frame(
        Indicador = c("Monto Diferencia Total", "Porcentaje de Diferencia", 
                      "Conteo Diferencias", "Casos Fuera de Límites"),
        Valor = valores,
        Criterio = umbrales,
        Decision = decisiones
      )
    }
    
  
      output$Eval <- renderReactable({
        req(DatosEval())  # Asegúrate de que DatosEval esté disponible
        tabla_decision <- calculaIndicadoresDecision(DatosEval()) %>% dplyr::select("Indicador", "Valor", "Criterio", "Decision")
        reactable(tabla_decision)
          
        
      })


    
    
    
  })
  
  
  
  
  # Structura #
  
  

  
}